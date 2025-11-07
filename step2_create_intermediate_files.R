library(tidyverse)
library(arrow)
library(dtplyr)



source("functions/fxn_lag_master.R")
source("functions/fxn_parse_free_text.R") # functions to parse remarks and protocols


# read in file-----------------

events_formatted <- read_parquet("data/intermediate_files/events_all_columns.parquet") |>
  # filter(!(is.na(bdat)))|>
  mutate(data_pull_date_min = min(date_event, na.rm = TRUE)) |>
  mutate(data_pull_date_max = max(date_event, na.rm = TRUE)) |>
  rowid_to_column() %>%
  mutate(rc_num = parse_number(RC))




# animals events---------------


## animals - each row is an animal------------
animals <- events_formatted |>
  group_by(
    id_animal, date_birth, ID,
    # source_farm, source_state, #optional
    data_pull_date_min, data_pull_date_max
  ) |>
  summarize(
    breed = paste0(sort(unique(breed)), collapse = ","),
    sex = max(RC),
    location_list = paste0(sort(unique(location_event)), collapse = ",")
  ) |>
  ungroup() %>%
  mutate(sex = case_when(
    (sex == 8) ~ "male",
    TRUE ~ "female"
  ))


## enrolled - each row is an animal------------
enrolls <- events_formatted |>
  group_by(id_animal) |>
  summarize(
    date_enrolled = min(date_event),
    date_enrolled_max = max(date_event)
  ) |>
  ungroup() |>
  distinct() |>
  mutate(qc_date_enrolled = as.numeric(date_enrolled_max - date_enrolled))


## deads - each row is animal---------------
deads <- events_formatted |>
  filter(event == "DIED") |>
  group_by(id_animal) |>
  summarize(
    date_died = min(date_event),
    date_died_max = max(date_event)
  ) |>
  ungroup() |>
  distinct() |>
  mutate(qc_date_died_diff = as.numeric(date_died_max - date_died))

## solds - each row is animal---------
solds <- events_formatted |>
  filter(event == "SOLD") |>
  group_by(id_animal) |>
  summarize(
    date_sold = min(date_event),
    date_sold_max = max(date_event)
  ) |>
  distinct() |>
  mutate(date_sold_diff = as.numeric(date_sold_max - date_sold))

## master animals------------------------------------------------
master_animals <- animals |>
  left_join(enrolls) |>
  left_join(solds) |>
  left_join(deads) |>
  mutate(date_left = case_when(
    (is.na(date_died) < 1) ~ date_died,
    (is.na(date_sold) < 1) ~ date_sold,
    TRUE ~ lubridate::mdy(NA)
  )) |>
  mutate(age_left = as.numeric(date_left - date_birth)) |>
  mutate(
    age_enrolled = as.numeric(date_enrolled - date_birth)
  ) |>
  rename(id = ID)

write_parquet(master_animals, "data/intermediate_files/animals.parquet")



# animal lactation events------------------------------------

## animal_lactations - each row is an animal/lactation----------
animal_lactations <- events_formatted |>
  group_by(
    id_animal, id_animal_lact, lact_number, ID,
    lact_group, lact_group_basic, lact_group_repro, lact_group_5
  ) |>
  summarize(
    date_lact_first_event = min(date_event),
    date_lact_last_event = max(date_event),
    location_lact_list = paste0(sort(unique(location_event)), collapse = ",")
  ) |>
  ungroup()


## archives - each row is animal/lactation-----------
archives <- events_formatted |>
  select(id_animal_lact, date_archived) |>
  distinct() |>
  group_by(id_animal_lact) |>
  summarize(
    date_archive = min(date_archived),
    date_archive_max = max(date_archived)
  ) |>
  distinct() |>
  mutate(date_archive_diff = as.numeric(date_archive_max - date_archive))

## freshs - each row is animal/lactation------------
freshs <- events_formatted |>
  filter(event == "FRESH") |>
  group_by(id_animal_lact) |>
  summarize(
    date_fresh = min(date_event),
    date_fresh_max = max(date_event)
  ) |>
  distinct() |>
  mutate(qc_date_fresh_diff = as.numeric(date_fresh_max - date_fresh))

fresh_date_next <- read_parquet("data/intermediate_files/events_all_columns.parquet") %>%
  filter(event %in% "FRESH") %>%
  group_by(id_animal, lact_number) %>%
  summarize(date_fresh = min(date_event)) %>%
  ungroup() %>%
  arrange(id_animal, date_fresh) %>%
  group_by(id_animal) %>%
  mutate(date_next_fresh = lead(date_fresh)) %>%
  ungroup() %>%
  select(id_animal, lact_number, date_fresh, date_next_fresh) %>%
  distinct()

## drys - each row is animal/lacatation----------------
drys <- events_formatted |>
  filter(event == "DRY") |>
  group_by(id_animal_lact) |>
  summarize(
    date_dry = min(date_event),
    date_dry_max = max(date_event)
  ) |>
  distinct() |>
  mutate(date_dry_diff = as.numeric(date_dry_max - date_dry))

## master animal_lactation events-----------------

master_animal_lactations <- animal_lactations |>
  left_join(freshs) |>
  left_join(drys) |>
  left_join(archives) |>
  left_join(fresh_date_next) %>%
  mutate(
    date_dim30 = date_fresh + 30,
    date_dim60 = date_fresh + 60,
    date_dim90 = date_fresh + 90,
    date_dim120 = date_fresh + 120,
    date_dim150 = date_fresh + 150,
    date_dim200 = date_fresh + 200,
    date_dim305 = date_fresh + 305,
    dim_at_archive = as.numeric(date_archive - date_fresh)
  ) |>
  rename(id = ID)

write_parquet(master_animal_lactations, "data/intermediate_files/animal_lactations.parquet")




# parse events-------------------------

events_parsed <- events_formatted %>%
  ## assign disease------------
  fxn_assign_disease() %>% # creates disease variable, function can be customized
  ## assign treatment --------------------
  fxn_assign_treatment() %>% # creates treatment variable, function can be customized
  mutate(across(
    .cols = c(disease, treatment),
    .fns = ~ str_replace_na(.x, "Unknown")
  )) # removes NA from disease and treatment variables

write_parquet(events_parsed, "data/intermediate_files/events_parsed.parquet")
