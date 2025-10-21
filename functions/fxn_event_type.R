library(tidyverse)

#todo: alphabatize lists

#default event types -------------------------
fxn_assign_event_type_default <- function(df) {
  df %>%
    # define event types------------------------------------
  mutate(event_type = case_when(
    
    ##phase--------------------------------------
    event %in% c("DIED", "FRESH", "SOLD", "DRY", 'EARLYD' ) ~ "lact_parameter",
    
    event %in% c('ARRIVED', "BIRTH",'BORN', 'WEANED', 'WEAN', 'INVTORY', 
                 'ARVDPT', 'ARVKDD','ARVTHA2','ARRKDD', 'ARRIVE', 'ARRDPOT' ) ~ "phase_parameter",
    
    ##repro---------------------
    (event %in% c(
      "ABORT", "BRED", "BULLPEN", "GNRH", "HEAT", 
      "LUT", 'LUT1', 'LUT2', 'LUT3', 'LUTE', 'ESTROPL', 'PROSTA', 
      "RECK", 'RECHK', 'RECHECK',
      "OK", "OPEN", "PREG", "PREV", "PROST", "PG", "DNB",
      "CIDR", "BLEDOFF", 'MISHEAT','MISSHOT', 'LUTE', 'SYNCPRG', 'OV', 
      'SCRHEAT', 'CWHEAT', 'ESTRO', 'CHECK', 'CYSTIC', 'CYST', 'MISHEAT', 'NOSYNC'
    
      )) ~ "repro",
    
    (str_detect(event, 'SYNCH|.SYNCH|SYNCH.|.SYNCH.')) ~ "repro",
    (str_detect(event, 'OV.')) ~ "repro",
    
    ## health------------------------------------
    (event %in% c(
      "ASSIST", "BLOAT", "DIPTHRA", "FEVER", "ILLMISC", "INDIG",
      "INJURY", "MF", "MLKFVR", 'MFEVER', 'MILKFVR', "DA", "METR", "KETOSIS",
      "LAME", "MAST", "NAVEL", "OTHER", "OTITIS", "PINKEYE", "PNEU",
      "RP", 'RETAINP', 'INFUSED', 'MET', 'PROLAPS',
      "JOINT",
      "SCOURS", "SEPTIC", "HARDWARE", "HRDWARE", "CULTURE", "FOOTTRIM", "TRIM", 'HOOFTRM',
      "TRIMONLY", "FOOTRIM",
      "TEMP", "TREAT", '3TEAT', 
      'HITEMP', 'ILL', 'IV', 'SICK','OFFEED', 'OFFEED', 'RESP', 
      'MAGNET', 'DOWN', 'TREATED', 'SCRILL', 'BIRDFLU', 'BRDFLU', 'HPAI', 'EDEMA',
      'DEHYDR', 'DRENCH', 'PUMP',
      'ULCER',
      'EXCEDE', 
      'BADLEG', 'BADLEGS', 'BADSTOM'
   
       )) ~ "health",
    
    
    
     (str_detect(event, 'MAST|.MAST|MAST.|.MAST.')) ~ "health",
     (str_detect(event, 'METR|METR.')) ~ "health",
     (str_detect(event, 'FVER|.FVER|FVER.|.FVER.|FVR|.FVR|FVR.|.FVR.'))~'health',
     (str_detect(event, 'FOOT|.FOOT|FOOT.|.FOOT.|FEET|.FEET|FEET.|.FEET.'))~'health',
     (str_detect(event, 'TRIM|.TRIM|TRIM.|.TRIM.')) ~ "health",
     (str_detect(event, 'DIG.|DIAR.')) ~ "health",
    
    
    ##management-----------------------------------
    event %in% c("GOHOME", "MOVE", "TOCLOSE", 'CLOSE', "CLOSEUP", "TOGROWR", 'TONFORK',  "XID", 
                 'WELL', 'HOME', 'HOSP', 'TEAT3', 'BEEF', 'DEHORN', 'BSTOP', 'CULL', 'ATRISK') ~ "management",

    ###vac----------------------
    event %in% c('J5', 'FRESHOT', 'BANGS', 'EXPRESS', 'SRP', 'EXP10', 'INFORCE', 'PYRAMID', 'ALPHA7')~'vac',
    
    (str_detect(event, 'VAC|.VAC|VAC.|.VAC.|BANGS|BANGS.'))~'vac',
    
    ###measure
    event %in% c("INWEIGH", "MEASURE", "TP", 'TPROT', "WEIGHT", 'HT WT', 'WT_HT', 
                 'TBTEST', 'PCRTEST', 'PROTEIN', 'BHBA', 'LUNGSCN', 'LNGSCAN', 'LUNGUS',
                 'PH', 'SAMPLE', 'HEIGHT', 'LUNGS', 
                 'MEASURD', 'IGG') ~ "measure",
    
    (str_detect(event, 'TEST|.TEST|TEST.|.TEST.'))~'measure',
    
    
    
    
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



