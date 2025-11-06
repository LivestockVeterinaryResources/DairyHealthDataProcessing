library(tidyverse)


fxn_deno_eligible_entire_lactation<-function(df){
  df%>%
    mutate(
    #Define start legitimate start date for each row
    date_elig_start = case_when(
      ((lact_number >0)&((is.na(date_fresh))<1))~date_fresh, #fresh date is not missing
      ((lact_number >0)&((is.na(date_fresh))>0))~data_pull_min, #fresh date is missing for a lactation, this is usually because the lactation started prior to the data pull date
      lact_number == 0~date_birth, #remember that heifers are different . . . there might be a better way to handle this
      TRUE~lubridate::ymd(NA) #if none of the above are true, the minium data pull date is the date first eligible, this could also use some validation
    ), 
    
    #Define legitimate end date.  
    #Get lactating cows. Use date_archive except for active cows. 
    date_elig_end = case_when(
      (is.na(date_next_fresh)<1)~date_next_fresh,
      (is.na(date_archive)<1)~date_archive, #if no date dry end with date_archive
      (is.na(date_archive)>0)~data_pull_max, #if no archive date end with data_pull_max date
      TRUE~lubridate::ymd(NA)) #this should be modified so that it throws an error notifying us that we missed something in the logic
    
  )
}

fxn_deno_eligible_milking<-function(df){
  df%>%
    mutate(
      #Define start legitimate start date for each row
      date_elig_start = case_when(
        ((lact_number >0)&((is.na(date_fresh))<1))~date_fresh, #fresh date is not missing
        ((lact_number >0)&((is.na(date_fresh))>0))~data_pull_min, #fresh date is missing for a lactation, this is usually because the lactation started prior to the data pull date
        lact_number == 0~date_birth, #remember that heifers are different . . . there might be a better way to handle this
        TRUE~lubridate::ymd(NA) #if none of the above are true, the minium data pull date is the date first eligible, this could also use some validation
      ), 
      
      #Define legitimate end date.  
      #Get lactating cows. Use date_archive except for active cows. 
      date_elig_end = case_when(
        #(is.na(date_next_fresh)<1)~date_next_fresh,
        (is.na(date_dry)<1)~date_dry,
        (is.na(date_archive)<1)~date_archive, #if no date dry end with date_archive
        (is.na(date_archive)>0)~data_pull_max, #if no archive date end with data_pull_max date
        TRUE~lubridate::ymd(NA)) #this should be modified so that it throws an error notifying us that we missed something in the logic
      
    )
}

fxn_deno_eligible_dry<-function(df){
  df%>%
    mutate(
      #Define start legitimate start date for each row
      date_elig_start = case_when(
        ((lact_number >0)&((is.na(date_dry))<1))~date_dry, #fresh date is not missing
        ((lact_number >0)&(is.na(date_fresh)))~data_pull_min, #fresh date is missing for a lactation, this is usually because the lactation started prior to the data pull date
        TRUE~lubridate::ymd(NA) #if none of the above are true, the minium data pull date is the date first eligible, this could also use some validation
      ), 
      
      #Define legitimate end date.  
      #Get lactating cows. Use date_archive except for active cows. 
      date_elig_end = case_when(
        (is.na(date_next_fresh)<1)~date_next_fresh,
        (is.na(date_archive)<1)~date_archive, #if no date dry end with date_archive
        (is.na(date_archive)>0)~data_pull_max, #if no archive date end with data_pull_max date
        TRUE~lubridate::ymd(NA)) #this should be modified so that it throws an error notifying us that we missed something in the logic
      
    )
}