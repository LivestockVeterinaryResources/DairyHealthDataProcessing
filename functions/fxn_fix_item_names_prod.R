# BDAT--------------------
if (sum(str_detect(production_columns, "BIRTH")) > 0) {
  production <- production %>%
    rename(BDAT = BIRTH)
}

# BREED-------------------
if (sum(str_detect(production_columns, "BREED")) > 0) {
  production <- production %>%
    rename(CBRD = BREED)
}

# FRESH--------------------
if (sum(str_detect(production_columns, "FRSH")) > 0) {
  production <- production %>%
    rename(FDAT = FRSH)
}


# DIM--------------------
if (sum(str_detect(production_columns, "DNM")) > 0) {
  production <- production %>%
    rename(DIM = DNM)
}

# Linear Score --------------------
if (sum(str_detect(production_columns, "LS")) > 0) {
  production <- production %>%
    rename(LGSCC = LS)
}
