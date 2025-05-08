

library(tidyverse)
library(dtplyr)
library(gt)
library(arrow)
library(janitor)

#read in files-----------------

list_files<-list.files('data/milk_files') #folder name where event files are located

production_data <- NULL

for (i in seq_along(list_files)){
  df<-read_csv(paste0('data/milk_files/', 
                      list_files[i]), 
               #reads in all data as character string
               col_types = cols(.default = 'c'))|> 
    mutate(source_file_path = paste0('data/milk_files/', list_files[i])
    ) 
  
  production_data<-bind_rows(milk, df)
}


#initial cleanup ---------------------------

production_data2 <- production_data |> 
  clean_names() |>
  rename(milk_305_me = x305me) |> 
  mutate(
    id_animal = paste0(as.character(id), "_", as.character(bdat)),
    id_animal_lact = paste0(id, "_", bdat, "_", lact),
    date_test = mdy(test_date),
    date_birth = mdy(bdat),
    milk = as.numeric(gsub("\\*", "", milk)),
    across(c(pctf, pctp, fcm, milk_305_me, relv,
             scc, lgscc, pen, mun ), as.numeric)
    ) |> 
  relocate(c(id_animal, date_birth, date_test, pen),
           .before = everything())  |> 
  select(-c(id, test_date, fdat ))
 
write_parquet(production_data, 'data/production_data.parquet')

rm(production_data, production_data2)











