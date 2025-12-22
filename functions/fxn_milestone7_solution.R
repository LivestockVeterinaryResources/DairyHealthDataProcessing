library(tidyverse)

solution <- read_parquet(
  '../data/intermediate_files/events_all_columns.parquet') |> 
  select(id_animal, date_birth, 
         date_fresh,lact_number, 
         date_archived, date_event,
         event, 
         remark_letters1, protocols_letters1, 
         R, `T`, B, location_event)  