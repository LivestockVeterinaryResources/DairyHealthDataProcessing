library(tidyverse)

source('functions/fxn_pacman.R')
source("functions/fxn_delete_files_clean_slate.R")

get_EXAMPLE_data_from_google_drive <- case_when(
  (get_EXAMPLE_herds>0)~TRUE, 
  TRUE~FALSE)


fxn_pacman_processing()


# PROCESS FILES--------------------------
#*** Do NOT modify this section*** unless you are very sure you understand what you want

#*#******************************************************************************
#******************************************************************************
fxn_delete_processed_files() #this will delete  your previously processed data and reports
#****************************************************************************
#***************************************************************************


## process milk data ---------------------
if (milk_data_exists == TRUE) {
  source("step1a_read_in_production_data.R")
}
print('milk data processed if turned on')

## process event data -----------------
if (get_EXAMPLE_data_from_google_drive == TRUE) {
  source("functions/step00_get_example_data_from_google_drive.R")
}

print('begining to process data')
### Step 1 Read in data-------------
source("step1_read_in_event_data.R") #creates ***events.parquet*** reads in the data, formats dates, adds lactation groups and other basic data prep steps
print('step1 complete')

### Step 2 create Intermediate Files----------------------
source("step2_create_intermediate_files.R") # fundamental files: animals.parquet, animal_lactations.parquet, events.parquet
print('step2 complete')

### Step 3 Create Denominators ---------------------
####Create denominator files by time periods ------------------------
for (i in seq_along(denominator_time_periods)){
  quarto::quarto_render(
    input = "step3_denominators_by_time_period.qmd",
    execute_params = list(
      denominator_granularity = denominator_time_periods[[i]],
      cut_by_days = set_cut_by_days,
      top_cut = set_top_cut,
      top_cut_hfr = set_top_cut_hfr
    )
  )
}
print('time period denominators created')

####Create denominator files by CALENDAR time periods ------------------------
quarto::quarto_render(
  input = "step3_denominators_by_calendar_time.qmd",
  execute_params = list(
    cut_by_days = set_cut_by_days,
    top_cut = set_top_cut,
    top_cut_hfr = set_top_cut_hfr
  )
)
print('calendar time period denominators created')

rm(list = ls()) # clean environment

print('processing complete, environment cleaned')


