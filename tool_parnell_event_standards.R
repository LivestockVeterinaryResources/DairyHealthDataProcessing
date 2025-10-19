
# --- setup ---
# install.packages("googledrive")   # uncomment this line if not already installed
library(googledrive)
library(tidyverse)
library(arrow)

source('functions/fxn_parse_free_text.R') #functions to parse remarks and protocols
source('functions/fxn_event_type.R') #c function to categorize events

source('functions/fxn_disease.R')
source('functions/fxn_treatment.R')

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

selected_files<-files_in_drive


# # --- 2. create local folder if it doesn’t exist ---
local_dir <- "data/standardization_files"
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

#read in file------------
df<-read_parquet("data/standardization_files/mySYNCH_outreach_event_details.parquet")%>%
  mutate(event = Event)%>%
  fxn_assign_event_type_default()#%>%
  # select(event, event_type)%>%
  # filter(event_type %in% 'unknown')%>%
  # distinct()

health_events<-df%>%
  filter(event_type %in% 'health')

sort(unique(health_events$event))



