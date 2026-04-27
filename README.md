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
These are meant to be starter scripts for common (but non standard)
functions

------------------------------------------------------------------------

This process is made to spend as little time as possible pulling data.\
Therefore we will pull very granular data for all animals, and then
filter out what we don't need later

-   We need the following items from Dairy Comp along with the columns
    always generated with an events2 command in DC305 "HERDID" "ID"
    "PEN" "REG" "EID" "CBRD"\
    "BDAT" "EDAT" "LACT" "RC" "HDAT"\
    "FDAT" "CDAT" "DDAT" "PODAT" "ABDAT"\
    "VDAT" "ARDAT" "Event" "DIM" "Date"\
    "Remark" "R" "T" "B" "Protocols" "Technician"

FIRST - Pull events from dairy comp using one option from the code
below. Save the resulting csv file in the folder named
**data//event_files**

```         
-   Option 1 Pull 5 years in one file: EVENTS\\2S2000CHN #1 #2 #4 #5
    #6 #11 #12 #13 #15 #28 #29 #30 #31 #32 #38 #40 #43

-   Option 2 pull smaller time frames using "days back" starting
    with "S""days back" and ending with "L""days back":
    EVENTS\\2S99L0CHN #1 #2 #4 #5 #6 #11 #12 #13 #15 #28 #29 #30 #31
    #32 #38 #40 #43
    
```

NEXT - if you want to pull heifer data, pull the data and save in the
**event_files** folder (you can have both heifers and cows in your
event_files)

```         
-   Pull heifer data: EVENTS\\2S2000CHNY #1 #2 #4 #5
    #6 #11 #12 #13 #15 #28 #29 #30 #31 #32 #38 #40 #43
    
```

NEXT - if you want to look at production data, pull the data and save in
the **data//milk_files** folder

```         
-   EVENTS #1 #11 #29 #6 #13\\4S2000H
```

NEXT - Open the file names "STEP0_MASTER_PROCESSING.R" in Rstudio. Check
to make sure

-   that all farm specific options are set up correctly.

-   Set milk import function to TRUE if pulled milk data

-   Set heifer import function to TRUE if pulled heifer data

LAST - Run STEP0_MASTER_PROCESSING.R

FINALLY - Use the files in **data//intermediate files** folder to create
reports.

-   animals.parquet - each row is a unique animal

-   animal_lactations.parquet - each row is a unique animal lactation

-   events.parquet - each row is an event (animal, date, event,
    descriptive variables)

-   herd_denominators.parquet - each row is a count of animals per time
    period

You can view example reports in the **reports folder**. They will be in
subfolders.\
The ones listed below are all in **qmd_files**

-   report_data_dictionary.html explains variables in intermediate files

-   report_how_to_use_denominators.html goes through how to use the
    denominator files

-   the step3_xx files are show if you want more explanation of how the
    denominator code works

-   report_explore_lame is an example consulting report that is provided
    as a example of how to use the intermediate files.

------------------------------------------------------------------------

Code structure details and reference documents: tidyverse style guide
<https://style.tidyverse.org/files.html>.\
<https://design.tidyverse.org/>
