if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  tidyverse,
  googlesheets4, # for importing from Google Drive
  googledrive # to link to your google drive
)


# get location of files
drive_url <- googledrive::as_id("https://drive.google.com/drive/u/0/folders/1JOt9d8cSKJTBVRIAkUWPq5s83i8pzBN3")

drive_folder <- drive_ls(
  path = drive_url,
  type = "csv"
)

# make sure local folder exists
local_folder <- "data/event_files"
if (!dir.exists(local_folder)) dir.create(local_folder)

# Download and import all files
dfs <- map(set_names(drive_folder$name), function(fname) {
  # Full local path
  file_path <- file.path(local_folder, fname)

  # Download the file
  drive_download(
    file = drive_folder[drive_folder$name == fname, ],
    path = file_path,
    overwrite = TRUE
  )
})

rm(dfs)
