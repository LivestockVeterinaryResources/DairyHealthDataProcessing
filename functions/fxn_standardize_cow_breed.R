library(tidyverse)

#by default breeds at less than 5% will be classified as "other"
#you can modify the % in the function call by setting the default_pct

fxn_standardze_cow_breed<-function(df, default_pct = 0.05){ 
  get_breeds<-df%>%
    mutate(total_cows = n_distinct(id_animal))%>%
    ungroup()%>%
    group_by(breed, total_cows)%>%
    summarize(ct_animals = n_distinct(id_animal))%>%
      ungroup()%>%
    mutate(pct = ct_animals/total_cows)%>%
    mutate(breed_simple = case_when(
      (breed %in% '-')~'Unknown', 
      (pct>default_pct)~breed, 
      TRUE~'Other'
    ))
  
  # only_others<-get_breeds%>%
  #   filter(breed_simple %in% 'Other')%>%
  #   distinct()
  #   
  # list_others<-paste0(sort(unique(only_others$breed)), collapse = ',')|>
  #   strsplit(",") |>                 # split by commas
  #   unlist() |>
  #  # setdiff("-") |>                  # remove "-"
  #   unique() |>
  #   sort() |>
  #   paste(collapse = ",")
  
  df%>%
    left_join(get_breeds%>%select(breed, breed_simple))

}

# 
# check<-animals%>%filter(breed %in% 'C,H,J')
# 
# test<-read_parquet('data/intermediate_files/events_all_columns.parquet')%>%
#   filter(id_animal %in% check$id_animal)%>%
#   arrange(id_animal, date_event)%>%
#   select(location_event, breed, ID, date_birth, date_event, event, remark, protocols, everything())
