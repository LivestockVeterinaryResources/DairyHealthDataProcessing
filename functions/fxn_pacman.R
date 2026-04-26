# loads packages for set up ------------
fxn_pacman_all<-function(){
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  arrow,
  broom,
  DT,
  dtplyr,
  cardx,
  flextable,
  glue,
  googledrive,
  gt,
  gtsummary,
  lubridate,
  quarto,
  rmarkdown,
  scales,
  stringr,
  survival,
  survminer,
  tidyverse,
  waldo,
  zoo
)

}


fxn_pacman_processing<-function(){
  
# loads packages for set up ------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  arrow,
  DT,
  dtplyr,
  glue,
  googledrive,
  quarto,
  rmarkdown,
  scales,
  stringr,
  tidyverse
  )
}
