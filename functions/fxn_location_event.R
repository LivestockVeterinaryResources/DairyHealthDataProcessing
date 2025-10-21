library(tidyverse)

fxn_assign_location_event_default <- function(df){
  df%>%
    mutate(
      location_event = set_farm_name
      )
}


fxn_assign_location_event_custom <- function(df){
  df%>%
    mutate(pen_num = parse_number(PEN))%>%
    mutate(
      location_event = case_when(
        pen_num == 0~"Pen Zero"
        pen_num<100~"Location1", 
        pen_num<200~"Location2",
        pen_num<300~"Location3",
        TRUE~"Unknown Location"
      )
    )
    
}

fxn_assign_location_event_sara <- function(df){
  df%>%
    mutate(pen_num = parse_number(PEN))%>%
    mutate(
      location_event = case_when(
        pen_num == 0~"Pen Zero"
        pen_num<100~"Location1", 
        pen_num<200~"Location2",
        pen_num<300~"Location3",
        TRUE~"Unknown Location"
      )
    )
  
}


