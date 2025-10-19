library(tidyverse)

#default event types -------------------------
fxn_assign_event_type_default <- function(df) {
  df %>%
    # define event types------------------------------------
  mutate(event_type = case_when(
    (event %in% c(
      "ABORT", "BRED", "BULLPEN", "GNRH", "HEAT", "LUT", 'LUT1', 'LUT2', 'LUT3', 'LUTE', 'ESTROPL',  "RECK", 'RECHK', 'RECHECK',
      "OK", "OPEN", "PREG", "PREV", "PROST", "PG", "DNB",
      "CIDR", "BLEDOFF", 'MISSHOT', 'LUTE', 'SYNCPRG', 'OV', 'SCRHEAT', 'ESTRO', 'CHECK', 'CYSTIC', 'CYST'
    
      )) ~ "repro",
    
    (str_detect(event, 'SYNCH|.SYNCH|SYNCH.|.SYNCH.')) ~ "repro",
    (str_detect(event, 'OV.')) ~ "repro",
    
    
    (event %in% c(
      "ASSIST", "BLOAT", "DIPTHRA", "FEVER", "ILLMISC", "INDIG",
      "INJURY", "MF", "MLKFVR", 'MFEVER', "DA", "METR", "KETOSIS",
      "LAME", "MAST", "NAVEL", "OTHER", "OTITIS", "PINKEYE", "PNEU",
      "RP", "JOINT",
      "SCOURS", "SEPTIC", "HARDWARE", "HRDWARE", "CULTURE", "FOOTTRIM", "TRIM", 'HOOFTRM',
      "TRIMONLY", "FOOTRIM",
      "TEMP", "TREAT", '3TEAT', 
      'HITEMP', 'ILL', 'IV', 
      'MAGNET', 'DOWN', 'TREATED'
   
       )) ~ "health",
    
    (str_detect(event, 'DIG.|DIAR.')) ~ "health",
    (str_detect(event, 'MAST|.MAST|MAST.|.MAST.')) ~ "health",
    (str_detect(event, 'METR|METR.')) ~ "health",
    
    
    event %in% c("GOHOME", "MOVE", "TOCLOSE", 'CLOSE', "CLOSEUP", "TOGROWR", 'TONFORK',  "XID", 'WELL', 'HOME', 'HOSP', 'TEAT3') ~ "management",
    event %in% c("DIED", "FRESH", "SOLD", "DRY", 'EARLYD' ) ~ "lact_parameter",
    event %in% c("BIRTH",'BORN', 'WEANED', 'WEAN', 'INVTORY' ) ~ "phase_parameter",
    
    event %in% c("INWEIGH", "MEASURE", "TP", 'TPROT', "WEIGHT", 'HT WT', 'WT_HT', 'TBTEST', 'PCRTEST') ~ "measure",
    event %in% c('J5', 'FRESHOT', 'BANGS', 'EXPRESS', 'SRP', 'EXP10')~'vac',
    
    
    (str_detect(event, 'VAC|.VAC|VAC.|.VAC.'))~'vac',
    (str_detect(event, 'TEST|.TEST|TEST.|.TEST.'))~'measure',
    
    
    (str_detect(event, 'METRI|METR.'))~'health',
    (str_detect(event, 'FVER|.FVER|FVER.|.FVER'))~'health',
    (str_detect(event, 'FOOT|.FOOT|FOOT.|.FOOT.|FEET|.FEET|FEET.|.FEET.'))~'health',
    (str_detect(event, 'DIG.|DIAR.')) ~ "health",
    (str_detect(event, 'MAST|.MAST|MAST.|.MAST.')) ~ "health",
    (str_detect(event, 'TRIM|.TRIM|TRIM.|.TRIM.')) ~ "health",
    
    
    TRUE ~ "unknown")
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



