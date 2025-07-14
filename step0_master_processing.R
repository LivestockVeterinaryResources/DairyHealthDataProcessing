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

start<-now()

### Step 1 Read in data----------

###Aquire data from Parnell Database (only works for people who have access to this)#*** you must modify the get_event_data_from_mySYNCH.R function to specify which data to pull***
#source('C:/Code/ParnellFunctions/get_event_data_from_mySYNCH.R')




# modify these are required -----
#set defaults

set_farm_name<-'Mulhern'

#***Modify This Step to Include Correctly Parse Location and Other custom functions***
source('step1_read_in_data.R')

### Step 2 Intermediate Files----------------------
#***Modify This Step to Include the Events/Disease of Interest***
#*
#* Set Gaps

#*set this to be the number of days between events that would still count as
#* the same event
set_outcome_gap_animal<- 1 
#* set this to be the number of days between events in lactation 
#* that would still count as the same event
set_outcome_gap_lactation<- 1 

#* set events of interest to create long and wide disease specifics data sets
#* #***Modify this *** to be the list of events you want to explore
list_selected_events<-c('BRED') 

source('step2_create_intermediate_files.R')

### Step3 Create Denominators ---------------------
quarto::quarto_render('step3_create_denominators_lact_dim_season.qmd')


### Step 4 Report Templates------------------------
#add basic report templates
quarto::quarto_render('sara_Report_Template.qmd')

# event check reports
quarto::quarto_render('explore_event_types.qmd') 
quarto::quarto_render('data_dictionary.qmd')

# disease report (under development)
# quarto::quarto_render('step3_report_disease_template.qmd') 
#cohort disease incidence (Location, Lactation, Breed, etc)
#timing of disease (DIM (or Age) and calendar time distributions, Kaplan Meier)
#perfomrance and disease (milk, gain, repro)

end<-now()

processingtime<-end-start
