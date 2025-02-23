


library(tidyverse)
library(arrow)
library(dtplyr)


source('functions/fxn_lag_master.R')
source('functions/fxn_locate_lesion.R')

source('functions/fxn_disease.R')
source('functions/fxn_treatment.R')

source('functions/fxn_parse_free_text.R') #functions to parse remarks and protocols
source('functions/fxn_location.R') #custom function to specify event location

#***Match disease function to selected events***
## make a function to detect what to pick?
fxn_assign_disease<-fxn_assign_disease_mastitis 
#***Match treatment function to selected events***
fxn_assign_treatment<-fxn_assign_treatment_template 


#read in file-----------------

events_formatted<-read_parquet('data/intermediate_files/events_formatted.parquet')|>
  #filter(!(is.na(bdat)))|> 
  mutate(data_pull_date_min = min(date_event, na.rm = TRUE))|>
  mutate(data_pull_date_max = max(date_event, na.rm = TRUE))|>
  rowid_to_column()



#animals events---------------

##animals - each row is an animal------------
animals<-events_formatted|>
  group_by(id_animal, date_birth, 
           #source_farm, source_state, #optional
           data_pull_date_min, data_pull_date_max)|>
  summarize(breed = paste0(sort(unique(breed)), collapse = ','))|>
  ungroup()

##enrolled - each row is an animal------------
enrolls<-events_formatted|>
  group_by(id_animal)|>
  summarize(date_enrolled = min(date_event), 
            date_enrolled_max = max(date_event))|>
  ungroup()|>
  distinct()|>
  mutate(qc_date_enrolled = as.numeric(date_enrolled_max-date_enrolled))


##deads - each row is animal---------------
deads<-events_formatted|>
  filter(event == 'DIED')|>
  group_by(id_animal)|>
  summarize(date_died = min(date_event), 
            date_died_max = max(date_event))|>
  ungroup()|>
  distinct()|>
  mutate(qc_date_died_diff = as.numeric(date_died_max-date_died))

##solds - each row is animal---------
solds<-events_formatted|>
  filter(event == 'SOLD')|>
  group_by(id_animal)|>
  summarize(date_sold = min(date_event), 
            date_sold_max = max(date_event))|>
  distinct()|>
  mutate(date_sold_diff = as.numeric(date_sold_max-date_sold))

#master animals------------------------------------------------
master_animals<-animals|>
  left_join(enrolls)|>
  left_join(solds)|>
  left_join(deads)|>
  mutate(date_left = case_when(
    (is.na(date_died)<1)~date_died,
    (is.na(date_sold)<1)~date_sold,
    TRUE~lubridate::mdy(NA))
  )|>
  mutate(age_left = as.numeric(date_left-date_birth))|>
  mutate(age_enrolled = as.numeric(date_enrolled-date_birth))

write_parquet(master_animals, 'data/intermediate_files/animals.parquet')



#animal lactation events

#animal_lactations - each row is an animal/lactation----------
animal_lactations<-events_formatted|>
  group_by(id_animal, id_animal_lact, lact_number, 
           lact_group, lact_group_basic, lact_group_repro
           )|>
  summarize(date_lact_first_event = min(date_event), 
            date_lact_last_event = max(date_event))|>
  ungroup()

##archives - each row is animal/lactation-----------
archives<-events_formatted|>
  select(id_animal_lact, date_archived)|>
  distinct()|>
  group_by(id_animal_lact)|>
  summarize(date_archive = min(date_archived), 
            date_archive_max = max(date_archived))|>
  distinct()|>
  mutate(date_archive_diff = as.numeric(date_archive_max-date_archive))

##freshs - each row is animal/lactation------------
freshs<-events_formatted|>
  filter(event == 'FRESH')|>
  group_by(id_animal_lact)|>
  summarize(date_fresh = min(date_event), 
            date_fresh_max = max(date_event))|>
  distinct()|>
  mutate(qc_date_fresh_diff = as.numeric(date_fresh_max-date_fresh))



##drys - each row is animal/lacatation----------------
drys<-events_formatted|>
  filter(event == 'DRY')|>
  group_by(id_animal_lact)|>
  summarize(date_dry = min(date_event), 
            date_dry_max = max(date_event))|>
  distinct()|>
  mutate(date_dry_diff = as.numeric(date_dry_max-date_dry))

#master animal_lactation events-----------------

master_animal_lactations<-animal_lactations|>
  left_join(freshs)|>
  left_join(drys)|>
  left_join(archives)|>
  mutate(date_dim30 = date_fresh+30, 
         date_dim60 = date_fresh+60, 
         date_dim90 = date_fresh+90, 
         date_dim120 = date_fresh+120,
         date_dim150 = date_fresh+150, 
         date_dim200 = date_fresh+200, 
         date_dim305 = date_fresh+305, 
         dim_at_archive = as.numeric(date_archive-date_fresh))

write_parquet(master_animal_lactations, 'data/intermediate_files/animal_lactations.parquet')




#select events----------------------------


events_selected<-events_formatted%>%
  #filter(id_animal %in% '26172_08/22/16')|> #for testing
  filter(event %in% list_selected_events) #can use str_detect if desired



#parse events-------------------------


events_parsed<-events_selected%>%
  fxn_assign_disease()%>% #creates disease variable, function can be customized
  fxn_assign_treatment()%>% #creates treatment variable, function can be customized
  mutate(across(.cols = c(disease, treatment), 
                .fns = ~str_replace_na(.x, 'Unknown') )) #removes NA from disease and treatment variables






#disease at animal level ---------------------

arrange_vars <- alist(id_animal, disease, date_event) #must have a date variable, no quotes

sort_vars <- c('id_animal',  'disease') #does NOT have a date variable, must have quotes

