library(tidyverse)

colors_mkt_cat<-c( "UNAPPROVED" = 'grey',
                   "UNAPPROVED HOMEOPATHIC" = '#a6cee3',
                   "UNAPPROVED DRUG OTHER" = '#1f78b4',
                   "BULK INGREDIENT - ANIMAL" = 'grey', #'#b2df8a',
                   "BULK INGREDIENT" = 'grey', #'#33a02c',
                   "LMUNADFMS"  = '#fb9a99',
                   "NADA" = 'grey30', #'#e31a1c',
                   
                   "Unapproved medical gas" = '#fdbf6f',
                   "unapproved other" = '#ff7f00',
                   "Conditional NADA" = "#009E73", #'#fb9a99',
                   "ANADA"= "#0072B2",
                   "drug for further processing" = 'grey', #'#b15928',
                   "export only" = 'grey' #'#ffff99'
)

colors_prod_type<-c( "OTC TYPE A MEDICATED ARTICLE ANIMAL DRUG" = 'grey80', #'#377eb8',
                     "VFD TYPE A MEDICATED ARTICLE ANIMAL DRUG"= 'grey30', #'#377eb8',
                     "BULK INGREDIENT - ANIMAL" = 'grey',
                     "BULK INGREDIENT - ANIMAL DRUG" = 'grey',
                     "BULK INGREDIENT" = 'grey',
                     "PRESCRIPTION ANIMAL DRUG" = 'grey30',#'#377eb8',
                     "OTC ANIMAL DRUG" = 'grey60', #'#377eb8',
                     "RECOMBINANT DEOXYRIBONUCLEIC ACID CONSTRUCT" = 'grey')

fda_facilities_solution_data<-read_rds('milestones_dairy/data_milestones/solution_fda_facilities.rds')

fxn_DT_base<-function(df){
  DT::datatable(
    df,
    
    
    extensions = 'Buttons',
    class = 'cell-border hoover compact nowrap',
    caption = '',
    options = list(
      fixedColumns = TRUE,
      autoWidth = TRUE,
      ordering = TRUE,
      paging = TRUE, 
      searching = TRUE,
      dom = 'BSlfrtip', 
      buttons = c('copy', 'csv', 'excel')
      
    ),
    filter = list(
      position = 'top', 
      clear = FALSE
    ),
    rownames = FALSE
  )
}

fxn_plot_facilities<-function(df){
  ggplot(df)+
    geom_bar(data = df%>%
               select(Year, Total)%>%
               distinct(), 
             aes(x = Year, y =`Total`), stat = 'identity')+
    
    geom_bar(aes(x = Year, y =`Facility Count`, fill = Location), , 
             stat = 'identity', position = 'dodge', width = .6)+
    geom_text(data = df%>%
                select(Year, Total)%>%
                distinct(), 
              aes(x = Year, y =`Total`, label = paste0(Total)), 
              color = 'white', vjust = 1)+
    geom_text(data = df%>%
                filter(Location %in% 'Domestic'), 
              aes(x = Year, y =`Total`, label = paste0('\n(', 
                                                       round(pct*100, digits = 0), '%)')), 
              color = 'white', vjust = 1, postion = 'dodge', vjust = 1)+
    #  geom_text(data = fda_facilities%>%
    #               filter(Location %in% 'Domestic'), 
    #              aes(x = Year, y =`Facility Count`, label = paste0(`Facility Count`)), 
    #             color = 'white', vjust = 1, postion = 'dodge', hjust = 1, size = rel(2))+
    #   geom_text(data = fda_facilities%>%
    #               filter(!(Location %in% 'Domestic')),
    #              aes(x = Year, y =`Facility Count`, label = paste0(`Facility Count`)), 
    #             color = 'white', vjust = 1, postion = 'dodge', hjust = 0, size = rel(2))+
    
    theme_bw()+
    theme(text = element_text(color = 'black'))+
    labs(title = 'FDA Facilities - Animal Drugs', 
         subtitle = 'Numbers on grey total bars are facility counts (% domestic)',
         caption = 'Data from: https://www.fda.gov/economics-staff/fda-glance')+
    scale_fill_manual(values = c('#1b9e77','#d95f02', 'grey'))
}


pharma_revenue<-read_csv('milestones_dairy/data_milestones/week4_pharma_company_data.csv')%>%
  select(-ct_products)

fxn_clean_green_manufacturer<-function(df){
  df%>%
    mutate(Manufacturer = case_when(
      str_detect(`Labeler Name`, 'Zoetis')~'Zoetis', 
      str_detect(`Labeler Name`, 'Boehringer')~'Boehringer', 
      str_detect(`Labeler Name`, 'Merck')~'Merck', 
      str_detect(`Labeler Name`, 'Parnell')~'Parnell', 
      str_detect(`Labeler Name`, 'Elanco')~'Elanco', 
      str_detect(`Labeler Name`, 'Ceva')~'Ceva', 
      str_detect(`Labeler Name`, 'Virbac')~'Virbac', 
      str_detect(`Labeler Name`, 'Dechra')~'Dechra', 
      str_detect(`Labeler Name`, 'Vetoq')~'Vetoq', 
      TRUE~`Labeler Name`
    ))
}