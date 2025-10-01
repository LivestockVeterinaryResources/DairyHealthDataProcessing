library(tidyverse)

fxn_assign_id_animal_default<-function(df){
  df%>%
    mutate(id_animal = paste0(source_file_path, '_', ID, '_', BDAT), 
           id_animal_lact = paste0(source_file_path, '_', ID, '_', BDAT, '_', LACT)
    )
}

fxn_assign_id_animal_parnell<-function(df){
  df%>%
    mutate(id_animal = paste0(str_sub(source_file_path, 19, 47), '_', ID, '_', BDAT), 
           id_animal_lact = paste0(str_sub(source_file_path, 19, 47), '_', ID, '_', BDAT, '_', LACT)
    )
}