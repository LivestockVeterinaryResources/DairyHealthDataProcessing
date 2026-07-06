# SETUP-----------------------------
source('functions/setup_default_processing_options.R') #default settings: 1 example herd, all reports

#**** Modify This Section*** turn on to over ride default processing options

#clean_up_old_files <- FALSE # Use FALSE here for your own data, or after the first download of example data. This will delete any previously processed files as well as raw data in the event_files folder

#get_EXAMPLE_herds <- 8 # (0-8) ## number of Parnell Example herds you want to process.## if this is set to 0, you need to put your own data in the event_files folder

run_reports <-FALSE #make this false if you just want to reprocess base data

#milk_data_exists <- TRUE # are there files in the milk_files folder that you want to process?

#auto_de_duplicate <- FALSE # do you want to de-duplicate rows in the event files? # (choose FALSE if there are treatments that happen more than once daily that you want to capture)


#********************************************************************************

# PROCESS FILES--------------------------
#*** Do NOT modify this section***(unless you really know what you are doing)
## read in functions -------------------
source(file.path("functions/fxn_pacman.R"))
fxn_pacman_all()
source(file.path("functions/fxn_delete_files_clean_slate.R"))

## clean up old files --------------
if (clean_up_old_files == TRUE) {
  fxn_delete_files_clean_slate() # delete ALL original event data and  processed data
}

## process files ----------
source(file.path("functions/fxn_process_files.R"))


# REPORTS ----------------
if (run_reports == TRUE){
  
  rm(list = ls()) # clean environment to maximize memmory

# choose which reports to turn on by commenting/uncommenting them

## Gerard's lameness report ---------------------------
quarto::quarto_render("qmd_reports/report_explore_lame_new.qmd")

## "HOW TO" reports ---------------------------
quarto::quarto_render("qmd_reports/report_how_to_use_denominators.qmd")

## quick check data reports--------------------------------
quarto::quarto_render("qmd_reports/report_explore_event_types.qmd")
quarto::quarto_render("qmd_reports/report_data_dictionary.qmd")

}

