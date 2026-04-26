library(tidyverse)
library(quarto)
library(rmarkdown)
library(arrow)
#library(pushoverr)



start_time<-Sys.time()
#todo-----------
#make functions source from git
#add push notifications for processing?

#***Choose to Anonomize location or not***
#use_anon <- FALSE #if TRUE, will anonymize location data, if FALSE will keep original location data


# access database---------------------
source("../ParnellFunctions/fxn_connect_to_mySYNCH_update_herd_cows_events_meta.R") #creates herd_farmevents_meta in the R environment


#otherwise use herd group id
# choose herd and file datestring ----------------
# some default groups used in special reports are listed.
#It is safest to choose based on HerdId, but if single farm for target purposes name can be used

herd_list<-herd_farm_events_meta
safe_write_rds(herd_list, 'data/global_files/herd_list.rds')

herd_list<-read_rds('data/global_files/herd_list.rds') #only use if Database connection is broken

herd_list_active<-herd_list%>%
  filter(Status<2)%>%
  filter(IsTestFarm %in% 'FALSE')

herd_from_list<-list('867',  #Tri-Star Dairy, 
                     '734', # Dixie Creek
                     '793', # Lawerence Family Dairy  ,
                     '726',
                     
                     '504',
                     '896',
                     '841',
                     '836'#,
                     # '739',
                     # '713',
                     # '319'
                     
  )
  

selected_herd<-herd_list%>%
   filter(HerdId %in% herd_from_list)%>% #use this line to run multiple reports from Master-process_byHerdlList.R
  select(HerdName, HerdKey, HerdKey_lower, HerdId, DaysSinceLastEvent, Filename, everything())%>%
  mutate(file_prefix = str_sub(Filename, 1, 45))

#write_rds(selected_herd, 'data/intermediate_files/selected_herd.rds')

ct_herds<-as.numeric(n_distinct(selected_herd$HerdKey))

if (use_anon==FALSE){
HerdGroupId<-case_when(
  (ct_herds==1)~sort(unique(selected_herd$HerdKey)),
  (ct_herds>1)~paste0(sort(unique(selected_herd$HerdId)), collapse = '_'), 
  TRUE~'Unknown Herd Group Id')

}else{
#for annonamous 
HerdGroupId<-'ANON'
}

selected_herd2<-selected_herd%>%
  mutate(HerdGroupId = HerdGroupId)%>%
  select(HerdName, FarmName, Status, IsExtinct, everything())

safe_write_rds(selected_herd2, 'shinyRepro123Overview/data/selected_herd.rds')
safe_write_rds(selected_herd2, 'shinyRepro123Execute/data/selected_herd.rds')
safe_write_rds(selected_herd2, 'shinyRepro123Achieve/data/selected_herd.rds')
safe_write_rds(selected_herd2, 'shinyRepro123Technicians/data/selected_herd.rds')
safe_write_rds(selected_herd2, 'SexedBeefPregnancies/data/selected_herd.rds')


#***BREAK*** prior to pulling data from blob

# Step 0 - download blobs-----------------------
source("../ParnellFunctions/fxn_delete_event_files.R") # this deletes files previously downloaded, it is a safety to make sure old files are not accidentally used
source('Events_Step0_blobfileaccess_001.R') #pulls event csv files from blob storage

