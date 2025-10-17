# loads packages for set up ------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  tidyverse,
  dtplyr,
  gt,
  arrow,
  rmarkdown,
  lubridate,
  quarto,
  arrow,
  zoo,
  DT,
  googledrive
)


# read in functions -------------------

source("functions/fxn_location.R") # function to specify event location
source("functions/fxn_assign_id_animal.R") # parameters to use in animal id

source("functions/fxn_parse_free_text.R") # functions to parse remarks and protocols
source("functions/fxn_event_type.R") # c function to categorize events

source("functions/fxn_disease.R")
source("functions/fxn_treatment.R")





# Set up processing -------------------------------
#**** Modify This Section***
get_data_from_google_drive <- TRUE # set this to TRUE to pull example data from google drive. if you already have the data that you want in data/event_files set it to false to save time

denominator_granularity <- 100 # number of days in each denominator count, smaller numbers will be more accurate but take longer

milk_data_exists <- FALSE

set_farm_name <- "demo" # this is now obsolete - it should come from a summary of location_event?

# set custom functions----
fxn_assign_id_animal <- fxn_assign_id_animal_parnell # fxn_assign_id_animal options: fxn_assign_id_animal_default, fxn_assign_id_animal_parnell

fxn_parse_remark <- fxn_parse_remark_default # parse_free_text options: fxn_parse_remark_default, fxn_parse_remark_custom

fxn_parse_protocols <- fxn_parse_protocols_default # parse_free_text options: fxn_parse_protocols_default, fxn_parse_protocols_custom

fxn_assign_location_event <- fxn_assign_location_event_parnell_ANON # location_event options: fxn_assign_location_event_default, fxn_assign_location_event_custom

fxn_event_type <- fxn_assign_event_type_default # event_type options: fxn_assign_event_type_default, fxn_assign_event_type_custom

fxn_detect_location_lesion <- fxn_detect_location_lesion_default # detect_location_lesion options: fxn_detect_location_lesion_default, fxn_detect_location_lesion_custom

fxn_assign_disease <- fxn_assign_disease_default ## make a function to detect what to pick?

fxn_assign_treatment <- fxn_assign_treatment_template

#* set this to be the number of days between events that would still count as the same event
set_outcome_gap_animal <- 1

#* set this to be the number of days between events in lactation that would still count as the same event
set_outcome_gap_lactation <- 1

# Process files--------------------------

## process event data -----------------

if (get_data_from_google_drive == TRUE) {
  source("step00_get_example_data_from_google_drive.R")
}

### Step 1 Read in data-------------
source("step1_read_in_data.R")

## process milk data ---------------------
if (milk_data_exists == TRUE) {
  source("step1a_read_in_production_data.R")
}
### Step 2 create Intermediate Files----------------------
source("step2_create_intermediate_files.R") # fundamental files
# source('step2disease_create_intermediate_files.R') #under development #disease files

# quick check reports--------------------------------
rm(list = ls()) # clean environment
# quarto::quarto_render('animal_counts.qmd')
quarto::quarto_render("explore_event_types.qmd")
quarto::quarto_render("data_dictionary.qmd")

### Step3 Create Denominators ---------------------
rm(list = ls()) # clean environment
quarto::quarto_render("step3_create_denominators_lact_dim_season.qmd")
quarto::quarto_render("step3_create_denominators_by_group.qmd")

### Step 4 Report Templates------------------------
rm(list = ls()) # clean environment
# add basic report templates
# quarto::quarto_render("explore_lame.qmd")



# FUTURE STUFF ---------------------------
# disease report (under development)
# quarto::quarto_render('step3_report_disease_template.qmd')
# cohort disease incidence (Location, Lactation, Breed, etc)
# timing of disease (DIM (or Age) and calendar time distributions, Kaplan Meier)
# perfomrance and disease (milk, gain, repro)
