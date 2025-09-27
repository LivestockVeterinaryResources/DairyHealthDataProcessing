library(tidyverse)

#default event types -------------------------
fxn_assign_event_type_default <- function(df) {
  df %>%
    # define event types------------------------------------
  mutate(event_type = case_when(
    (event %in% c(
      "ABORT", "BRED", "BULLPEN", "GNRH", "HEAT", "LUT", "RECK", 'RECHK', 'RECHECK',
      "OK", "OPEN", "PREG", "PREV", "PROST", "PG", "DNB",
      "CIDR"
    
      )) ~ "repro",
    
    (str_detect(event, 'SYNCH|.SYNCH|SYNCH.|.SYNCH.')) ~ "repro",
    (str_detect(event, 'OV.')) ~ "repro",
    
    
    (event %in% c(
      "ASSIST", "BLOAT", "DIPTHRA", "FEVER", "ILLMISC", "INDIG",
      "INJURY", "MF", "MLKFVR", "DA", "METR", "KETOSIS",
      "LAME", "MAST", "NAVEL", "OTHER", "OTITIS", "PINKEYE", "PNEU",
      "RP", "JOINT",
      "SCOURS", "SEPTIC", "HARDWARE", "HRDWARE", "CULTURE", "FOOTTRIM", "TRIM",
      "TRIMONLY", "FOOTRIM",
      "TEMP", "TREAT"
   
       )) ~ "health",
    
    (str_detect(event, 'DIG.|DIAR.')) ~ "health",
    (str_detect(event, 'MAST|.MAST|MAST.|.MAST.')) ~ "health",
    (str_detect(event, 'METR|METR.')) ~ "health",
    
    
    event %in% c("GOHOME", "MOVE", "TOCLOSE", "TOGROWR", "XID") ~ "management",
    event %in% c("DIED", "FRESH", "SOLD", "DRY") ~ "lact_parameter",
    event %in% c("INWEIGH", "MEASURE", "TP", 'TPROT', "WEIGHT", 'HT WT') ~ "measure",
    
    
    (str_detect(event, 'VAC|.VAC|VAC.|.VAC.'))~'vac',
    (str_detect(event, 'METRI|METR.'))~'Health',
    (str_detect(event, 'FOOT|.FOOT|FOOT.|.FOOT.|FEET|.FEET|FEET.|.FEET.'))~'health',
    (str_detect(event, 'DIG.|DIAR.')) ~ "health",
    (str_detect(event, 'MAST|.MAST|MAST.|.MAST.')) ~ "health",

    
    TRUE ~ "Unknown")
    )
}

##custom event types from template -----------------------

fxn_assign_event_type_custom_from_template <- function(df) {
  standard <- read_csv("Data/StandardizationFiles/standardize_event_type.csv",
    col_types = cols(.default = col_character())
  ) %>%
    select(-count)


  df %>%
    # define event types------------------------------------
    select(-event_type) %>%
    left_join(standard)
}


#custom event types - modify for farms specifics
fxn_assign_event_type_custom <- function(df) {
  df%>%
    mutate(event_type = case_when(
    event %in% c(
      "ABORT", "BRED", "BULLPEN", "GNRH", "HEAT", "LUT", "RECK", 'RECHK',
      "OK", "OPEN", "PREG", "PREV", "PROST", "PG", "DNB",
      "CIDR"
    ) ~ "repro",
    
    event %in% c(
      "ASSIST", "BLOAT", "DIPTHRA", "FEVER", "ILLMISC", "INDIG",
      "INJURY", "MF", "DA", "METR", "KETOSIS",
      "LAME", "MAST", "NAVEL", "OTHER", "OTITIS", "PINKEYE", "PNEU",
      "RP",
      "SCOURS", "SEPTIC", "HARDWARE", "CULTURE", "FOOTTRIM", "TRIM",
      "TRIMONLY", "FOOTRIM"
    ) ~ "health",
    
    event %in% c("GOHOME", "MOVE", "TOCLOSE", "TOGROWR", "XID") ~ "management",
    event %in% c("DIED", "FRESH", "SOLD", "DRY") ~ "lact_parameter",
    event %in% c("INWEIGH", "MEASURE", "TP", "WEIGHT") ~ "measure",
    event %in% c("BANGVAC", "VACC", "VAC") ~ "vac",
    (str_detect(event, 'VAC'))~'vac',
    str(detect(event, 'METRI|METR.'))~'health',
    
    TRUE ~ "Unknown"
  ))
}



