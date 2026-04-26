library(tidyverse)


fxn_parse_remark<-function(df){
  df%>%
    # Extract numbers and letters into separate columns
    mutate(
      # Extract the first group of numbers and letters
      remark_numbers1 = str_extract(Remark, "[0-9]+"),
      remark_letters1 = str_extract(Remark, "[A-Za-z]+"),
      
      # Remove the first set of numbers or letters to check for the second set
      remark_remaining_after_numbers1 = str_remove(Remark, "([0-9]+)"),
      remark_remaining_after_letters1 = str_remove(Remark, "([A-Za-z]+)"),
      
      # Extract the second set of numbers or letters
      remark_numbers2 = if_else(str_detect(remark_remaining_after_numbers1, "[A-Za-z]"), 
                                str_extract(remark_remaining_after_numbers1, "[0-9]+"), NA_character_),
      remark_letters2 = if_else(str_detect(remark_remaining_after_letters1, "[0-9]"), 
                                str_extract(remark_remaining_after_letters1, "[A-Za-z]+"), NA_character_)
    )
  
}



fxn_parse_remark_default<-function(df){
  df%>%
    # Extract numbers and letters into separate columns
    mutate(
      # Extract the first group of numbers and letters
      remark_numbers1 = str_extract(Remark, "[0-9]+"),
      remark_letters1 = str_extract(Remark, "[A-Za-z]+"),
      
      # Remove the first set of numbers or letters to check for the second set
      remark_remaining_after_numbers1 = str_remove(Remark, "([0-9]+)"),
      remark_remaining_after_letters1 = str_remove(Remark, "([A-Za-z]+)"),
      
      # Extract the second set of numbers or letters
      remark_numbers2 = if_else(str_detect(remark_remaining_after_numbers1, "[A-Za-z]"), 
                                str_extract(remark_remaining_after_numbers1, "[0-9]+"), NA_character_),
      remark_letters2 = if_else(str_detect(remark_remaining_after_letters1, "[0-9]"), 
                                str_extract(remark_remaining_after_letters1, "[A-Za-z]+"), NA_character_)
    )
    
}

fxn_parse_remark_custom<-function(df){
  df%>%
    # Extract numbers and letters into separate columns
    mutate(
      # Extract the first group of numbers and letters
      remark_first3 = str_sub(Remark, 1,3),
      remark_next1 = str_sub(Remark, 4, 4),
      remark_final = str_sub(Remark, start = 5)
      
    )
  
}

fxn_parse_protocols<-function(df){
  df%>%
    # Extract numbers and letters into separate columns
    mutate(
      # Extract the first group of numbers and letters
      protocols_numbers1 = str_extract(Protocols, "[0-9]+"),
      protocols_letters1 = str_extract(Protocols, "[A-Za-z]+"),
      
      # Remove the first set of numbers or letters to check for the second set
      protocols_remaining_after_numbers1 = str_remove(Protocols, "([0-9]+)"),
      protocols_remaining_after_letters1 = str_remove(Protocols, "([A-Za-z]+)"),
      
      # Extract the second set of numbers or letters
      protocols_numbers2 = if_else(str_detect(protocols_remaining_after_numbers1, "[A-Za-z]"), 
                                   str_extract(protocols_remaining_after_numbers1, "[0-9]+"), NA_character_),
      protocols_letters2 = if_else(str_detect(protocols_remaining_after_letters1, "[0-9]"), 
                                   str_extract(protocols_remaining_after_letters1, "[A-Za-z]+"), NA_character_)
    )
  
}


fxn_parse_protocols_default<-function(df){
  df%>%
    # Extract numbers and letters into separate columns
    mutate(
      # Extract the first group of numbers and letters
      protocols_numbers1 = str_extract(Protocols, "[0-9]+"),
      protocols_letters1 = str_extract(Protocols, "[A-Za-z]+"),
      
      # Remove the first set of numbers or letters to check for the second set
      protocols_remaining_after_numbers1 = str_remove(Protocols, "([0-9]+)"),
      protocols_remaining_after_letters1 = str_remove(Protocols, "([A-Za-z]+)"),
      
      # Extract the second set of numbers or letters
      protocols_numbers2 = if_else(str_detect(protocols_remaining_after_numbers1, "[A-Za-z]"), 
                                   str_extract(protocols_remaining_after_numbers1, "[0-9]+"), NA_character_),
      protocols_letters2 = if_else(str_detect(protocols_remaining_after_letters1, "[0-9]"), 
                                   str_extract(protocols_remaining_after_letters1, "[A-Za-z]+"), NA_character_)
    )
  
}


fxn_parse_remark_custom<-function(df){
  
  #see ?str_sub for more options
  
  df%>%
    # Extract numbers and letters into separate columns
    mutate(
      # Extract the first group of numbers and letters
      remark_last3 = str_sub(Protocols, -3,-1),
      remark_next1 = str_sub(Protocols, start = 4, end = 6),
      remark_final = str_sub(Protocols, start = 7 )
      
    )
  
}
