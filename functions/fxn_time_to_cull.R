# Survival post lesion Dx

#Survival after lesion dx:----

## function to create data set for further use
survival_data <- function(data = lame_cull, 
                          censor_days = days_to_censor_cull,
                          censor_event = culled_ever,
                          control = life_times_lame, 
                          years,
                          life_x_dz,
                          disease) {
  # need to do this to use as.numeric to convert duration
  #censor_days <- ensym(censor_var)
  data |> 
    # reduce data
    lazy_dt() |> 
    select(farm, id_animal, year,  
           {{censor_days}}, {{censor_event}},
           {{control}}, {{life_x_dz}}, {{disease}}, 
           ) |>  
    filter(year == {{years}}) |>
    # to filter out lesions this year
    filter({{control}} == 0 | {{disease}} == 1) |>
    group_by(id_animal) |>
    slice_max({{life_x_dz}}, n=1, with_ties = FALSE) |>
    ungroup() |>
    ## this as.numeric creates NA's not sure why as it works without function
  mutate (censor_time = as.numeric({{censor_days}}),
         # create variables to condition on
         life_x_disease = case_when({{ control }} == 0 ~ 0,
                                    {{ life_x_dz }} == 1 ~ 1,
                                    {{ life_x_dz }} == 2 ~ 2,
                                    {{ life_x_dz }} > 2 ~ 3,
                                    TRUE ~ NA),
         life_x_disease_cat = case_when(life_x_disease == 0 ~
                                          "Never any lesion",
                                        life_x_disease == 1 ~ 
                                          "Once",
                                        life_x_disease == 2 ~ 
                                          "Twice",
                                        life_x_disease == 3 ~ 
                                          "3 or more times",
                                        TRUE ~ NA)) |> 
    filter(!is.na(life_x_disease)) |> 
    mutate(life_x_disease_cat = fct_reorder(life_x_disease_cat, 
                                            life_x_disease,
                                            .na_rm = TRUE)
           ) |> 
    # needs to be dataframe due to surv below otherwise factors get messed up
  as.data.frame()
}

# km function to create graph
km_fit <- function(data, censor_time = censor_time, 
                   censor_event = culled_ever,
                   facet_col,
                   facet_row) {
  data_surv <- data |> 
    mutate(surv_object = Surv(time = {{ censor_time }}, 
                              event = {{ censor_event }}),
           facet_row = {{facet_row}},
           facet_col = {{facet_col}}
           )
  # Calculate the number of facets based on 'facet.by'
  num_facets <- length(unique(data_surv$facet_row)) 
  num_facets2 <- length(unique(data_surv$facet_col))
  
  # Define the number of groups per facet
  num_groups <- length(unique(data_surv$life_x_disease_cat)) 
  
  # Generate the linetype vector dynamically
  linetype_vector <- rep(1:5, each = num_groups, 
                         length.out = num_facets * num_groups * num_facets2)

  fit_km <- survfit(surv_object ~ life_x_disease_cat, data = data_surv)
  fit_km |> 
    ggsurvplot(
      # needed data statement as extracts see help and without it doesn't work
      data = data_surv,
      facet.by = c("facet_row", "facet_col"),
      pval = FALSE, 
      conf.int = TRUE,
      censor = FALSE,
      fun = "pct",
      size = 1,
      linetype = linetype_vector, # Dynamic linetype
      palette = life_colours,
      legend = "bottom",
      legend.title = "Lifetime Lesion #",
      legend.labs = c("Never any lesion",
                      "Once",
                      "Twice",
                      "3 or more times"),
      xlab = "Days to Cull after Lesion",
      ylab = "% of Cows Alive",
      xlim = c(0,180),
      ylim = c(50,100),
      break.time.by = 30,
      short.panel.labs = TRUE
    )+
    guides(linetype = "none") # Remove the linetype legend
}


# function for table
km_fit_table <- function(data, censor_time = censor_time, 
                         censor_event = culled_ever) {
  data_surv <- data |> 
    mutate(surv_object = Surv(time = {{ censor_time }}, 
                              event = {{ censor_event }}))
  
  fit_table <- survfit(surv_object ~ life_x_disease_cat, data = data_surv)
  fit_table |> 
    tbl_survfit(times = c(30,120, 180),
                label = " ",
                type = "risk", 
                label_header = "{time} Days") %>% 
    as_flex_table() %>% # makes formatting and pdf better
    add_header_row(top = TRUE,
                   values = c("Lifetime Lesion History",
                              "% Culled (Confidence Interval) at",
                              "", "")) %>% 
    bold(i = 1, bold = TRUE, part = "header") %>% # bolds headers
    bold(i = 2, bold = TRUE, part = "header") %>% 
    merge_at(i = 1:2, j = 1, part = "header") %>% #merges 1st row
    merge_at(i = 1, j = 2:4, part = "header") %>% # merges top columns
    delete_rows(i = 1, part = "body")|>
    fit_to_width(max_width= 6.5) |> 
    hline_bottom(part = "body")
}

# commands to add into QMD----
# # create single dataset
# surval_inf <- survival_data(life_x_dz = lifexinf, disease = inf,
#                             years = 2024,
#                             disease_date = ftdat)
# # 
# # # create graph
# km_graph <- km_fit(data = surval_inf, event = culled,
#                    facet_col = farm,
#                    facet_row = year)

# 
# # km table
# km_table <- km_fit_table(data = surval_inf, event = culled)
# 
# # or combo approach
# km_graph2 <- survival_data(life_x_disease = lifexinf, disease_date = ftdat) |> 
#   km_fit(event = culled)
# 
# 
# # todo: create list of all datasets for lesions 
# # then feed to graph function
# 



