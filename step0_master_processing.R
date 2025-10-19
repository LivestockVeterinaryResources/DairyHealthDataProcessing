# loads packages for set up ------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  arrow,
  DT,
  dtplyr,
  flextable,
  glue,
  gt,
  gtsummary,
  lubridate,
  quarto,
  rmarkdown,
  scales,
  survminer,
  stringr,
  tidyverse,
  zoo
)


#read in functions -------------------

source('functions/fxn_location.R') #function to specify event location
source('functions/fxn_assign_id_animal.R') #parameters to use in animal id

source('functions/fxn_parse_free_text.R') #functions to parse remarks and protocols
source('functions/fxn_event_type.R') #c function to categorize events

source('functions/fxn_disease.R')
source('functions/fxn_treatment.R')

#SETUP-----------------------------

##Set custom functions----
#****Modify This Section***

###animal id---------
fxn_assign_id_animal<-fxn_assign_id_animal_parnell   #fxn_assign_id_animal options: fxn_assign_id_animal_default, fxn_assign_id_animal_parnell

###parsing---------
fxn_parse_remark<-fxn_parse_remark_default # parse_free_text options: fxn_parse_remark_default, fxn_parse_remark_custom

fxn_parse_protocols <- fxn_parse_protocols_default # parse_free_text options: fxn_parse_protocols_default, fxn_parse_protocols_custom

###locations----------
fxn_assign_location_event <- fxn_assign_location_event_parnell_ANON # location_event options: fxn_assign_location_event_default, fxn_assign_location_event_custom

fxn_detect_location_lesion <- fxn_detect_location_lesion_default # detect_location_lesion options: fxn_detect_location_lesion_default, fxn_detect_location_lesion_custom

###event_types------------
fxn_event_type <- fxn_assign_event_type_default # event_type options: fxn_assign_event_type_default, fxn_assign_event_type_custom

###disease and treatments---------------
fxn_assign_disease<-fxn_assign_disease_default ## disease assignment options: fxn_assign_disease_template

fxn_assign_treatment<-fxn_assign_treatment_template #under development

set_outcome_gap_animal<- 1 #set this to be the number of days between events that would still count as the same event

set_outcome_gap_lactation<- 1 #* set this to be the number of days between events in lactation that would still count as the same event


##Set up processing -------------------------------
#****Modify This Section***

###your google drive-----------
get_data_from_google_drive<-FALSE #set this to TRUE to pull data from google drive. You must modify the function to pull from the google drive folder you specify.  if you already have the data that you want in data/event_files set it to false to save time

###example data google drive-----------
get_EXAMPLE_data_from_google_drive<-TRUE #set this to TRUE to pull EXAMPLE data from google drive. if you already have the data that you want in data/event_files set it to false to save time

###denomiantor settings----------
denominator_granularity<-100 #number of days in each denominator count, smaller numbers will be more accurate but take longer

###milk data setings---------
milk_data_exists <- FALSE #if you also want to pull in milk data set this to true


#PROCESS FILES--------------------------
#***Do NOT modify this section*** unless you are very sure you understand what you want 
#*
## process milk data ---------------------
if (milk_data_exists == TRUE) {
  source("step1a_read_in_production_data.R")
}

## process event data -----------------
  
  if(get_data_from_google_drive==TRUE){
    source('step00_get_data_from_google_drive.R')
  }

  if(get_EXAMPLE_data_from_google_drive==TRUE){
    source('step00_get_example_data_from_google_drive.R')
  }

  ### Step 1 Read in data-------------
  source('step1_read_in_data.R')
  
  ### Step 2 create Intermediate Files----------------------
  source('step2_create_intermediate_files.R') #fundamental files

  ### Step 3 Create Denominators ---------------------
  rm(list = ls()) #clean environment
  quarto::quarto_render('step3_create_denominators_lact_dim_season.qmd')

# Step 4 Report Templates------------------------
  rm(list = ls()) #clean environment
  
  ## quick check data reports--------------------------------
  quarto::quarto_render('report_explore_event_types.qmd') 
  quarto::quarto_render('data_dictionary.qmd')

  ## Gerard's lameness report ---------------------------
  quarto::quarto_render("report_explore_lame.qmd")
  
  
  

#FUTURE STUFF ---------------------------
# quarto::quarto_render('step3_create_denominators_by_group.qmd') #(under developemnt)
# quarto::quarto_render('step3_report_disease_template.qmd')
# quarto::quarto_render('animal_counts.qmd')
# cohort disease incidence (Location, Lactation, Breed, etc)
# timing of disease (DIM (or Age) and calendar time distributions, Kaplan Meier)
# perfomrance and disease (milk, gain, repro)
  
#old stuff
# source('step2disease_create_intermediate_files.R') #under development #disease files
  
