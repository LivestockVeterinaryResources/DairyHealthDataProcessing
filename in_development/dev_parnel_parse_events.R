# --- setup ---
# install.packages("googledrive")   # uncomment this line if not already installed
library(googledrive)
library(tidyverse)
library(glue)

drive_deauth() # this disables authentication notifications for a publicly shared folder




# --- 1. access the drive ---
folder_id <- "1JOt9d8cSKJTBVRIAkUWPq5s83i8pzBN3" # google drive folder id

files_in_drive <- drive_ls(as_id(folder_id)) %>% # list the files in the folder
  #filter(!(name %in% c(".placeholder"))) %>% # we don't want the placeholder file
  filter((str_detect(name, "mySYNCH")))# %>% # we don't want the master mySYNCH events file
  # mutate(herdkey = str_sub(name, 1, 36)) %>% # use file name to specify herd, this is specific to data source
  # mutate(herdkey_short = str_sub(herdkey, 1, 5)) # make herd name simpler


selected_files <- files_in_drive 


# # --- 2. create local folder if it doesn’t exist ---
local_dir <- "data/template_files"
# if (!dir.exists(local_dir)) dir.create(local_dir, recursive = TRUE)


# --- 3. download matching files ---

# Loop through all files using direct download URLs
for (i in 1:nrow(selected_files)) {
  file_id <- as.character(selected_files$id[i])
  file_name <- selected_files$name[i]
  download_url <- paste0("https://drive.google.com/uc?export=download&id=", file_id)

  message(glue::glue("Downloading file {i} of {nrow(selected_files)}: {file_name}"))

  tryCatch(
    {
      download.file(
        url = download_url,
        destfile = file.path("data/template_files", file_name),
        mode = "wb",
        quiet = FALSE
      )
      message("Success!")
      Sys.sleep(2)
      gc()
    },
    error = function(e) {
      message(glue::glue("Failed on file {i}: {file_name}"))
      message(glue::glue("Error: {e$message}"))
      Sys.sleep(5)
    }
  )
}

message(glue::glue("Download complete! {nrow(selected_files)} files processed."))


