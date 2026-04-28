# SETUP-----------------------------
#**** Modify This Section***

## processing options -------------------------------
clean_up_old_files <- TRUE # this will delete any previously processed files as well as raw data in the event_files folder

get_EXAMPLE_herds <- 1 # (0-8)
# number of Parnell Example herds you want to process.
# if this is set to 0, you need to put your own data in the event_files folder
# make sure "clean_up_old_files is set to FALSE if you are using your own data

milk_data_exists <- FALSE # are there files in the milk_files folder that you want to process?
auto_de_duplicate <- TRUE # do you want to de-duplicate rows in the event files?
# (choose FALSE if there are treatments that happen more than once daily that you want to capture)

## day of phase parameters-----------------------------------
# set the parameters for grouping by DIM or heifers by days of age
set_cut_by_days <- 60 # number of days in each group
set_top_cut <- 400 # the final group for cow DIM with be this number and anything higher
set_top_cut_hfr <- 700 # the final group for heifer days of age with be this number and anything higher

## denominator granularity-----------------------
# Create a list of time periods (number of days) by which denominators will be created.
# The standard options are 21 and 365.  However any number works.
# You can add or delete as you wish, except for yearly. Yearly needs to stay
# the more time periods you add to this list the longer it will take to process files
# if you want calendar denominators (monthly, quarterly, etc) those already exist, don't add them here.
denominator_time_periods <- c(
  # 21,
  365
) # do NOT delete the yearly option or you will break the data_dictionary


# PROCESS FILES--------------------------
#*** Do NOT modify this section***(unless you really know what you are doing)
## read in functions -------------------
source(here::here("functions/fxn_pacman.R"))
fxn_pacman_all()
source(here::here("functions/fxn_delete_files.R"))

# CLEAN SLATE --------------
if (clean_up_old_files == TRUE) {
  fxn_delete_files_clean_slate() # delete ALL original event data and  processed data
}

## process files ----------
source(here::here("functions/fxn_process_files.R"))


# REPORTS ----------------
# choose which reports to turn on by commenting/uncommenting them


## Gerard's lameness report ---------------------------
quarto::quarto_render("qmd_reports/report_explore_lame_new.qmd")

## "HOW TO" reports ---------------------------
quarto::quarto_render("qmd_reports/report_how_to_use_denominators.qmd")

## quick check data reports--------------------------------
quarto::quarto_render("qmd_reports/report_explore_event_types.qmd")
quarto::quarto_render("qmd_reports/report_data_dictionary.qmd")
