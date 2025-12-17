# ============================================================
# Asian Barometer W1 - Scale Reversal Script
# Corrected with standardized missing value codes
# ============================================================
#
# STANDARDIZED MISSING CODES:
#   -1  = Explicit missing/refusal
#   7   = Likert NA (Don't know, Not applicable, Refused)
#   8   = Likert NA (Don't know, Not applicable, Refused)
#   9   = Likert NA (Don't know, Not applicable, Refused)
#   98  = Other missing code
#   99  = Other missing code
#
# NOTE: 0 is NOT included - requires manual evaluation for binary variables
# ============================================================

library(dplyr)

# W1 Reversal Functions with Keyword Validation
# Generated automatically from scale analysis
# ============================================================

library(dplyr)


safe_reverse_2pt <- function(x, missing_codes = c(-1, 7, 8, 9, 98, 99)) {
  dplyr::case_when(
    x %in% 1:2 ~ 3 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_4pt <- function(x, missing_codes = c(-1, 7, 8, 9, 98, 99)) {
  dplyr::case_when(
    x %in% 1:4 ~ 5 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_5pt <- function(x, missing_codes = c(-1, 7, 8, 9, 98, 99)) {
  dplyr::case_when(
    x %in% 1:5 ~ 6 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_3pt <- function(x, missing_codes = c(-1, 7, 8, 9, 98, 99)) {
  dplyr::case_when(
    x %in% 1:9 ~ 10 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

# ============================================================
# W1 Variable Recodings with Validation
# ============================================================

w1 <- w1 %>%

  # ir009: Was the interview conducted with the assistance of an interpreter...
  # Keyword validation: 'conducted'
  mutate(ir009_reversed = if_else(
    grepl("conducted", question_text["ir009"], ignore.case = TRUE),
    safe_reverse_2pt(ir009),
    NA_real_  # Validation failed!
  )),

  # ir010c: Tell us whether the interviewee's residence has public water ...
  # Keyword validation: 'water'
  mutate(ir010c_reversed = if_else(
    grepl("water", question_text["ir010c"], ignore.case = TRUE),
    safe_reverse_2pt(ir010c),
    NA_real_  # Validation failed!
  )),

  # ir010d: Tell us whetherthe interviewee's residence has electricity
  # Keyword validation: 'electricity'
  mutate(ir010d_reversed = if_else(
    grepl("electricity", question_text["ir010d"], ignore.case = TRUE),
    safe_reverse_2pt(ir010d),
    NA_real_  # Validation failed!
  )),

  # q116: anyone you know personally witnessed an act of corruption?
  # Keyword validation: 'anyone'
  mutate(q116_reversed = if_else(
    grepl("anyone", question_text["q116"], ignore.case = TRUE),
    safe_reverse_2pt(q116),
    NA_real_  # Validation failed!
  )),

  # se004a: Marital Status(Y/N)
  # Keyword validation: 'marital'
  mutate(se004a_reversed = if_else(
    grepl("marital", question_text["se004a"], ignore.case = TRUE),
    safe_reverse_2pt(se004a),
    NA_real_  # Validation failed!
  )),

  # ir004: Has the respondent ever refused to be interviewed during the...
  # Keyword validation: 'refused'
  mutate(ir004_reversed = if_else(
    grepl("refused", question_text["ir004"], ignore.case = TRUE),
    safe_reverse_4pt(ir004),
    NA_real_  # Validation failed!
  )),

  # q104: How satisfied or dissatisfied are you with the current gover...
  # Keyword validation: 'satisfied'
  mutate(q104_reversed = if_else(
    grepl("satisfied", question_text["q104"], ignore.case = TRUE),
    safe_reverse_5pt(q104),
    NA_real_  # Validation failed!
  )),

  # q119: choose between democracy and economic development?
  # Keyword validation: 'choose'
  mutate(q119_reversed = if_else(
    grepl("choose", question_text["q119"], ignore.case = TRUE),
    safe_reverse_5pt(q119),
    NA_real_  # Validation failed!
  )),

  # ir003: Presence of others other than the respondent while interview...
  # Keyword validation: 'presence'
  mutate(ir003_reversed = if_else(
    grepl("presence", question_text["ir003"], ignore.case = TRUE),
    safe_reverse_3pt(ir003),
    NA_real_  # Validation failed!
  ))

# ============================================================
# W1 Summary
# Variables needing reversal: 10
# ============================================================


# ============================================================
