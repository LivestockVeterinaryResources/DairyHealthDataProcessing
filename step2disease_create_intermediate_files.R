
library(tidyverse)


events_parsed<-read_parquet('data/intermediate_files/events_parsed.parquet')



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


