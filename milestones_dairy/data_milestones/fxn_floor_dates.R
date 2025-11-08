
library(tidyverse)
add_new_variables<-function(df){
  
  df%>%
    mutate(floordate_month = floor_date(date_event, 'months'))%>%
    arrange(id_animal_lact, event, date_event)%>%
    group_by(id_animal_lact, event)%>%
    mutate(event_count = 1:n())%>%
    ungroup()%>%
    mutate(event = paste0(event, event_count))
  
}
