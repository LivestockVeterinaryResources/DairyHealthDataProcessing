library(tidyverse)

#not the dataframe must have a numberic variable named "day_of_phase"


fxn_assign_day_of_phase_group<-function(df, cut_by_days = 30, top_cut = 400, top_cut_hfr = 500){
  
  
  df%>%
    
     #test<-df%>% #for testing
    mutate(dop_group = cut(day_of_phase, 
                           right = FALSE,
                           breaks = c(-Inf, seq(0, top_cut, by = cut_by_days), top_cut+1),
                           ordered_result = TRUE))%>%
    mutate(day_of_phase_group = case_when(
      
      day_of_phase<0~paste0('<0'),
      (lact_number==0)&(day_of_phase>top_cut_hfr)~paste0(top_cut_hfr+1, '+'),
      day_of_phase>top_cut~paste0(top_cut+1, '+'), 
      TRUE~dop_group
    ))%>%
    select(-dop_group)#%>%
    
    #order the factor
    # mutate(dop_group2 = day_of_phase_group)%>%
    # separate(dop_group2, into = c('a', 'b', 'extra'), sep = ',')%>%
    # mutate(dop_group2_order = parse_number(a))%>%
    # 
    # arrange(dop_group2_order)%>%
    # mutate(day_of_phase_group = factor(day_of_phase_group, 
    #                                    levels = unique(day_of_phase_group)))%>%
    # select(-a, -b, -extra)
}
