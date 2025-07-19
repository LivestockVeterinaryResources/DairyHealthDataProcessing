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

fxn_assign_location_event_parnell <- function(df){
  df%>%
    mutate(pen_num = parse_number(PEN))%>%
    mutate(
      location_event = case_when(
        str_detect(source_file_path, '4cfbbdc2-d892-424b-b3e9-cff09e1c3ee8') ~"Herd A"
        str_detect(source_file_path, '2108e618-b6fb-42fe-84de-54f849e5a6d0') ~"Herd B",
        TRUE~"Unknown Location"
      )
    )
  
}