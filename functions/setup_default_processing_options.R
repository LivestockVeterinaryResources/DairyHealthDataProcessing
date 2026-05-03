## default values -------------------------------
clean_up_old_files <- TRUE # this will delete any previously processed files as well as raw data in the event_files folder

get_EXAMPLE_herds <- 1 # (0-8)
# number of Parnell Example herds you want to process.
# if this is set to 0, you need to put your own data in the event_files folder
# make sure "clean_up_old_files is set to FALSE if you are using your own data

milk_data_exists <- FALSE # are there files in the milk_files folder that you want to process?
auto_de_duplicate <- TRUE # do you want to de-duplicate rows in the event files?
# (choose FALSE if there are treatments that happen more than once daily that you want to capture)

run_reports <-TRUE #make this false if you just want to reprocess base data