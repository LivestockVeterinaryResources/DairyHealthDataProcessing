# loads packages for set up
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
  DT
)

# read in functions -------------------
source("functions/fxn_parse_free_text.R") # functions to parse remarks and protocols
source("functions/fxn_event_type.R") # c function to categorize events
source("functions/fxn_location.R") # function to specify event location

# set custom functions----
#**** Modify This Section ***
fxn_parse_remark <- fxn_parse_remark_default # parse_free_text options: fxn_parse_remark_default, fxn_parse_remark_custom

fxn_parse_protocols <- fxn_parse_protocols_default # parse_free_text options: fxn_parse_protocols_default, fxn_parse_protocols_custom

fxn_assign_location_event <- fxn_assign_location_event_parnell_ANON # location_event options: fxn_assign_location_event_default, fxn_assign_location_event_custom

fxn_event_type <- fxn_assign_event_type_default # event_type options: fxn_assign_event_type_default, fxn_assign_event_type_custom

fxn_detect_location_lesion <- fxn_detect_location_lesion_default # detect_location_lesion options: fxn_detect_location_lesion_default, fxn_detect_location_lesion_custom

# Set up -------------------------------
#**** Modify This Section***

event_data_exists <- TRUE
milk_data_exists <- FALSE

set_farm_name <- "demo"

# Step 1 - Process files--------------------------

## proces event data -----------------
if (event_data_exists == TRUE) {
  source("step1_read_in_data.R")
}

## process milk data ---------------------
if (milk_data_exists == TRUE) {
  source("step1a_read_in_production_data.R")
}

### Step 2 Intermediate Files----------------------
#*** Modify This Step to Include the Events/Disease of Interest***
#*
#* Set Gaps

#* set this to be the number of days between events that would still count as
#* the same event
set_outcome_gap_animal <- 1
#* set this to be the number of days between events in lactation
#* that would still count as the same event
set_outcome_gap_lactation <- 1

# create intermediate files
source("step2_create_intermediate_files.R")

# event check reports
quarto::quarto_render("explore_event_types.qmd")
quarto::quarto_render("data_dictionary.qmd")

### Step3 Create Denominators ---------------------
quarto::quarto_render("step3_create_denominators_lact_dim_season.qmd")

rm(list = ls())

### Step 4 Report Templates------------------------
# add basic report templates
quarto::quarto_render("explore_lame.qmd")





# disease report (under development)
# quarto::quarto_render('step3_report_disease_template.qmd')
# cohort disease incidence (Location, Lactation, Breed, etc)
# timing of disease (DIM (or Age) and calendar time distributions, Kaplan Meier)
# perfomrance and disease (milk, gain, repro)