##Gap1 ----------------------

#set_outcome_gap_animal<- 1

selected_animal_level_events_assign_gap<-test_fxn1(x = events_parsed%>%
                                                     mutate(date = date_event),
                                                   arrange_var = arrange_vars,
                                                   mutate_var = sort_vars,
                                                   prefix = "gap1_",
                                                   gap = set_outcome_gap_animal)%>% #gap set to identify regimens
  rename(gap1_key = key,
         gap1_date_gap = date_gap,
         gap1_ct = lag_ct)%>%
  select(-(contains('lag')))



n_distinct(selected_animal_level_events_assign_gap$gap1_key) #for testing



##create long format disease--------------
disease_animal_level_long<-selected_animal_level_events_assign_gap%>%
  lazy_dt() |> 
  group_by(id_animal, disease, gap1_key)%>%
  summarize(date_disease_first = min(date_event), 
            date_disease_last = max(date_event), 
            list_events = paste0(event, collapse = ','), 
            list_remarks = paste0(remark, collapse = ','), 
            list_protocols = paste0(protocols, collapse = ','), 
            list_treatments = paste0(treatment , collapse = ','),
            list_locate_lesion = paste0(locate_lesion, collapse = ','), 
            list_events_simple = paste0(sort(unique(event)), collapse = ','), 
            list_remarks_simple = paste0(sort(unique(remark)), collapse = ','), 
            list_protocols_simple = paste0(sort(unique(protocols)), collapse = ','), 
            list_locate_lesion_simple = paste0(sort(unique(locate_lesion)), collapse = ',')
            )%>%

  ungroup()%>%
  as_tibble()|>
  arrange(id_animal, disease, date_disease_first, date_disease_last)%>%
  group_by(id_animal, disease)%>%
  mutate(disease_count = 1:n(), 
         disease_count_max = sum(n()), 
         disease_date_last = max(date_disease_last))|>
  ungroup()%>%
  mutate(disease_detail = paste0(disease, '_', disease_count))

write_parquet(disease_animal_level_long, 'data/intermediate_files/disease_animal_level_long.parquet')

##create wide format disease----------------
disease_animal_level_wide<-disease_animal_level_long%>%
  select(id_animal, disease, disease_date_last, disease_detail, date_disease_first)|>
  pivot_wider(names_from = disease_detail, 
              values_from = date_disease_first)




#disease at lactation level --------------



arrange_vars <- alist(id_animal, id_animal_lact, disease, date_event) #must have a date variable, no quotes

sort_vars <- c('id_animal', 'id_animal_lact',  'disease') #does NOT have a date variable, must have quotes

##Gap1 ----------------------



selected_lactation_level_events_assign_gap<-test_fxn1(x = events_parsed%>%
                                                        mutate(date = date_event),
                                                      arrange_var = arrange_vars,
                                                      mutate_var = sort_vars,
                                                      prefix = "gap1_",
                                                      gap = set_outcome_gap_lactation)%>% #gap set to identify regimens
  rename(gap1_key = key,
         gap1_date_gap = date_gap,
         gap1_ct = lag_ct)%>%
  select(-(contains('lag')))



n_distinct(selected_lactation_level_events_assign_gap$gap1_key) #for testing



##create long format disease---------------
disease_lactation_level_long<-selected_lactation_level_events_assign_gap%>%
  lazy_dt() |> 
  group_by(id_animal, id_animal_lact, disease, gap1_key)%>%
  summarize(date_disease_first = min(date_event), 
            date_disease_last = max(date_event), 
            dim_disease_first = min(dim_event, na.rm = T), 
            dim_disease_last = max(dim_event, na.rm = T), 
            list_events = paste0(event, collapse = ','), 
            list_remarks = paste0(remark, collapse = ','), 
            list_protocols = paste0(protocols, collapse = ','), 
            list_treatments = paste0(treatment, collapse = ','), 
            list_locate_lesion = paste0(locate_lesion, collapse = ','), 
            list_events_simple = paste0(sort(unique(event)), collapse = ','), 
            list_remarks_simple = paste0(sort(unique(remark)), collapse = ','), 
            list_protocols_simple = paste0(sort(unique(protocols)), collapse = ','), 
            list_locate_lesion_simple = paste0(sort(unique(locate_lesion)), collapse = ','))%>%

  ungroup()|> 
  as_tibble()%>%
  arrange(id_animal, id_animal_lact, disease, date_disease_first, date_disease_last)%>%
  group_by(id_animal, id_animal_lact, disease)%>%
  mutate(disease_count = 1:n(), 
         disease_count_max = sum(n()), 
         disease_date_last = max(date_disease_last))|>
  ungroup()%>%
  mutate(disease_detail = paste0(disease, '_', disease_count))


write_parquet(disease_lactation_level_long, 'data/intermediate_files/disease_lactation_level_long.parquet')

##create wide format disease----------------
disease_lactation_level_wide<-disease_lactation_level_long%>%
  select(id_animal, id_animal_lact, disease, disease_date_last, disease_detail, date_disease_first)|>
  pivot_wider(names_from = disease_detail, 
              values_from = date_disease_first)


#write out disease files------------------
##animal level--------------
master_disease_animal_level_wide<-master_animals%>%
  left_join(disease_animal_level_wide)

write_parquet(master_disease_animal_level_wide, 'data/intermediate_files/disease_animal_level_wide.parquet')

##lactation level------------------------------------------
master_disease_lactation_level_wide<-master_animal_lactations%>%
  left_join(master_animals)%>%
  left_join(disease_lactation_level_wide)

write_parquet(master_disease_lactation_level_wide, 'data/intermediate_files/disease_lactation_level_wide.parquet')



