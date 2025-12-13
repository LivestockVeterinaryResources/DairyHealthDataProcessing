
library(tidyverse)
library(arrow)
library(dtplyr)

source('functions/fxn_dt_base.R')
source('functions/fxn_denominator_eligibility.R')
source('functions/fxn_standardize_cow_breed.R')
source('functions/fxn_assign_day_of_phase_group.R')

fxn_add_dop<-function(df){
    df%>%
      left_join(dim_cuts_complete, relationship = "many-to-many")%>%
    filter(!(day_of_phase_start>dop_end))%>%
    filter(!(day_of_phase_end<dop_start))%>%
    mutate(dop_complete  = case_when(
      (dop_start>=day_of_phase_start)&(dop_end<=day_of_phase_end)~'complete', 
      TRUE~'incomplete'
    ))
  }
  
fxn_summarize_deno<-function(df){
    df%>%
      summarize(ct_animal_days_elig = sum(elig_days),
              ct_animals = n_distinct(id_animal),
              ct_animal_lactations = n_distinct(id_animal_lact))%>%
    ungroup()|>
    mutate(days_in_time_period = as.numeric(date_ref_end-date_ref_start))%>%
    mutate(ct_animal_time_periods = ct_animal_days_elig/days_in_time_period)
  }
  


## Read in the Base Data-----------------


#denominator base files -------------------
animals<-read_parquet('data/intermediate_files/animals.parquet') #each row is an animal

animal_lactations<-read_parquet('data/intermediate_files/animal_lactations.parquet') #each row is an animal lactation

animal_event_existance<-read_parquet('data/intermediate_files/events_all_columns.parquet')%>% #add a few parameters to animal
  mutate(lact = parse_number(LACT))%>%
  group_by(id_animal)%>%
  summarize(
            animal_lact_min = min(lact), 
            animal_lact_max = max(lact), 
            animal_date_event_min = min(date_event, na.rm = TRUE), 
            animal_date_event_max = max(date_event, na.rm = TRUE))%>%
  ungroup()


#---------------------------
data_pull_min<-min(animals$data_pull_date_min)
data_pull_max<-max(animals$data_pull_date_max)




## Define calendar days for calculations ---------------------------------

#This creates a list of calendar days from 1200 days prior to the most recent event date.  



get_bookend<-max(animal_event_existance$animal_date_event_max) #this controls the date range according to most recent event in data

calendar_granular<-tibble(date_calendar = seq.Date(get_bookend, (get_bookend-1500), by = -1))

fxn_create_calendar_summary<-function(time_period_type = 'month'){
  calendar_granular%>%
  mutate(calendar_period_type = time_period_type, 
         calendar_period = floor_date(date_calendar, unit = time_period_type) )%>%
  group_by(calendar_period_type, calendar_period)%>%
  summarize(date_time_period_end = max(date_calendar), 
            date_time_period_start = min(date_calendar))%>%
  ungroup()%>%
  mutate(days_in_period = date_time_period_end-(date_time_period_start+1))
}

#options are options from the unit argument in floordate

calendar_years<-fxn_create_calendar_summary(time_period_type = 'year')
calendar_halfyears<-fxn_create_calendar_summary(time_period_type = 'halfyear')
calendar_seasons<-fxn_create_calendar_summary(time_period_type = 'season')
calendar_bimonth<-fxn_create_calendar_summary(time_period_type = 'bimonth')
calendar_months<-fxn_create_calendar_summary(time_period_type = 'month')
calendar_weeks<-fxn_create_calendar_summary(time_period_type = 'week')


#------------------------------
calendar <-bind_rows(calendar_years, calendar_halfyears, calendar_seasons, calendar_bimonth, calendar_months, calendar_weeks)%>%
  mutate(date_calendar = date_time_period_start)
write_parquet(calendar, 'intermediate_files/calendar_from_calender_time_periods.parquet')





#base data frame for denominator.  Each row is an animal lactation, joined to animal data so that all important dates are available
deno_base<-animal_lactations |> 
  left_join(animals) %>%
  left_join(animal_event_existance)

deno_all_lact<-deno_base%>%
  fxn_deno_eligible_entire_lactation() #animals are eligible the entire lactation

deno_milking<-deno_base%>%
  fxn_deno_eligible_milking() #animals are eligible only when milking

deno_dry<-deno_base%>%
  fxn_deno_eligible_dry() #animals are eligible only when dry


### set base type used for calculations

#Turn on only one of these lines in this chunk

