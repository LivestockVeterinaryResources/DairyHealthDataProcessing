library(tidyverse)


# just original event files ---------------------------------
fxn_delete_event_files <- function() {
  ## Event files---------------------------
  # Define the directory
  dir_path <- here::here("data/event_files")

  # Get a list of all files in the directory
  files <- list.files(dir_path, full.names = TRUE)

  # Delete each file
  file.remove(files)

  # Confirm deletion
  if (length(list.files(dir_path)) == 0) {
    message("All event files have been successfully deleted.")
  } else {
    message("Some files could not be deleted.")
  }
}

# just milk files ---------------------------------
fxn_delete_milk_files <- function() {
  ## Event files---------------------------
  # Define the directory
  dir_path <- here::here("data/milk_files")

  # Get a list of all files in the directory
  files <- list.files(dir_path, full.names = TRUE)

  # Delete each file
  file.remove(files)

  # Confirm deletion
  if (length(list.files(dir_path)) == 0) {
    message("All milk files have been successfully deleted.")
  } else {
    message("Some files could not be deleted.")
  }
}

# just intermediate files and reports
fxn_delete_processed_files <- function() {
  ## intermediate files---------------------------
  # Define the directory
  dir_path <- here::here("data/intermediate_files")

  # Get a list of all files in the directory
  files <- list.files(dir_path, full.names = TRUE)

  # Delete each file
  file.remove(files)

  # Confirm deletion
  if (length(list.files(dir_path)) == 0) {
    message("All intermediate files have been successfully deleted.")
  } else {
    message("Some files could not be deleted.")
  }

  ## template files---------------------------
  # Define the directory
  dir_path <- here::here("data/template_files")

  # Get a list of all files in the directory
  files <- list.files(dir_path, full.names = TRUE)

  # Delete each file
  file.remove(files)

  # Confirm deletion
  if (length(list.files(dir_path)) == 0) {
    message("All template files have been successfully deleted.")
  } else {
    message("Some files could not be deleted.")
  }

  ## reports---------------------------
  # Define the directory
  dir_path <- here::here("reports/qmd_reports")

  # Get a list of all files in the directory
  files <- list.files(dir_path, full.names = TRUE)

  # Delete each file
  file.remove(files)

  # Confirm deletion
  if (length(list.files(dir_path)) == 0) {
    message("All report files have been successfully deleted.")
  } else {
    message("Some files could not be deleted.")
  }
}


fxn_delete_files_clean_slate <- function() {
  fxn_delete_event_files()

  fxn_delete_milk_files()

  fxn_delete_processed_files()

  # ## Event files---------------------------
  # # Define the directory
  # dir_path <- file.path("data/event_files")
  #
  # # Get a list of all files in the directory
  # files <- list.files(dir_path, full.names = TRUE)
  #
  # # Delete each file
  # file.remove(files)
  #
  # # Confirm deletion
  # if (length(list.files(dir_path)) == 0) {
  #   message("All files have been successfully deleted.")
  # } else {
  #   message("Some files could not be deleted.")
  # }
  #
  #
  #
  # ## intermediate files---------------------------
  # # Define the directory
  # dir_path <- file.path("data/intermediate_files")
  #
  # # Get a list of all files in the directory
  # files <- list.files(dir_path, full.names = TRUE)
  #
  # # Delete each file
  # file.remove(files)
  #
  # # Confirm deletion
  # if (length(list.files(dir_path)) == 0) {
  #   message("All files have been successfully deleted.")
  # } else {
  #   message("Some files could not be deleted.")
  # }
  #
  # ## reports---------------------------
  # # Define the directory
  # dir_path <- file.path("reports")
  #
  # # Get a list of all files in the directory
  # files <- list.files(dir_path, full.names = TRUE)
  #
  # # Delete each file
  # file.remove(files)
  #
  # # Confirm deletion
  # if (length(list.files(dir_path)) == 0) {
  #   message("All files have been successfully deleted.")
  # } else {
  #   message("Some files could not be deleted.")
  # }
}
