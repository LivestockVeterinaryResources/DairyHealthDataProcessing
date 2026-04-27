

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

list_files<-list.files('data/milk_files') #folder name where event files are located

production<-NULL

for (i in seq_along(list_files)){
  df<-read_csv(paste0('data/milk_files/', 
                      list_files[i]), 
               #reads in all data as character string
               col_types = cols(.default = 'c'))|> 
    mutate(source_file_path = paste0('data/milk_files/', list_files[i])
    ) 
  
  production<-bind_rows(production, df)
}

#check colnames ------------------
production_columns<-colnames(production)

#fix column names----------------------
source('functions/fxn_fix_item_names_prod.R')

#add a stop function here if all expected columns do not exist

#initial cleanup ---------------------------
production2 <- production|>
  lazy_dt() |> 
  select(-starts_with('...')) |> #get rid of extra columns created by odd parsing in the original csv file, there is a better fix to the parsing issue, someday we should improve this
  ##create unique cow id--------------------------------------- 
  mutate(id_animal = paste0(ID, '_', BDAT), 
       id_animal_lact = paste0(ID, '_', BDAT, '_', LACT), 
       breed = CBRD)|>
  ##format dates--------------------------------------- 
  mutate(date_test = lubridate::mdy(TestDate), 
       
       date_birth = lubridate::mdy(BDAT), 
       
       date_fresh = lubridate::mdy(FDAT)
       )|>
  ##parse numbers -------------------
  mutate(dim_test = parse_number(DIM),
         pen = parse_number(PEN),
       lact_number = parse_number(LACT),
       milk = parse_number(MILK),
       fat_pct = parse_number(PCTF),
       prot_pct = parse_number(PCTP),
       milk_fcm = parse_number(FCM),
       milk_305ME = parse_number(`305ME`),
       relv = parse_number(RELV),
       scc = parse_number(SCC),
       linear_score = parse_number(LGSCC),
       mun = parse_number(MUN)
       )|>
  arrange(id_animal, date_test)|>
  # dedups to get but ignores source file
  distinct(across(-c(source_file_path)),
           .keep_all = TRUE)|>
  ##add event location --------------
fxn_assign_location_event_default()|>
  as_tibble()


#add custom variables (optional)
#define event types------------------------------------
production2 <- production2 |>
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
write_parquet(production2, 'data/intermediate_files/production_all_columns.parquet') # this file is for if you wanted to chase a problem between original and formatted file without re-running step1

# formatted file -----------------------
write_parquet(production2%>%
                select(source_file_path, 
                       id_animal, date_birth, breed, 
                       id_animal_lact,  
                       lact_number, lact_group_basic, lact_group, lact_group_repro, lact_group_5,
                       date_test, dim_test, location_event,  pen,
                       milk, milk_fcm, milk_305ME, fat_pct, prot_pct,
                       scc, linear_score, mun, relv
                       ), 
              'data/intermediate_files/production_formatted.parquet')













