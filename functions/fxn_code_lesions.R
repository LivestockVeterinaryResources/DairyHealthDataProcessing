# create function for to classify lesions
# this function can be usefull for classifying other remarks/protocols

str_contains <- function(string,
                         pattern,
                         ignore_case = TRUE) {
  str_detect(
    string,
    regex(pattern,
      ignore_case = ignore_case
    )
  )
}


# classify protocol/remarks into lesions using standard remarks/protocols
# requires a check to make things align
# uses other to catch weird ones and non standard remarks/protocols

fxn_code_lesions <- function(.df, event_var = event,
                             protocol_var = protocols,
                             remark_var = remark) {
  .df |>
    mutate(
      trimonly = case_when(
        # coded so decisions can be made about NA's
        str_contains({{ protocol_var }}, "Trim") ~ 1,
        str_contains({{ protocol_var }}, "NONE") ~ 1,
        str_contains({{ remark_var }}, "Trim") ~ 1,
        !is.na({{ protocol_var }}) ~ 0,
        !is.na({{ remark_var }}) ~ 0,
        .default = NA
      ),
      ## update this below using str_contains
      sole_ulcer = case_when(
        str_contains({{ remark_var }}, "BLKU") ~ 1,
        str_contains({{ remark_var }}, "NONU") ~ 1,
        str_contains({{ remark_var }}, "TRMU") ~ 1,
        str_contains({{ protocol_var }}, "Sole Ulcer") ~ 1,
        .default = 0
      ),
      wld = case_when(
        str_contains({{ remark_var }}, "BLKW") ~ 1,
        str_contains({{ remark_var }}, "NONW") ~ 1,
        str_contains({{ remark_var }}, "TRMW") ~ 1,
        str_contains({{ protocol_var }}, "White") ~ 1,
        .default = 0
      ),
      toe_ulcer = case_when(
        str_contains({{ remark_var }}, "BLKT") ~ 1,
        str_contains({{ remark_var }}, "NONT") ~ 1,
        str_contains({{ remark_var }}, "TRMT") ~ 1,
        str_contains({{ protocol_var }}, "Toe Ulcer") ~ 1,
        .default = 0
      ),
      thin = case_when(
        str_contains({{ remark_var }}, "BLKZ") ~ 1,
        str_contains({{ remark_var }}, "NONZ") ~ 1,
        str_contains({{ remark_var }}, "TRMZ") ~ 1,
        str_contains({{ protocol_var }}, "Thin") ~ 1,
        .default = 0
      ),
      # collapse toe problems into 1 lesion
      toe = if_else(thin == 1 | toe_ulcer == 1, 1, 0),
      sole_fracture = case_when(
        str_contains({{ remark_var }}, "NONF") ~ 1,
        str_contains({{ protocol_var }}, "Fracture") ~ 1,
        .default = 0
      ),
      dd = case_when(
        str_contains({{ remark_var }}, "INFD") ~ 1,
        str_contains({{ remark_var }}, "INFC") ~ 1,
        str_contains({{ remark_var }}, "LATD") ~ 1,
        str_contains({{ remark_var }}, "TETD") ~ 1,
        str_contains({{ protocol_var }}, "Dig") ~ 1,
        str_contains({{ protocol_var }}, "Wart") ~ 1,
        str_contains({{ protocol_var }}, "DD") ~ 1,
        str_contains({{ protocol_var }}, "Hairy") ~ 1,
        .default = 0
      ),
      footrot = case_when(
        # put infront to deal with protocol # issues when cows move
        str_contains({{ remark_var }}, "INFF") ~ 1,
        str_contains({{ remark_var }}, "ABXF") ~ 1,
        str_contains({{ remark_var }}, "XNLF") ~ 1,
        str_contains({{ remark_var }}, "EXNF") ~ 1,
        str_contains({{ remark_var }}, "EXCF") ~ 1,
        str_contains({{ remark_var }}, "XCDF") ~ 1,
        str_contains({{ protocol_var }}, "Footrot") ~ 1,
        str_contains({{ protocol_var }}, "rot") ~ 1,
        str_contains({{ protocol_var }}, "foot rot") ~ 1,
        .default = 0
      ),
      hemorrhage = case_when(
        str_contains({{ remark_var }}, "TRMH") ~ 1,
        str_contains({{ remark_var }}, "TRMY") ~ 1,
        str_contains({{ protocol_var }}, "Hem") ~ 1,
        .default = 0
      ),
      axial = case_when(
        str_contains({{ protocol_var }}, "Axial wall") ~ 1,
        str_contains({{ protocol_var }}, "white line in") ~ 1,
        str_contains({{ remark_var }}, "BLKX") ~ 1,
        .default = 0
      ),
      cork = case_when(
        str_contains({{ remark_var }}, "TRMC") ~ 1,
        str_contains({{ remark_var }}, "NONC") ~ 1,
        str_contains({{ protocol_var }}, "Cork") ~ 1,
        .default = 0
      ),
      injury = case_when(
        str_contains({{ remark_var }}, "TRML") ~ 1,
        str_contains({{ protocol_var }}, "Injury") ~ 1,
        str_contains({{ protocol_var }}, "Leg") ~ 1,
        .default = 0
      ),
      # classify minor lesions or other weird remarks/protocols
      other = if_else(
        trimonly == 0 & sole_ulcer == 0 & footrot == 0 &
          wld == 0 & dd == 0 & injury == 0 & toe == 0,
        1, 0
      ),
      # classify into broad categories
      inf = if_else(dd == 1 | footrot == 1, 1, 0),
      noninf = if_else(sole_ulcer == 1 | wld == 1 | toe == 1 |
        sole_fracture == 1 | hemorrhage == 1,
      1, 0
      ),
      # codes it so any cow not a trim only has a lesion
      lesion = if_else(trimonly == 1, 0, 1)
    )
}