set_deno_base_type<-deno_all_lact #any animal is eligible
#set_deno_base_type<-deno_milking #only milking animals are eligible
#set_deno_base_type<-deno_dry #only dry animals are eligible


## Create cut points for day of phase


 dim_cuts<-tibble(dop_start = c(-Inf, seq(0, params$top_cut, by = params$cut_by_days)))%>%
             mutate(dop_end = case_when(
               (dop_start == (-Inf))~0, 
               dop_start == max(dop_start)~Inf,
               TRUE~ dop_start + (params$cut_by_days-1))
               )%>%
             mutate(dop_in_interval = dop_end-dop_start)
  
age_cuts<-tibble(dop_start = c(-Inf, seq(0, params$top_cut_hfr, by = params$cut_by_days)))%>%
             mutate(dop_end = case_when(
               (dop_start == (-Inf))~0, 
               dop_start == max(dop_start)~Inf,
               TRUE~ dop_start + (params$cut_by_days-1))
               )%>%
             mutate(dop_in_interval = dop_end-dop_start)%>%
             mutate(lact_number = 0)


## Count cows on each calendar day for different lacation groups


#make a place to put the results
deno_dataframe<-NULL
errors<-NULL

#i = 3
for (i in seq_along(calendar$date_calendar)){
  
  #faster------------------------------------------
  df_pre<-set_deno_base_type%>%
    #test%>%
    mutate(date_ref_start = calendar$date_time_period_start[[i]], 
           date_ref_end = calendar$date_time_period_end[[i]], 
           calendar_time_period_type = calendar$calendar_period_type[[i]])%>%
    mutate(elig_days = case_when(
      date_elig_start>date_ref_end~0, #lactation began after time_period ended
      date_elig_end<date_ref_start~0, #lactation ended before time_period started
      ((date_elig_start<=date_ref_start)&(date_elig_end>=date_ref_end))~as.numeric(date_ref_end-date_ref_start), #eligible for entire time_period, inclusive at begining but not end
      ((date_elig_start<=date_ref_start)&(date_elig_end<=date_ref_end))~as.numeric(date_elig_end-date_ref_start), #eligible at start but not at end of time_period
      ((date_elig_start>date_ref_start)&(date_elig_end>=date_ref_end))~as.numeric(date_ref_end-date_elig_start), #eligible at end but not at start of time_period.
      ((date_elig_start>date_ref_start)&(date_elig_end<=date_ref_end))~as.numeric(date_elig_end-date_elig_start), #eligible within time_period but not at begining or end
      TRUE~as.numeric(NA)
    ))%>%
    mutate(day_of_phase_start = case_when( #this is the day of phase at the reference time_period start
      lact_number==0~as.numeric(date_ref_start-date_birth), 
      lact_number>0~as.numeric(date_ref_start-date_fresh), 
      TRUE~as.numeric(NA)
    ))%>%
    mutate(day_of_phase_end = case_when( #this is the day of phase at the reference time_period start
      lact_number==0~as.numeric(date_ref_end-date_birth), 
      lact_number>0~as.numeric(date_ref_end-date_fresh), 
      TRUE~as.numeric(NA)
    ))
  
  df<-df_pre%>%filter(elig_days>0) #this restricts to only animals with at least 1 eligible day
  
  #errors-----------------------------
  df_error <-df_pre%>%
    filter(is.na(elig_days))%>%
    select(elig_days, contains('date_elig'), contains('date_ref'), date_birth, date_fresh, date_archive, everything())

  errors<-bind_rows(df_error, errors)
  
  # #lact group basic------------------------------
  df2<-df%>%
    filter(!(is.na(elig_days)))%>%
    group_by(location_lact_list, lact_group_basic, calendar_time_period_type,  date_ref_start, date_ref_end) |>
     summarize(ct_animal_days_elig = sum(elig_days), 
              ct_animals = n_distinct(id_animal), 
              ct_animal_lactations = n_distinct(id_animal_lact))%>%
    ungroup()|> 
    mutate(days_in_time_period = as.numeric(date_ref_end-date_ref_start))%>%
    mutate(ct_animal_time_periods = ct_animal_days_elig/days_in_time_period)%>%
    rename(`Lactation Group` = lact_group_basic)%>%
    mutate(deno_type = 'lact_basic')
  
  # #lact_group_5-------------------------------------
  df3<-df%>%
    group_by(location_lact_list, lact_group_repro, calendar_time_period_type, date_ref_start, date_ref_end) |>
     summarize(ct_animal_days_elig = sum(elig_days), 
              ct_animals = n_distinct(id_animal), 
              ct_animal_lactations = n_distinct(id_animal_lact))%>%
    ungroup()|> 
    mutate(days_in_time_period = as.numeric(date_ref_end-date_ref_start))%>%
    mutate(ct_animal_time_periods = ct_animal_days_elig/days_in_time_period)%>%
    rename(`Lactation Group` = lact_group_repro)%>%
    mutate(deno_type = 'lact_2+')

  # #lact _group standard----------------------------------
  df4<-df%>%
    group_by(location_lact_list, lact_group, calendar_time_period_type, date_ref_start, date_ref_end) |>
     summarize(ct_animal_days_elig = sum(elig_days), 
              ct_animals = n_distinct(id_animal), 
              ct_animal_lactations = n_distinct(id_animal_lact))%>%
    ungroup()|> 
    mutate(days_in_time_period = as.numeric(date_ref_end-date_ref_start))%>%
    mutate(ct_animal_time_periods = ct_animal_days_elig/days_in_time_period)%>%
    rename(`Lactation Group` = lact_group)%>%
    mutate(deno_type = 'lact_3+')
   
  # #lact_group_5-------------------------------------
  df5<-df%>%
    group_by(location_lact_list, lact_group_5, calendar_time_period_type, date_ref_start, date_ref_end) |>
     summarize(ct_animal_days_elig = sum(elig_days), 
              ct_animals = n_distinct(id_animal), 
              ct_animal_lactations = n_distinct(id_animal_lact))%>%
    ungroup()|> 
    mutate(days_in_time_period = as.numeric(date_ref_end-date_ref_start))%>%
    mutate(ct_animal_time_periods = ct_animal_days_elig/days_in_time_period)%>%
    rename(`Lactation Group` = lact_group_5)%>%
    mutate(deno_type = 'lact_5+')
  
  #Day of Phase (dop)-------------------------------------
  
   lact_numbers<-tibble(lact_number = sort(unique(df$lact_number)))
  
   
   dim_cuts_complete <- bind_rows(tidyr::crossing(lact_numbers%>%filter(lact_number>0), dim_cuts), age_cuts)
   
  
   #Day of phase data frames -------------------------------
  df6<-df%>%
    fxn_add_dop()%>%
    group_by(location_lact_list, lact_group_basic, calendar_time_period_type,
             dop_start, dop_end,  dop_in_interval, dop_complete, 
             date_ref_start, date_ref_end) |> 
    fxn_summarize_deno()%>%
    rename(`Lactation Group` = lact_group_basic)%>%
    mutate(deno_type = 'dop_lact_basic')
  
  df7<-df%>%
    fxn_add_dop()%>%
    group_by(location_lact_list, lact_group_repro, calendar_time_period_type,
             dop_start, dop_end,  dop_in_interval, dop_complete, 
             date_ref_start, date_ref_end) |>
    fxn_summarize_deno()%>%
    rename(`Lactation Group` = lact_group_repro)%>%
    mutate(deno_type = 'dop_lact_2+')
  
  df8<-df%>%
    fxn_add_dop()%>%
    group_by(location_lact_list, lact_group, calendar_time_period_type,
             dop_start, dop_end,  dop_in_interval, dop_complete, 
             date_ref_start, date_ref_end) |>
    fxn_summarize_deno()%>%
    rename(`Lactation Group` = lact_group)%>%
    mutate(deno_type = 'dop_lact_3+')
  
  df9<-df%>%
    fxn_add_dop()%>%
    group_by(location_lact_list, lact_group_5, calendar_time_period_type,
             dop_start, dop_end,  dop_in_interval, dop_complete, 
             date_ref_start, date_ref_end) |>
    fxn_summarize_deno()%>%
    rename(`Lactation Group` = lact_group_5)%>%
    mutate(deno_type = 'dop_lact_5+')
  
 
  #final df---------------------------
  df10<-bind_rows(df2, df3, df4,
                  df5, df6, df7, df8, df9
                  )%>%
    distinct()
  
  deno_dataframe <-bind_rows(deno_dataframe, df10) 
  
  print(calendar$date_calendar[[i]])
    
}
  

deno_final<-deno_dataframe%>%
  rename(date_time_period_end = date_ref_end, 
         date_time_period_start = date_ref_start)%>%
  mutate(day_of_phase_group = paste0(dop_start, ' to ', dop_end))


write_parquet(deno_final, 
              paste0('data/intermediate_files/denominator_by_calendar_time_period.parquet'))





