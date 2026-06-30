# ============================================================================
# read_excel_example.R
# ----------------------------------------------------------------------------
# EXAMPLE: read several Excel workbooks (one per clinic), where each workbook
# has multiple sheets (one per herd), and combine everything into a single
# tidy master table.
#
# The big idea (a "loop within a loop"):
#   * Loop 1 - go through each Excel FILE   -> this is a CLINIC
#   * Loop 2 - go through each SHEET in it  -> this is a HERD
#   * For every sheet we:
#        - read the data in as a tibble
#        - add a column original_file_name  (which file it came from)
#        - add a column herd_id             (which sheet it came from)
#   * After the loops, we stack all those tibbles on top of each other
#     (bind_rows) to get ONE master tibble.
#
# Why bother adding original_file_name and herd_id?
#   Once every row is stacked together, you can no longer tell which file or
#   sheet a row came from -- unless you record it as data first. These two
#   columns keep that information so you can group/filter by clinic or herd
#   later. We keep the WHOLE file name (e.g. "ClinicA.xlsx") so nothing is
#   lost; you can clean it up into a tidy clinic name however you like later.
# ============================================================================


# ---- 1. Load the tools we need ---------------------------------------------
# readxl  : reads Excel files (loaded by the function file we source below)
# dplyr   : gives us mutate() to add columns and bind_rows() to stack tables
# tibble  : the modern, tidy version of a data frame
library(tidyverse)

# Bring in OUR helper function, read_excel_workbooks(), which reads every
# sheet of one workbook and returns them as a list named by sheet.
# (Paths here are written relative to the PROJECT ROOT. If a path is not
#  found, check your working directory with getwd().)
source("functions/fxn_read_excel_workbooks.R")


# ---- 2. Find all the clinic Excel files ------------------------------------
# Instead of typing each file name by hand, we ask R to list every ".xlsx"
# file in the data folder. full.names = TRUE gives us the full path to each
# file, which is what we need to open them.
data_folder <- "resources/read_excel_workbook_examples/data_excel"

excel_files <- list.files(
  path       = data_folder,
  pattern    = "\\.xlsx$",   # only files ending in .xlsx
  full.names = TRUE
)

# Take a look at what we found:
print(excel_files)


# ---- 3. An empty "bucket" to collect each sheet's tibble -------------------
# We will read MANY tibbles (one per sheet). The tidy way to collect them is
# to drop each one into a list, then stack them all at the very end. We start
# with an empty list and add to it as we go.
collected_sheets <- list()


# ---- 4. The loop ------------------------------------------------------------
# OUTER LOOP: one pass per Excel file (one per clinic).
for (file_path in excel_files) {

  # Get the file name to record on every row.
  #   file_path is the full path, e.g.
  #     "resources/read_excel_workbook_examples/data_excel/ClinicA.xlsx"
  #   basename() drops the folder part, leaving the WHOLE file name:
  #     "ClinicA.xlsx"  (extension included, on purpose)
  # We keep it complete so no information is lost. You can trim it down to a
  # clean clinic name later, e.g. with tools::file_path_sans_ext().
  file_name <- basename(file_path)

  # Read EVERY sheet of this workbook at once. The result is a list of
  # tibbles, named by sheet (e.g. "H1", "H2"). Thanks to our function, the
  # names of this list ARE the sheet names.
  sheets_in_this_file <- read_excel_workbooks(file_path)

  # INNER LOOP: one pass per sheet (one per herd) in the current file.
  # We loop over the NAMES of the list so we always know the sheet name.
  for (sheet_name in names(sheets_in_this_file)) {

    # Pull out the tibble for this one sheet.
    one_sheet <- sheets_in_this_file[[sheet_name]]

    # Add our two tracking columns:
    #   original_file_name = the whole file name (which clinic's file)
    #   herd_id            = the sheet name      (which herd)
    # mutate() adds columns; relocate() just moves them to the front so they
    # are easy to see. Neither changes the original data values.
    one_sheet <- one_sheet %>%
      mutate(
        original_file_name = file_name,
        herd_id            = sheet_name
      ) %>%
      relocate(original_file_name, herd_id)

    # Drop this finished tibble into our bucket. Using a unique name like
    # "ClinicA.xlsx_H1" keeps the list tidy, but the name is not required.
    collected_sheets[[paste(file_name, sheet_name, sep = "_")]] <- one_sheet
  }
}


# ---- 5. Stack everything into ONE master tibble ----------------------------
# bind_rows() takes our list of tibbles and stacks them on top of each other.
# Handy detail: if some sheets have different columns than others, bind_rows
# lines up matching column names and fills any gaps with NA -- so it still
# works even though, for example, ClinicC uses different sheet names.
master_data <- bind_rows(collected_sheets)


# ---- 6. Look at the result --------------------------------------------------
# How many rows and columns did we end up with?
print(dim(master_data))

# Peek at the first few rows (note clinic_id and herd_id are right up front):
print(head(master_data))

# How many rows came from each file and herd? A quick sanity check that the
# loop tagged everything correctly.
master_data %>%
  count(original_file_name, herd_id) %>%
  print()


# ---- 7. (Optional) save the master table for later use ---------------------
# Uncomment a line below to write the combined data out to a file.
#   write.csv(master_data, "resources/read_excel_workbook_examples/master_data.csv", row.names = FALSE)
#   readr::write_rds(master_data, "resources/read_excel_workbook_examples/master_data.rds")
