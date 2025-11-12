library(tidyverse)

fxn_add_event_counts<-function(df){
  
  df%>%
    mutate(floordate_month = floor_date(date_event, 'months'))%>%
    arrange(id_animal, id_animal_lact, event, date_event)%>%
    group_by(id_animal_lact, lact_number, event)%>%
    mutate(event_count_lact = 1:n())%>%
    ungroup()%>%
    arrange(id_animal, id_animal_lact, event, date_event)%>%
    group_by(id_animal, event)%>%
    mutate(event_count_animal = 1:n())%>%
    ungroup()
  
}
