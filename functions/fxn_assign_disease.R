library(tidyverse)

## use default - event = disease----------------------------
fxn_assign_disease_default<-function(df){
  df%>%
    mutate(disease = case_when(
      (!(event_type %in% 'health'))~'non-disease event',
      TRUE~event
    ))


## use template---------------------------------
fxn_assign_disease_template<-function(df){
   
  dz_std<-read_csv('data/standardardization_files/disease_standards.csv')
  
  df%>%
    left_join(dz_std)
}

## use remark letters 1--------------------------
fxn_assign_disease_remark_letters1<-function(df){
  df%>%
    mutate(disease = remark_letters1)
}


## use protocols --------------------------------
fxn_assign_disease_protocols<-function(df){
  df%>%
    mutate(disease = protocols)
}


}
