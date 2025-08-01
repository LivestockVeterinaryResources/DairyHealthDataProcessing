# DairyEventBasics - single herd management file

The goal of this is to streamline initial data processing so that more
time can be spent acting on conclusions from data rather than processing
it. The example code below pulls 5 years of data in order to have the
opportunity to look at trends over at least 3 years with complete
lactations for most cows. However, depending on what you want to look
at, a shorter time frame may be utilized.

This workflow is set up to intentionally NOT share original data files
due to both their size and privacy. For this reason any files you put in
the Data/ subfolders will not be shared to git unless they are in the
Data/SharedFiles folder.

Step 1 - Pull the data and save in the **event_files folder**

-   We need the following items from Dairy Comp along with the columns
    always generated with an events2 command in DC305 "ID" "PEN" "REG"
    "EID" "CBRD"\
    "BDAT" "EDAT" "LACT" "RC" "HDAT"\
    "FDAT" "CDAT" "DDAT" "PODAT" "ABDAT"\
    "VDAT" "ARDAT" "Event" "DIM" "Date"\
    "Remark" "R" "T" "B" "Protocols" "Technician"

-   Pull events from dairy comp using one option from the code below.

-   Option 1 Pull 5 years in one file: EVENTS\\2S2000CH #1 #2 #4 #5 #6
    #11 #12 #13 #15 #28 #29 #30 #31 #32 #38 #40 #43

Option 2 pull smaller time frames using "days back" starting with
"S""days back" and ending with "L""days back": EVENTS\\2S99L0CH #1 #2 #4
#5 #6 #11 #12 #13 #15 #28 #29 #30 #31 #32 #38 #40 #43

Step 2 - Open the file names "step0_MasterProcessing.Rmd" in Rstudio.
Check to make sure that all farm specific functions are set up
correctly.

Step 3 - Run step0_MasterProcessing.Rmd

Step 4 - View the report files. If files are written to shiny apps, open
the app code and deploy them.

Code structure details and reference documents: tidyverse style guide
<https://style.tidyverse.org/files.html>.\
<https://design.tidyverse.org/>

Future stuff: DC305 code to pull milk data:

EVENTS #1 #11 #29 #6 #13\\4S2000H

Step 1 - Pull the data and save in the **milk_files folder**
