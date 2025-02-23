

library(tidyverse)
library(dtplyr)
library(gt)
library(arrow)


#read in functions -------------------
source('functions/fxn_parse_free_text.R') #functions to parse remarks and protocols
source('functions/fxn_event_type.R') #c function to categorize events
source('functions/fxn_location.R') #custom function to specify event location


#set custom functions
fxn_parse_remark<-fxn_parse_remark_default # parse_free_text options: fxn_parse_remark_default, fxn_parse_remark_custom

fxn_parse_protocols<-fxn_parse_protocols_default #parse_free_text options: fxn_parse_protocols_default, fxn_parse_protocols_custom

fxn_assign_location_event<-fxn_assign_location_event_default #location_event options: fxn_assign_location_event_default, fxn_assign_location_event_custom

fxn_event_type<-fxn_assign_event_type_default #event_type options: fxn_assign_event_type_default, fxn_assign_event_type_custom

fxn_detect_location_lesion<-fxn_detect_location_lesion_default #detect_location_lesion options: fxn_detect_location_lesion_default, fxn_detect_location_lesion_custom


#read in files-----------------

list_files<-list.files('data/event_files') #folder name where event files are located

events<-NULL

for (i in seq_along(list_files)){
  df<-read_csv(paste0('data/event_files/', 
                      list_files[i]), 
               #reads in all data as character string
               col_types = cols(.default = 'c'))|> 
    mutate(remark = str_replace_all(Remark, "[^[:alnum:]]", "_"), #gets rid of weird characters that mess up encoding or parsing
           source_file_path = paste0('data/event_files/', list_files[i])
    ) 
  
  events<-bind_rows(events, df)
}

#check colnames ------------------
event_columns<-colnames(events)

#fix column names----------------------
source('functions/fxn_fix_item_names.R')

#add a stop function here if all expected columns do not exist

#initial cleanup ---------------------------
events2 <- events|>
  lazy_dt() |> 
  select(-starts_with('...')) |> #get rid of extra columns created by odd parsing in the original csv file, there is a better fix to the parsing issue, someday we should improve this
  ##create unique cow id--------------------------------------- 
  mutate(id_animal = paste0(ID, '_', BDAT), 
       id_animal_lact = paste0(ID, '_', BDAT, '_', LACT), 
       breed = CBRD)|>
  ##format dates--------------------------------------- 
  mutate(date_event = lubridate::mdy(Date), 
       
       date_birth = lubridate::mdy(BDAT), 
       
       date_fresh = lubridate::mdy(FDAT), 
       date_dry = lubridate::mdy(DDAT),
       
       date_enrolled = lubridate::mdy(EDAT), 
       date_archived = lubridate::mdy(ARDAT),
       
       date_heat = lubridate::mdy(HDAT), #unnecessary to pull
       date_concieved = lubridate::mdy(CDAT), #unnecessary to pull
       date_aborted = lubridate::mdy(ABDAT), #unnecessary to pull
       date_repro_dx = lubridate::mdy(PODAT) #unnecessary to pull
       )|>
  ##parse numbers -------------------
  mutate(dim_event = parse_number(DIM), 
       lact_number = parse_number(LACT))|>
  arrange(id_animal, date_event)|>
  # dedups to get but ignores source file
  distinct(across(-c(source_file_path)),
           .keep_all = TRUE)|>
  ##replace missing values in remark and protocols to allow grouping later----------------
  mutate(protocols = str_replace_na(Protocols, 'BLANK_UNKNOWN'), 
       remark = str_replace_na(Remark, 'BLANK_UNKNOWN'),
       event = str_replace_na(Event, 'BLANK_UNKNOWN'))|>
  
  ##add standard event types-----------------
  fxn_assign_event_type_default()|>
  ##add event location --------------
  fxn_assign_location_event_default()|>
  ##parse remarks and protocols-----------------
  fxn_parse_remark()|>
  fxn_parse_protocols()|>
  ##detect lesion location---------------------
  fxn_detect_location_lesion()|>
    ##qc enrollment---------------------
  mutate(qc_diff_bdat_edat = as.numeric(date_enrolled-date_birth)
         ) |> 
  as_tibble()



#create event type template---------------------
template_event_type <- events2|>
  group_by(Event,Protocols, event_type)|>
  summarize(#list_protocols = paste0(sort(unique(Protocols)), collapse = ', '), 
    count_rows = sum(n()))|>
  ungroup()

write_csv(template_event_type, 'data/template_files/template_event_type.csv') #this is intentionally a csv because it is a template to be edited

#create event details template---------------------
template_event_type <- events2|>
  group_by(Event, Remark, Protocols, event_type)|>
  summarize(
    count_rows = sum(n()))|>
  ungroup()

write_parquet(template_event_type, 'data/template_files/template_event_details.parquet')
write_csv(template_event_type, 'data/template_files/template_event_details.csv')

#add custom variables (optional)
#define event types------------------------------------
events2 <-events2|>
  #fix na values-------------
mutate(technician = Technician, 
       eid = EID)|> 
  
  mutate(across(
    .cols = c(event_type, breed, location_event, locate_lesion, technician, eid), 
    ~replace_na(., "Unknown")
  ))|>
  
  # create lactation groups ---------------------intentionally not a function so it is obvious...but could make it a function
  mutate(
    lact_group_basic = case_when(
      (lact_number == 0)~'Heifer', 
      (lact_number >0)~'LACT > 0',
      TRUE~'Unknown'), 
    lact_group_repro = case_when(
      (lact_number == 0)~'Heifer', 
      (lact_number ==1)~'LACT 1',
      (lact_number >1)~'LACT 2+',
      TRUE~'Unknown'),
    lact_group = case_when(
      (lact_number == 0)~'Heifer', 
      (lact_number ==1)~'LACT 1',
      (lact_number ==2)~'LACT 2',
      (lact_number >2)~'LACT 3+',
      TRUE~'Unknown')
  )





#write out files-----------------------

# main file ------------
write_parquet(events2, 'data/intermediate_files/events_all_columns.parquet') # this file is for if you wanted to chase a problem between original and formatted file without re-running step1

# formatted file -----------------------
write_parquet(events2%>%
                select(source_file_path, 
                       id_animal, date_birth, breed, eid, date_enrolled, qc_diff_bdat_edat,
                       id_animal_lact, date_archived, 
                       lact_number, lact_group_basic, lact_group, lact_group_repro,
                       event_type, event, remark, contains('remark'), protocols, contains('protocols'), 
                       technician, date_event, dim_event, location_event, locate_lesion, 
                       R, `T`, B, date_heat, date_concieved, date_aborted, date_repro_dx
                       ), 
              'data/intermediate_files/events_formatted.parquet')


# data quality files------------
qc_animal_enrollment<-events2|>
  mutate(qc_valid_enrollment = case_when(
    (qc_diff_bdat_edat==0)~'Valid', 
    TRUE~'Not Valid'))|>
  group_by(qc_valid_enrollment)|>
  summarize(ct_animals = n_distinct(id_animal))|>
  ungroup()

write_parquet(qc_animal_enrollment, 'data/qc_files/qc_animal_enrollment.parquet')

qc_event_type<-events2|>
  filter(event_type %in% 'Unknown')|>
  group_by(Event, Protocols, event_type)|>
  summarize(count = sum(n()))|>
  ungroup()

write_parquet(qc_event_type, 'data/qc_files/qc_event_type.parquet')











