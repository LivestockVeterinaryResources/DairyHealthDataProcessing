



#***OLD******************************************************
# --- setup ---
# install.packages("googledrive")   # uncomment this line if not already installed
library(googledrive)
library(tidyverse)

drive_deauth() #this disables authentication notifications for a publicly shared folder


# --- 1. access the drive ---
folder_id <- "1JOt9d8cSKJTBVRIAkUWPq5s83i8pzBN3" #google drive folder id

files_in_drive <- drive_ls(as_id(folder_id))%>% #list the files in the folder
  filter((str_detect(name, 'mySYNCH')))

herd_list<-files_in_drive%>%
  select(herdkey, herdkey_short)%>% #these are unique herd identifiers from the data source
  distinct()%>% #simplify so each herd occurs only one time
  arrange(herdkey)%>% #arrange it the same way every time
  mutate(herd_name = paste0('Example Herd ', 1:n())) #rename the example herds for simplicity

selected_files<-files_in_drive%>%
  filter(herdkey %in% herd_list$herdkey)%>%
  left_join(herd_list)%>%
  filter(herd_name %in% set_herds_to_download)


# # --- 2. create local folder if it doesn’t exist ---
local_dir <- "data/event_files"
# if (!dir.exists(local_dir)) dir.create(local_dir, recursive = TRUE)

# --- 3. download matching files ---
if (nrow(selected_files) > 0) {
  purrr::walk2(
    selected_files$id,
    selected_files$name,
    ~ drive_download(
      as_id(.x),
      path = file.path(local_dir, .y),
      overwrite = TRUE
    )
  )
  
}
