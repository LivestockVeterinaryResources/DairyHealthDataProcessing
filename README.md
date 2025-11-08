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

More details about the data structure can be found in the resources
folder: DataProcessingDocumentation.pptx.  

Template files/functions can also be found in the resources folder. 
These are meant to be starter scripts for common (but non standard) functions 

------------------------------------------------------------------------

FIRST - Pull the data and save in the **event_files folder**

-   We need the following items from Dairy Comp along with the columns
    always generated with an events2 command in DC305 "ID" "PEN" "REG"
    "EID" "CBRD"\
    "BDAT" "EDAT" "LACT" "RC" "HDAT"\
    "FDAT" "CDAT" "DDAT" "PODAT" "ABDAT"\
    "VDAT" "ARDAT" "Event" "DIM" "Date"\
    "Remark" "R" "T" "B" "Protocols" "Technician"

-   Pull events from dairy comp using one option from the code below.

    -   Option 1 Pull 5 years in one file: EVENTS\\2S2000CH #1 #2 #4 #5
        #6 #11 #12 #13 #15 #28 #29 #30 #31 #32 #38 #40 #43

    -   Option 2 pull smaller time frames using "days back" starting
        with "S""days back" and ending with "L""days back":
        EVENTS\\2S99L0CH #1 #2 #4 #5 #6 #11 #12 #13 #15 #28 #29 #30 #31
        #32 #38 #40 #43

    -   Option 3 automate the pull from a Google drive location.

        -   For this place the files in a Google drive location and
            ensure you change the drive url in the files below if using
            your own drive.

        -   Example Google Drive scripts

            -   "step00_get_data_from_google_drive.R",

            -   or for example data use the R script named
                "step00_get_example_data_from_google_drive.R" to
                download example farms

NEXT - if you want to look at production data, pull the data and save in
the **milk_files folder**

-   EVENTS #1 #11 #29 #6 #13\\4S2000H

NEXT - Open the file names "step0_MasterProcessing.R" in Rstudio. Check
to make sure

-   that all farm specific functions are set up correctly.

-   If you are pulling data from Google Drive make sure the above files
    are changed to your url.

-   Set milk import function to TRUE if pulled milk data

LAST - Run step0_MasterProcessing.R

FINALLY - View or create report files in the **reports** folder.
Standard reports created include

-   data_dictionary.html to show info about files and variables created

-   explore_event_types.html to do Quality control on how events are
    processed. If events aren't in categories you expect they can be
    manually coded to be in correct categories

-   2 denominator html files to show denominators for the herd

-   explore_lame.html as an example report.

------------------------------------------------------------------------

Code structure details and reference documents: tidyverse style guide
<https://style.tidyverse.org/files.html>.\
<https://design.tidyverse.org/>
