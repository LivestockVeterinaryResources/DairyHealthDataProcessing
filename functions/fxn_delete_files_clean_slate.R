library(tidyverse)

fxn_delete_files_clean_slate <- function(){
  ## Event files---------------------------
  # Define the directory
  dir_path <- file.path("data/event_files")
  
  # Get a list of all files in the directory
  files <- list.files(dir_path, full.names = TRUE)
  
  # Delete each file
  file.remove(files)
  
  # Confirm deletion
  if (length(list.files(dir_path)) == 0) {
    message("All files have been successfully deleted.")
  } else {
    message("Some files could not be deleted.")
  }
  
  
  
  ## intermediate files---------------------------
  # Define the directory
  dir_path <- file.path("data/intermediate_files")
  
  # Get a list of all files in the directory
  files <- list.files(dir_path, full.names = TRUE)
  
  # Delete each file
  file.remove(files)
  
  # Confirm deletion
  if (length(list.files(dir_path)) == 0) {
    message("All files have been successfully deleted.")
  } else {
    message("Some files could not be deleted.")
  }
  
  ## reports---------------------------
  # Define the directory
  dir_path <- file.path("reports")
  
  # Get a list of all files in the directory
  files <- list.files(dir_path, full.names = TRUE)
  
  # Delete each file
  file.remove(files)
  
  # Confirm deletion
  if (length(list.files(dir_path)) == 0) {
    message("All files have been successfully deleted.")
  } else {
    message("Some files could not be deleted.")
  }
  
  }
  