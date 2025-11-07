library(tidyverse)


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
  
  
  

    ## Event files---------------------------
  # Define the directory
  dir_path <- file.path("../Repro123Achieve/data/prod_events_v2_files")
  
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
  
  
  ## app Data Quality files---------------------------
  # Define the directory
  dir_path <- file.path("shinyDataQuality/data")
  
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
  
  ## app Achieve files---------------------------
  # Define the directory
  dir_path <- file.path("shinyRepro123Achieve/data")
  
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
  
  
  ## app Execute files---------------------------
  # Define the directory
  dir_path <- file.path("shinyRepro123Execute/data")
  
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
  
  
  ## app Execute Heifer files---------------------------
  # Define the directory
  dir_path <- file.path("shinyRepro123ExecuteHeifer/data")
  
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
  
  ## app Overview files---------------------------
  # Define the directory
  dir_path <- file.path("shinyRepro123Overview/data")
  
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
  
  ## app Tech files---------------------------
  # Define the directory
  dir_path <- file.path("shinyRepro123Technicians/data")
  
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
  
  
  ## app Legacy files---------------------------
  # Define the directory
  dir_path <- file.path("SexedBeefPregnancies/data")
  
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
  
  
  