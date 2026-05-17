## day of phase parameters-----------------------------------
# set the parameters for grouping by DIM or heifers by days of age
set_cut_by_days <- 60 # number of days in each group
set_top_cut <- 400 # the final group for cow DIM with be this number and anything higher
set_top_cut_hfr <- 700 # the final group for heifer days of age with be this number and anything higher

## denominator granularity-----------------------
# Create a list of time periods (number of days) by which denominators will be created.
# The standard options are 21 and 365.  However any number works.
# You can add or delete as you wish, except for yearly. Yearly needs to stay
# the more time periods you add to this list the longer it will take to process files
# if you want calendar denominators (monthly, quarterly, etc) those already exist, don't add them here.
denominator_time_periods <- c(
  # 21,
  365
) # do NOT delete the yearly option or you will break the data_dictionary


