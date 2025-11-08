library(tidyverse)

fxn_de_duplicate<-function(df){
  
  if (auto_de_duplicate == TRUE){
    
    df |>
    # dedups to get but ignores source file - Nora thinks we want this later in a formated version rather than the main one...so she put it in a function with a setting up front
    distinct(across(-c(source_file_path)),
             .keep_all = TRUE)
    
    
  }else{
    return(df)
    }
  
}