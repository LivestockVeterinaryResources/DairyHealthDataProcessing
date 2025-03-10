#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
# add R folder and put scripts/functions in that

# set themes

library(shiny)
library(bslib)

ui <- page_sidebar( 
  title = "Hoof Lesion Data Analysis App", 
  theme = bs_theme(base_font = font_google("Outfit"),
                   preset = "simplex", bg = "white", fg = "#7a0019",
                   primary = "grey"), 
  
  sidebar = sidebar(
    h4("Options"),
    hr(),
    selectInput(inputId = "Parameter",
                label = "Select graphing parameter",
                c("Overall Incidence", "DIM", "Season"),
    ),
    hr(),
    radioButtons(inputId = "lactation", 
                 label = "Select Lactation:",
                choices = c("All", "1", "2", "3+")
                ),
    hr(),
    dateRangeInput(inputId = "date", label = "Analysis Date Range "),
    hr(),
    verbatimTextOutput("date"),
    verbatimTextOutput("date1"),
    verbatimTextOutput("date2"),
    
    verbatimTextOutput("date1_class"),
    verbatimTextOutput("date1_year")
  ),
  
  navset_tab(
  nav_panel("Any Lesions", "Page A content"), 
  nav_panel("Infectious Lesions", "Page B content"), 
  nav_panel("Non Infectious Lesions", "Page C content"), 
  
  # Place additional UI elements properly
  header = uiOutput("valueboxes"),
  
  # Use `tags$div` for image styling correctly
  footer = tags$div(
    img(src = "umn_logo.jpg",
        width = "80px",
        height = "96px",
        style = "position: fixed; bottom: 
        24px; right: 24px; opacity: 0.75; z-index: 1;"
    )
  )
  )
)


server <- function(input, output) {
  bs_themer()
  
}


# Run the application 
shinyApp(ui = ui, server = server)
