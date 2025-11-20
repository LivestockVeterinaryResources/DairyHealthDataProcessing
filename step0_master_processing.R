# loads packages for set up ------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  arrow,
  broom,
  DT,
  dtplyr,
  cardx,
  flextable,
  glue,
  googledrive,
  gt,
  gtsummary,
  lubridate,
  quarto,
  rmarkdown,
  scales,
  stringr,
  survival,
  survminer,
  tidyverse,
  waldo,
  zoo
)

# read in functions -------------------
source("functions/fxn_delete_files_clean_slate.R")
source("functions/fxn_de_duplicate.R") # removes duplicated rows


source("functions/fxn_location.R") # function to specify event location
source("functions/fxn_assign_id_animal.R") # parameters to use in animal id

source("functions/fxn_parse_free_text.R") # functions to parse remarks and protocols
source("functions/fxn_event_type.R") # c function to categorize events

source("functions/fxn_disease.R")
source("functions/fxn_treatment.R")

# SETUP-----------------------------

## Set custom functions----

#**** Modify This Section***
## Note: you can build your own custom functions for any of these.
## If you choose to use custom functions you must source them when you assign them

### animal id  (turn on only one of these lines) ---------
# fxn_assign_id_animal <- fxn_assign_id_animal_default
fxn_assign_id_animal <- fxn_assign_id_animal_parnell

### parsing---------
## parse_free_text options:
fxn_parse_remark <- fxn_parse_remark_default

## parse_free_text options:
fxn_parse_protocols <- fxn_parse_protocols_default

### locations  ((turn on only one location function) ----------
set_farm_name <- "Example Herd" # if you are not using the default location function this name will never be used
# fxn_assign_location_event <- fxn_assign_location_event_default
fxn_assign_location_event <- fxn_assign_location_event_parnell_ANON

# detect_location_lesion options:
fxn_detect_location_lesion <- fxn_detect_location_lesion_default

### event_types------------
fxn_event_type <- fxn_assign_event_type_default

### disease and treatments---------------
fxn_assign_disease <- fxn_assign_disease_default

# under development
fxn_assign_treatment <- fxn_assign_treatment_template

# set this to be the number of days between events that would
# still count as the same event - this is under development
set_outcome_gap_animal <- 1
set_outcome_gap_lactation <- 1


## Set up processing -------------------------------
#**** Modify This Section***
#*

### clean up old data ---------------------------------
#*** DANGER*** make sure you understand this setting if you change it to TRUE
clean_slate <- FALSE # this will delete all data in data/event_files and data/intermediate files

### EXAMPLE data google drive-----------
# set this to TRUE to pull EXAMPLE data from google drive.
# if you already have the data that you want in data/event_files set it to false
get_EXAMPLE_data_from_google_drive <- TRUE

### denomiantor settings----------
# number of days in each denominator count,
# smaller numbers will be more accurate but take longer
denominator_granularity <- 100

### milk data setings---------
# if you also want to pull in milk data set this to true
milk_data_exists <- FALSE

### deduplicate automatically---------
# deduplicate at original file creation
# if this is true it will run a function to deduplicate rows - this usually makes sense but not always.
auto_de_duplicate <- TRUE


# PROCESS FILES--------------------------
#*** Do NOT modify this section*** unless you are very sure you understand what you want
#*
## start with clean slate ------
if (clean_slate == TRUE) {
  fxn_delete_files_clean_slate()
}

## process milk data ---------------------
if (milk_data_exists == TRUE) {
  source("step1a_read_in_production_data.R")
}

## process event data -----------------
if (get_EXAMPLE_data_from_google_drive == TRUE) {
  source("step00_get_example_data_from_google_drive.R")
}

### Step 1 Read in data-------------
source("step1_read_in_data.R")

### Step 2 create Intermediate Files----------------------
source("step2_create_intermediate_files.R") # fundamental files

### Step 3 Create Denominators ---------------------
# standard denominators always group by location_event_list (animal level), and lactation group (basic (Heifer, Lact>0), repro (Heifer, 1, 2+), lact_group (Heifer, 1, 2, 3+), lact_group_5 (Heifer, 1, 2, 3, 4, 5+))
rm(list = ls()) # clean environment
quarto::quarto_render("step3_create_denominators_lact_dim_season.qmd") # denominators for lameness report

## under development:
quarto::quarto_render("step3_create_denominators_by_group.qmd") # inventories by lactation group, calender time, phase time
quarto::quarto_render("step3_create_denominators_by_breed.qmd") # inventory with example of custom variable


# Step 4 Report Templates------------------------
rm(list = ls()) # clean environment

## quick check data reports--------------------------------
quarto::quarto_render("report_explore_event_types.qmd")
quarto::quarto_render("report_data_dictionary.qmd")

## Gerard's lameness report ---------------------------
quarto::quarto_render("report_explore_lame.qmd")




# FUTURE STUFF ---------------------------
# quarto::quarto_render('step3_create_denominators_by_group.qmd') #(under development)

# quarto::quarto_render('step3_report_disease_template.qmd')
# quarto::quarto_render('animal_counts.qmd')
# cohort disease incidence (Location, Lactation, Breed, etc)
# timing of disease (DIM (or Age) and calendar time distributions, Kaplan Meier)
# perfomrance and disease (milk, gain, repro)

# old stuff
# source('step2disease_create_intermediate_files.R') #under development #disease files


# TODO List --------------------------------------------
# add milk data for example farms
