library(tidyverse)


#create DOP groups

#dim cuts-------------------------
fxn_create_dim_cuts<-function(cut_by_days = 50, top_cut = 400){
dim_cuts<<-tibble(dop_start = c(-Inf, seq(0, top_cut, by = cut_by_days)))%>%
  mutate(dop_end = case_when(
    (dop_start == (-Inf))~0, 
    dop_start == max(dop_start)~Inf,
    TRUE~ dop_start + (cut_by_days-1))
  )%>%
  mutate(dop_in_interval = dop_end-dop_start)
}

#age cuts--------------------------------------
fxn_create_age_cuts<-function(cut_by_days = 100, top_cut_hfr = 700){
age_cuts<<-tibble(dop_start = c(-Inf, seq(0, top_cut_hfr, by = cut_by_days)))%>%
  mutate(dop_end = case_when(
    (dop_start == (-Inf))~0, 
    dop_start == max(dop_start)~Inf,
    TRUE~ dop_start + (cut_by_days-1))
  )%>%
  mutate(dop_in_interval = dop_end-dop_start)%>%
  mutate(lact_number = 0)
}




#df<-mast_events
#add dop -------------------------
fxn_add_dop<-function(df, top_cut_hfr, top_cut, cut_by_days){
  
  lact_numbers<-tibble(lact_number = sort(unique(df$lact_number)))
  
  dim_cuts_complete <- bind_rows(tidyr::crossing(lact_numbers%>%filter(lact_number>0), dim_cuts), age_cuts)
  
  df%>%
    mutate(day_of_phase_event = case_when( #this is the day of phase at the reference time_period start
      lact_number==0~as.numeric(date_event-date_birth), 
      lact_number>0~as.numeric(date_event-date_fresh), 
      TRUE~as.numeric(NA)
    ))%>%
    mutate(dop_group_pre = case_when(
      lact_number==0~cut(day_of_phase_event, breaks = age_cuts$dop_start), 
      lact_number>0~cut(day_of_phase_event, breaks = dim_cuts$dop_start),
        TRUE~'UnDefined DOP Group')
      )%>%
    separate(dop_group_pre, into = c('dop_group_start', 'dop_group_end', 'extra'), sep = ',')%>%
    mutate(dop_group_start = parse_number(dop_group_start), 
           dop_group_end = parse_number(dop_group_end))%>%
    mutate(day_of_phase_group = paste0(dop_group_start, ' to ', (dop_group_end-1)))
    
}
