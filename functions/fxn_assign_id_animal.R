library(tidyverse)


fxn_assign_id_animal <- function(df) {
  df %>%
    mutate(
      id_animal = paste0(HERDID, '_', ID, '_', BDAT),
      id_animal_lact = paste0(HERDID, '_', ID, '_', BDAT, '_', LACT)
    )
}

# if (get_EXAMPLE_data_from_google_drive == TRUE){
#
#   fxn_assign_id_animal<-function(df){
#     df%>%
#       mutate(id_animal = paste0(HERDID, '_', ID, '_', BDAT),
#              id_animal_lact = paste0(HERDID, '_', ID, '_', BDAT, '_', LACT)
#       )
#   }
# }else{
#
#   fxn_assign_id_animal<-function(df){
#     df%>%
#       mutate(id_animal = paste0(str_sub(source_file_path, 18, 47), '_', ID, '_', BDAT),
#              id_animal_lact = paste0(str_sub(source_file_path, 18, 47), '_', ID, '_', BDAT, '_', LACT)
#       )
#   }
# }
