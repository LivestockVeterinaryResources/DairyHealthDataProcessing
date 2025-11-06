library(tidyverse)

#todo: alphabatize lists

#default event types -------------------------
fxn_assign_event_type_default <- function(df) {
  df %>%
    # define event types------------------------------------
  mutate(event_type = case_when(
    
    ##phase--------------------------------------
    event %in% c("DIED", "FRESH", "SOLD", "DRY", 'EARLYD', 'DRYERLY' ) ~ "lact_parameter",
    
    event %in% c('ARRIVED', "BIRTH",'BORN', 'WEANED', 'WEAN', 'INVTORY', 
                 'ARVDPT', 'ARVKDD','ARVTHA2','ARRKDD', 'ARRIVE', 'ARRDPOT','HUTCH',
                 'TRNSFER', 'WEANMOV',
                 'HFRANCH') ~ "phase_parameter",
    
    ##repro---------------------
    (event %in% c(
      "ABORT", "BRED", "BULLPEN", "GNRH", "HEAT", 
      "LUT", 'LUT1', 'LUT2', 'LUT3', 'LUTE', 'ESTROPL', 'PROSTA', 'PGF', 'LT3', 'ESTRMTE',
      "RECK", 'RECHK', 'RECHECK', 'HFRLUT',
      "OK", "OPEN", "PREG", "PREV", "PROST", "PG", "DNB", 'GRH',
      "CIDR", "BLEDOFF", 'MISHEAT','MISSHOT', 'LUTE', 'SYNCPRG', 'OV', 
      'SCRHEAT', 'CWHEAT', 'ESTRO', 'CHECK', 'CYSTIC', 'CYST', 'MISHEAT', 'NOSYNC', 
      'PRESYNC', 'PGTODAY', 'SYNCSHT', 'POLY', 'EXCD', 'EXCN'
    
      )) ~ "repro",
    
    (str_detect(event, 'SYNCH|.SYNCH|SYNCH.|.SYNCH.')) ~ "repro",
    (str_detect(event, 'OV.')) ~ "repro",
    (str_detect(event, 'CIDR|.CIDR|CIDR.|.CIDR.')) ~ "repro",
    
    
    ## health------------------------------------
    (event %in% c(
      "ASSIST",'ABSESS',
      "BLOAT", "DIPTHRA", "FEVER", "ILLMISC", "INDIG",
      "INJURY", "MF", "MLKFVR", 'MFEVER', 'MILKFVR', "DA", "METR", "KETOSIS",
      "LAME", "MAST", "NAVEL", "OTHER", "OTITIS", "PINKEYE", "PNEU",
      "RP", 'RETAINP', 'INFUSED', 'MET', 'PROLAPS',
      "JOINT", 'JOHNES',
      "SCOURS", "SEPTIC", "HARDWARE", "HRDWARE", "CULTURE", "FOOTTRIM", "TRIM", 'HOOFTRM',
      "TRIMONLY", "FOOTRIM",
      "TEMP", "TREAT", '3TEAT', 'TRT',
      'HITEMP', 'ILL', 'IV', 'SICK','OFFEED', 'OFFEED', 'RESP', 'OFFFEED',
      'MAGNET', 'DOWN', 'TREATED', 'SCRILL', 'BIRDFLU', 'BRDFLU', 'HPAI', 'EDEMA',
      'DEHYDR', 'DRENCH', 'PUMP',
      'ULCER',
      'EXCEDE', 'EARS', 'DIAH','CPNEU','NAXCEL','LEUKOIS', 'DIG', 'PENNG', 'KET', 'OLD_ILL',
      'SPECT', 'CFSERUM', 'METABOL', 'DISEASE', 'SLMNLA','GONABRD', 
      'BADLEG', 'BADLEGS', 'BADSTOM', 'SUPORT', 'PREVENT','BANAMIN', 'DRUG', 'POLYFLX', 
      'SPECTRA', 'NUFLOR', 'SE_A_D', 'MST', 'SUBKETO', 'NOTREAT', 'DECTOMX', 'ZACTRAN',
      "WRAP", 'SPCTMST','PIRSUE', 'SPPCAR',
      'ECOLI2'
   
       )) ~ "health",
    
    
    
     (str_detect(event, 'MAST|.MAST|MAST.|.MAST.')) ~ "health",
     (str_detect(event, 'METR|METR.')) ~ "health",
     (str_detect(event, 'FVER|.FVER|FVER.|.FVER.|FVR|.FVR|FVR.|.FVR.'))~'health',
     (str_detect(event, 'FOOT|.FOOT|FOOT.|.FOOT.|FEET|.FEET|FEET.|.FEET.|LAME|.LAME|LAME.|.LAME.|HOOF|.HOOF|HOOF.|.HOOF.'))~'health',
     (str_detect(event, 'TRIM|.TRIM|TRIM.|.TRIM.')) ~ "health",
     (str_detect(event, 'DIG.|DIAR.')) ~ "health",
    (str_detect(event, 'BLD.|BLOOD|BLOOD.|.BLOOD|.BLOOD.')) ~ "health",
    (str_detect(event, 'DOWN|DOWN.|.DOWN|.DOWN.')) ~ "health",
    
    (str_detect(event, 'CANCER.|CANCER|.CANCER.|.CANCER')) ~ "health",
    (str_detect(event, 'PNEU.|PNEU|.PNEU.|.PNEU')) ~ "health",

    ##management-----------------------------------
    event %in% c("GOHOME", "MOVE", "TOCLOSE", 'CLOSE', "CLOSEUP", "TOGROWR", 'TONFORK',  "XID", 
                 'WELL', 'HOME', 'HOSP', 'TEAT3', 'BEEF', 'DEHORN', 'BSTOP', 'CULL', 'ATRISK', 
                 'WELLOUT', 'WELLH') ~ "management",

    ###vac----------------------
    event %in% c('J5', 'FRESHOT', 'BANGS', 'EXPRESS', 'SRP', 'EXP10', 'INFORCE',
                 'VISION7', 'MLV9WAY', 'ALPHA', 'TRIANGL', 'EXFP10', 'PBRDVX',
                 'INFORC3','DAY50VC', 'DRYBOST', 'ONESHOT','CALIBR7',

                 'PYRAMID', 'ALPHA7', 'CITADEL')~'vac',
    
    (str_detect(event, 'VAC|.VAC|VAC.|.VAC.|BANGS|BANGS.'))~'vac',
    
    ###measure
    event %in% c("INWEIGH", "MEASURE", "TP", 'TPROT', "WEIGHT", 'HT WT', 'WT_HT', 
                 'TBTEST', 'PCRTEST', 'PROTEIN', 'BHBA', 'LUNGSCN', 'LNGSCAN', 'LUNGUS',
                 'PH', 'SAMPLE', 'HEIGHT', 'LUNGS', 'MILKTST', 'TBINJ', 'MEASUR', 'RESULT',
                 
                 'MEASURD', 'IGG') ~ "measure",
    
    (str_detect(event, 'TEST|.TEST|TEST.|.TEST.'))~'measure',
    (str_detect(event, 'BCS|.BCS|BCS.|.BCS.'))~'measure',
    (str_detect(event, 'BHB|.BHB|BHB.|.BHB.'))~'measure',
    (str_detect(event, 'SCORE|.SCORE|SCORE.|.SCORE.'))~'measure',

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



