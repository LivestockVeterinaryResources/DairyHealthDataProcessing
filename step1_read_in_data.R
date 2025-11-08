

library(tidyverse)
library(dtplyr)
library(gt)
library(arrow)


#read in functions -------------------
source('functions/fxn_parse_free_text.R') #functions to parse remarks and protocols
source('functions/fxn_event_type.R') #custom function to categorize events
source('functions/fxn_location.R') #custom function to specify event location
source('functions/fxn_de_duplicate.R') #removes duplicated rows


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
  
  #check colnames ------------------
  event_columns<-colnames(df)
  source('functions/fxn_fix_item_names.R') #standardize column names for known variation in column names
  
  events<-bind_rows(events, df)
}



#add a stop function here if all expected columns do not exist


#initial cleanup ---------------------------
events2 <- events|>
  lazy_dt() |> 
  select(-starts_with('...')) |> #get rid of extra columns created by odd parsing in the original csv file, there is a better fix to the parsing issue, someday we should improve this
  ##create unique cow id--------------------------------------- 
  fxn_assign_id_animal()%>%
  ## name the breed variable--------------------
  mutate(breed = CBRD)|>
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
  ## de deuplicates rows (or not) according to setting--------------
  fxn_de_duplicate()|>
  ##replace missing values in remark and protocols to allow grouping later----------------
  mutate(protocols = str_replace_na(Protocols, 'BLANK_UNKNOWN'), 
       remark = str_replace_na(Remark, 'BLANK_UNKNOWN'),
       event = str_replace_na(Event, 'BLANK_UNKNOWN'))|>
  
  ##add standard event types-----------------
  fxn_assign_event_type_default()|>
  ##add event location --------------
  fxn_assign_location_event()|>
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
      TRUE~'Unknown'), 
    lact_group_5 = case_when(
      (lact_number == 0)~'Heifer', 
      (lact_number ==1)~'LACT 1',
      (lact_number ==2)~'LACT 2',
      (lact_number ==3)~'LACT 3',
      (lact_number ==4)~'LACT 4',
      (lact_number >4)~'LACT 5+',
      TRUE~'Unknown')
  )





#write out files-----------------------

# main file ------------
write_parquet(events2, 'data/intermediate_files/events_all_columns.parquet') # this file is for if you wanted to chase a problem between original and formatted file without re-running step1

# formatted file -----------------------
write_parquet(events2%>%
                select(source_file_path, 
                       id_animal, 
                       date_birth, breed, #eid, 
                       date_enrolled, qc_diff_bdat_edat,
                       id_animal_lact, date_fresh, date_archived, 
                       lact_number, lact_group_basic, lact_group, lact_group_repro, lact_group_5,
                       event_type, event, remark, contains('remark'), protocols, contains('protocols'), 
                       technician, date_event, dim_event, location_event, locate_lesion, 
                       R, `T`, B, date_heat, date_concieved, date_aborted, date_repro_dx,
                       contains('custom_')), 
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
  group_by(location_event, Event, Protocols, event_type)|>
  summarize(count = sum(n()), 
            list_remark_letters1 = paste0(remark_letters1))|>
  ungroup()

write_parquet(qc_event_type, 'data/qc_files/qc_event_type.parquet')











