library(tidyverse)

fxn_assign_location_event_default <- function(df){
  df%>%
    mutate(
      location_event = set_farm_name
      )
}


fxn_assign_location_event_template <- function(df){
  df%>%
    mutate(pen_num = parse_number(PEN))%>%
    mutate(
      location_event = case_when(
        (pen_num == 0)~"Pen Zero"
        (pen_num<100)~"Location1", 
        (pen_num<200)~"Location2",
        (pen_num<300)~"Location3",
        TRUE~"Unknown Location"
      )
    )
    
}

fxn_assign_location_event_parnell_ANON <- function(df){
  
  df%>%
    mutate(
      location_event = str_sub(source_file_path, 17, 53)
    )
  
}

fxn_detect_location_lesion_default<-function(df){
  df%>%
    mutate(
      detectRR = case_when(
        str_detect(Remark, 'RR|.RR|RR.|.RR.|RH|.RH|RH.|.RH.|ALL|.ALL|ALL.|.ALL.')~'RR', 
        TRUE~''),
      detectLR = case_when(
        str_detect(Remark, 'LR|.LR|LR.|.LR.|LH|.LH|LH.|.LH.|ALL|.ALL|ALL.|.ALL.')~'LR', 
        TRUE~''), 
      detectRF = case_when(
        str_detect(Remark, 'RF|.RF|RF.|.RF.|BF|.BF|BF.|.BF.|ALL|.ALL|ALL.|.ALL.')~'RF',
        TRUE~''),
      detectLF = case_when(
        str_detect(Remark, 'LF|.LF|LF.|.LF.|BF|.BF|BF.|.BF.|ALL|.ALL|ALL.|.ALL.')~'LF',
        TRUE~'')
    )%>%
    mutate(locate_lesion = paste0(detectRR, detectLR, detectRF, detectLF))
}