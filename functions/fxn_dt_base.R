fxn_DT_base<-function(df){
  DT::datatable(df,
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
)#%>%
    
    
  #IR background---------------
# DT::formatStyle(
#   'IR 1st Lact', 'IR1_vcb',
#   backgroundColor = DT::styleEqual(val_DT,
#                                    colors_DT)
# )%>%
#   DT::formatStyle(
#     'IR 2+ Lact', 'IR2_vcb',
#     backgroundColor = DT::styleEqual(val_DT,
#                                      colors_DT)
#   )%>%
#   DT::formatStyle(
#     'IR All Lact', 'IR3_vcb',
#     backgroundColor = DT::styleEqual(val_DT,
#                                      colors_DT)
#   )%>%
#   #CR background---------------
# DT::formatStyle(
#   'CR 1st Lact', 'CR1_vcb',
#   backgroundColor = DT::styleEqual(val_DT,
#                                    colors_DT)
# )%>%
#   DT::formatStyle(
#     'CR 2+ Lact', 'CR2_vcb',
#     backgroundColor = DT::styleEqual(val_DT,
#                                      colors_DT)
#   )%>%
#   DT::formatStyle(
#     'CR All Lact', 'CR3_vcb',
#     backgroundColor = DT::styleEqual(val_DT,
#                                      colors_DT)
#   )%>%
#   #PR background---------------
# DT::formatStyle(
#   'PR 1st Lact', 'PR1_vcb',
#   backgroundColor = DT::styleEqual(val_DT,
#                                    colors_DT)
# )%>%
#   DT::formatStyle(
#     'PR 2+ Lact', 'PR2_vcb',
#     backgroundColor = DT::styleEqual(val_DT,
#                                      colors_DT)
#   )%>%
#   DT::formatStyle(
#     'PR All Lact', 'PR3_vcb',
#     backgroundColor = DT::styleEqual(val_DT,
#                                      colors_DT)
#   )%>%
#   #date text colors----------------------
# DT::formatStyle(
#   'IR Date', 'IR_Date_status',
#   color = DT::styleEqual(c('Data Not Current', 'Current'),
#                          c('red', 'black'))
# )%>%
#   DT::formatStyle(
#     'CR Date', 'CR_Date_status',
#     color = DT::styleEqual(c('Data Not Current', 'Current'),
#                            c('red', 'black'))
#   )%>%
#   DT::formatStyle(
#     'PR Date', 'PR_Date_status',
#     color = DT::styleEqual(c('Data Not Current', 'Current'),
#                            c('red', 'black'))
#   )
  
}