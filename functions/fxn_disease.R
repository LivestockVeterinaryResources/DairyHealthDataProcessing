library(tidyverse)

fxn_assign_disease_template<-function(df){
  df%>%
    mutate(disease = remark_letters1)
}

fxn_assign_disease_bred<-function(df){
  df%>%
    mutate(disease = event)
}

fxn_assign_disease_mastitis<-function(df){
  df%>%
    mutate(disease = case_when(
      event %in% 'MAST' ~ 'MASTITIS',
      TRUE ~ 'OTHER'
    ))
}

fxn_assign_disease_lameness<-function(df){
  df%>%
    mutate(disease = case_when(
      str_detect(remark, 'FOOTROT')~'footrot',
      str-detect(remark, 'WL|.WL|WL.|.WL.')~'white line',
      TRUE ~ 'OTHER'
    ))
}