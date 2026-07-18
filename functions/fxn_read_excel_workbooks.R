# ============================================================================
# fxn_read_excel_workbooks.R
# ----------------------------------------------------------------------------
# A beginner-friendly function for reading an Excel workbook that has
# MORE THAN ONE SHEET (tab) into R, all at once.
#
# Normally, readxl::read_excel() only reads ONE sheet at a time. This function
# reads EVERY sheet and hands them back to you as a named list, so you don't
# have to call read_excel() over and over.
# ============================================================================


# ---- What you need installed -----------------------------------------------
# This function relies on the "readxl" package. You only have to install a
# package ONCE per computer. If you have never installed it, run this line in
# the Console (delete the leading "# " first):
#
#   install.packages("readxl")
#
# After it is installed, load it with library() each time you start R:
library(readxl)


# ============================================================================
# THE FUNCTION
# ----------------------------------------------------------------------------
# Name:   read_excel_workbooks
#
# What it does:
#   Reads ALL sheets from a single Excel file and returns them as a named
#   list of data frames (one data frame per sheet).
#
# Arguments (the information YOU give the function):
#   file_path  A single piece of text (a "string") giving the location of the
#              Excel file on your computer, e.g.
#              "data_excel/ClinicA.xlsx".
#              Tip: wrap the path in quotation marks.
#
# What it gives back (the "return value"):
#   A LIST. Each item in the list is one sheet, stored as a data frame.
#   The items are NAMED after the sheets in the workbook, so if your workbook
#   has sheets called "Treatments" and "Animals", you can pull them out with:
#       my_data[["Treatments"]]
#       my_data[["Animals"]]
#   You can also use a number for the position:
#       my_data[[1]]   # the first sheet
#       my_data[[2]]   # the second sheet
# ============================================================================

read_excel_workbooks <- function(file_path) {

  # --- Step 1: A friendly safety check ------------------------------------
  # Before we try to read the file, make sure it actually exists. If the path
  # is wrong, we stop here and print a clear message instead of a confusing
  # error later.
  if (!file.exists(file_path)) {
    stop(
      "I could not find a file at: '", file_path, "'.\n",
      "  - Check the spelling of the file name.\n",
      "  - Check that the folder path is correct.\n",
      "  - Remember paths are relative to your working directory ",
      "(see getwd())."
    )
  }

  # --- Step 2: Find out the names of every sheet in the workbook ----------
  # excel_sheets() returns a character vector of the sheet (tab) names,
  # for example: c("Treatments", "Animals", "Notes")
  sheet_names <- readxl::excel_sheets(file_path)

  # --- Step 3: Read each sheet into its own data frame --------------------
  # lapply() means "do the same thing to each item in a list and collect the
  # results". Here, for each sheet name we call read_excel() to read that one
  # sheet. The result is a list of data frames, in the same order as the
  # sheet names.
  list_of_sheets <- lapply(sheet_names, function(one_sheet) {
    readxl::read_excel(path = file_path, sheet = one_sheet)
  })

  # --- Step 4: Label each data frame with its sheet name ------------------
  # Right now the list items are unnamed (just 1, 2, 3...). This line attaches
  # the sheet names so you can refer to them by name later.
  names(list_of_sheets) <- sheet_names

  # --- Step 5: Give the finished list back to the user --------------------
  # Whatever appears on the last line of a function is what the function
  # "returns". We return the named list of sheets.
  return(list_of_sheets)
}


# ============================================================================
# HOW TO USE IT (a quick walkthrough)
# ----------------------------------------------------------------------------
# The lines below are EXAMPLES. They are "commented out" with a leading "# "
# so they do not run automatically when you source this file. To try them,
# copy a line into the Console and delete the leading "# ".
#
# 1) Load this function so R knows about it:
#      source("functions/fxn_read_excel_workbooks.R")
#
# 2) Read a workbook that has several sheets:
#      clinic_a <- read_excel_workbooks("data_excel/ClinicA.xlsx")
#
# 3) See the names of the sheets you got back:
#      names(clinic_a)
#
# 4) Look at the first sheet:
#      clinic_a[[1]]
#    ...or pull a sheet out by its name (replace with a real sheet name):
#      clinic_a[["Treatments"]]
#
# 5) How many sheets were there?
#      length(clinic_a)
# ============================================================================
