# ============================================================
# Asian Barometer W3 - Scale Reversal Script
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

# W3 Reversal Functions with Keyword Validation
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

safe_reverse_3pt <- function(x, missing_codes = c(-1, 7, 8, 9, 98, 99)) {
  dplyr::case_when(
    x %in% 1:3 ~ 4 - x,
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

safe_reverse_6pt <- function(x, missing_codes = c(-1, 7, 8, 9, 98, 99)) {
  dplyr::case_when(
    x %in% 1:6 ~ 7 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

# ============================================================
# W3 Variable Recodings with Validation
# ============================================================

w3 <- w3 %>%
  # ir10a: IR10a. Was the interview conducted with the assistance of an...
  # Keyword validation: 'ir10a'
  mutate(ir10a_reversed = if_else(
    grepl("ir10a", question_text["ir10a"], ignore.case = TRUE),
    safe_reverse_2pt(ir10a),
    NA_real_  # Validation failed!
  )),

  # ir11c: IR11c. Is electricity the main source of lighting in the hou...
  # Keyword validation: 'ir11c'
  mutate(ir11c_reversed = if_else(
    grepl("ir11c", question_text["ir11c"], ignore.case = TRUE),
    safe_reverse_2pt(ir11c),
    NA_real_  # Validation failed!
  )),

  # ir2: IR2. Is this the first questionnaire you have completed?
  # Keyword validation: 'questionnaire'
  mutate(ir2_reversed = if_else(
    grepl("questionnaire", question_text["ir2"], ignore.case = TRUE),
    safe_reverse_2pt(ir2),
    NA_real_  # Validation failed!
  )),

  # ir3: IR3. In the interview, other than the respondent, were other...
  # Keyword validation: 'present'
  mutate(ir3_reversed = if_else(
    grepl("present", question_text["ir3"], ignore.case = TRUE),
    safe_reverse_2pt(ir3),
    NA_real_  # Validation failed!
  )),

  # q34: q34. Thinking about the national election in [year], did you...
  # Keyword validation: 'attend'
  mutate(q34_reversed = if_else(
    grepl("attend", question_text["q34"], ignore.case = TRUE),
    safe_reverse_2pt(q34),
    NA_real_  # Validation failed!
  )),

  # q35: q35. try to persuade others to vote for a certain candidate ...
  # Keyword validation: 'persuade'
  mutate(q35_reversed = if_else(
    grepl("persuade", question_text["q35"], ignore.case = TRUE),
    safe_reverse_2pt(q35),
    NA_real_  # Validation failed!
  )),

  # q36: q36. Did you do anything else to help out or work for a part...
  # Keyword validation: 'anything'
  mutate(q36_reversed = if_else(
    grepl("anything", question_text["q36"], ignore.case = TRUE),
    safe_reverse_2pt(q36),
    NA_real_  # Validation failed!
  )),

  # se10: SE10. Are you the main earner in your household?(Chief wage ...
  # Keyword validation: 'chief'
  mutate(se10_reversed = if_else(
    grepl("chief", question_text["se10"], ignore.case = TRUE),
    safe_reverse_2pt(se10),
    NA_real_  # Validation failed!
  )),

  # se14a: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'total'
  mutate(se14a_reversed = if_else(
    grepl("total", question_text["se14a"], ignore.case = TRUE),
    safe_reverse_2pt(se14a),
    NA_real_  # Validation failed!
  )),

  # se14b: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'tractor'
  mutate(se14b_reversed = if_else(
    grepl("tractor", question_text["se14b"], ignore.case = TRUE),
    safe_reverse_2pt(se14b),
    NA_real_  # Validation failed!
  )),

  # se14c: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'television'
  mutate(se14c_reversed = if_else(
    grepl("television", question_text["se14c"], ignore.case = TRUE),
    safe_reverse_2pt(se14c),
    NA_real_  # Validation failed!
  )),

  # se14d: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'cable'
  mutate(se14d_reversed = if_else(
    grepl("cable", question_text["se14d"], ignore.case = TRUE),
    safe_reverse_2pt(se14d),
    NA_real_  # Validation failed!
  )),

  # se14e: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'motorcycle'
  mutate(se14e_reversed = if_else(
    grepl("motorcycle", question_text["se14e"], ignore.case = TRUE),
    safe_reverse_2pt(se14e),
    NA_real_  # Validation failed!
  )),

  # se14f: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'telephone'
  mutate(se14f_reversed = if_else(
    grepl("telephone", question_text["se14f"], ignore.case = TRUE),
    safe_reverse_2pt(se14f),
    NA_real_  # Validation failed!
  )),

  # se14g: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'mobile'
  mutate(se14g_reversed = if_else(
    grepl("mobile", question_text["se14g"], ignore.case = TRUE),
    safe_reverse_2pt(se14g),
    NA_real_  # Validation failed!
  )),

  # se14h: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'electric'
  mutate(se14h_reversed = if_else(
    grepl("electric", question_text["se14h"], ignore.case = TRUE),
    safe_reverse_2pt(se14h),
    NA_real_  # Validation failed!
  )),

  # se14i: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'bicycle'
  mutate(se14i_reversed = if_else(
    grepl("bicycle", question_text["se14i"], ignore.case = TRUE),
    safe_reverse_2pt(se14i),
    NA_real_  # Validation failed!
  )),

  # se14j: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'radio'
  mutate(se14j_reversed = if_else(
    grepl("radio", question_text["se14j"], ignore.case = TRUE),
    safe_reverse_2pt(se14j),
    NA_real_  # Validation failed!
  )),

  # se14k: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'pumping'
  mutate(se14k_reversed = if_else(
    grepl("pumping", question_text["se14k"], ignore.case = TRUE),
    safe_reverse_2pt(se14k),
    NA_real_  # Validation failed!
  )),

  # se14l: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'fridge'
  mutate(se14l_reversed = if_else(
    grepl("fridge", question_text["se14l"], ignore.case = TRUE),
    safe_reverse_2pt(se14l),
    NA_real_  # Validation failed!
  )),

  # se14m: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'camera'
  mutate(se14m_reversed = if_else(
    grepl("camera", question_text["se14m"], ignore.case = TRUE),
    safe_reverse_2pt(se14m),
    NA_real_  # Validation failed!
  )),

  # se14n: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'goats'
  mutate(se14n_reversed = if_else(
    grepl("goats", question_text["se14n"], ignore.case = TRUE),
    safe_reverse_2pt(se14n),
    NA_real_  # Validation failed!
  )),

  # se14o: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'buffalo'
  mutate(se14o_reversed = if_else(
    grepl("buffalo", question_text["se14o"], ignore.case = TRUE),
    safe_reverse_2pt(se14o),
    NA_real_  # Validation failed!
  )),

  # q124: q124. Which of the following statements comes closest to you...
  # Keyword validation: 'comes'
  mutate(q124_reversed = if_else(
    grepl("comes", question_text["q124"], ignore.case = TRUE),
    safe_reverse_3pt(q124),
    NA_real_  # Validation failed!
  )),

  # q32: q32. In talking to people about elections, we often find tha...
  # Keyword validation: 'talking'
  mutate(q32_reversed = if_else(
    grepl("talking", question_text["q32"], ignore.case = TRUE),
    safe_reverse_3pt(q32),
    NA_real_  # Validation failed!
  )),

  # q46: q46. When you get together with your family members or frien...
  # Keyword validation: 'members'
  mutate(q46_reversed = if_else(
    grepl("members", question_text["q46"], ignore.case = TRUE),
    safe_reverse_3pt(q46),
    NA_real_  # Validation failed!
  )),

  # se10d: SE10d. Is he or she currently seeking employment?
  # Keyword validation: 'se10d'
  mutate(se10d_reversed = if_else(
    grepl("se10d", question_text["se10d"], ignore.case = TRUE),
    safe_reverse_3pt(se10d),
    NA_real_  # Validation failed!
  )),

  # se9d: SE9d. Are you currently seeking employment?
  # Keyword validation: 'seeking'
  mutate(se9d_reversed = if_else(
    grepl("seeking", question_text["se9d"], ignore.case = TRUE),
    safe_reverse_3pt(se9d),
    NA_real_  # Validation failed!
  )),

  # ir4: IR4. Has the respondent ever refused to be interviewed durin...
  # Keyword validation: 'refused'
  mutate(ir4_reversed = if_else(
    grepl("refused", question_text["ir4"], ignore.case = TRUE),
    safe_reverse_4pt(ir4),
    NA_real_  # Validation failed!
  )),

  # q10: I'm going to name a number of institutions. For each one, pl...
  # Keyword validation: 'specific'
  mutate(q10_reversed = if_else(
    grepl("specific", question_text["q10"], ignore.case = TRUE),
    safe_reverse_4pt(q10),
    NA_real_  # Validation failed!
  )),

  # q108: q108. Do officials who commit crimes go unpunished?
  # Keyword validation: 'commit'
  mutate(q108_reversed = if_else(
    grepl("commit", question_text["q108"], ignore.case = TRUE),
    safe_reverse_4pt(q108),
    NA_real_  # Validation failed!
  )),

  # q109: q109. How often do government officials withhold important i...
  # Keyword validation: 'withhold'
  mutate(q109_reversed = if_else(
    grepl("withhold", question_text["q109"], ignore.case = TRUE),
    safe_reverse_4pt(q109),
    NA_real_  # Validation failed!
  )),

  # q11: I'm going to name a number of institutions. For each one, pl...
  # Keyword validation: 'parliament'
  mutate(q11_reversed = if_else(
    grepl("parliament", question_text["q11"], ignore.case = TRUE),
    safe_reverse_4pt(q11),
    NA_real_  # Validation failed!
  )),

  # q110: q110. How often do you think government leaders break the la...
  # Keyword validation: 'abuse'
  mutate(q110_reversed = if_else(
    grepl("abuse", question_text["q110"], ignore.case = TRUE),
    safe_reverse_4pt(q110),
    NA_real_  # Validation failed!
  )),

  # q111: q111.  How often do you think our elections offer the voters...
  # Keyword validation: 'offer'
  mutate(q111_reversed = if_else(
    grepl("offer", question_text["q111"], ignore.case = TRUE),
    safe_reverse_4pt(q111),
    NA_real_  # Validation failed!
  )),

  # q115: q115. How much do you feel that having elections makes the g...
  # Keyword validation: 'having'
  mutate(q115_reversed = if_else(
    grepl("having", question_text["q115"], ignore.case = TRUE),
    safe_reverse_4pt(q115),
    NA_real_  # Validation failed!
  )),

  # q12: I'm going to name a number of institutions. For each one, pl...
  # Keyword validation: 'civil'
  mutate(q12_reversed = if_else(
    grepl("civil", question_text["q12"], ignore.case = TRUE),
    safe_reverse_4pt(q12),
    NA_real_  # Validation failed!
  )),

  # q13: I'm going to name a number of institutions. For each one, pl...
  # Keyword validation: 'armed'
  mutate(q13_reversed = if_else(
    grepl("armed", question_text["q13"], ignore.case = TRUE),
    safe_reverse_4pt(q13),
    NA_real_  # Validation failed!
  )),

  # q14: I'm going to name a number of institutions. For each one, pl...
  # Keyword validation: 'police'
  mutate(q14_reversed = if_else(
    grepl("police", question_text["q14"], ignore.case = TRUE),
    safe_reverse_4pt(q14),
    NA_real_  # Validation failed!
  )),

  # q15: I'm going to name a number of institutions. For each one, pl...
  # Keyword validation: 'local'
  mutate(q15_reversed = if_else(
    grepl("local", question_text["q15"], ignore.case = TRUE),
    safe_reverse_4pt(q15),
    NA_real_  # Validation failed!
  )),

  # q16: I'm going to name a number of institutions. For each one, pl...
  # Keyword validation: 'newspapers'
  mutate(q16_reversed = if_else(
    grepl("newspapers", question_text["q16"], ignore.case = TRUE),
    safe_reverse_4pt(q16),
    NA_real_  # Validation failed!
  )),

  # q17: I'm going to name a number of institutions. For each one, pl...
  # Keyword validation: 'television'
  mutate(q17_reversed = if_else(
    grepl("television", question_text["q17"], ignore.case = TRUE),
    safe_reverse_4pt(q17),
    NA_real_  # Validation failed!
  )),

  # q18: I'm going to name a number of institutions. For each one, pl...
  # Keyword validation: 'commission'
  mutate(q18_reversed = if_else(
    grepl("commission", question_text["q18"], ignore.case = TRUE),
    safe_reverse_4pt(q18),
    NA_real_  # Validation failed!
  )),

  # q19: I'm going to name a number of institutions. For each one, pl...
  # Keyword validation: 'governmental'
  mutate(q19_reversed = if_else(
    grepl("governmental", question_text["q19"], ignore.case = TRUE),
    safe_reverse_4pt(q19),
    NA_real_  # Validation failed!
  )),

  # q25: q25. How much trust do you have in each of the following typ...
  # Keyword validation: 'relatives'
  mutate(q25_reversed = if_else(
    grepl("relatives", question_text["q25"], ignore.case = TRUE),
    safe_reverse_4pt(q25),
    NA_real_  # Validation failed!
  )),

  # q26: How much trust do you have in each of the following types of...
  # Keyword validation: 'neighbors'
  mutate(q26_reversed = if_else(
    grepl("neighbors", question_text["q26"], ignore.case = TRUE),
    safe_reverse_4pt(q26),
    NA_real_  # Validation failed!
  )),

  # q27: How much trust do you have in each of the following types of...
  # Keyword validation: 'interact'
  mutate(q27_reversed = if_else(
    grepl("interact", question_text["q27"], ignore.case = TRUE),
    safe_reverse_4pt(q27),
    NA_real_  # Validation failed!
  )),

  # q7: q7. I'm going to name a number of institutions. For each one...
  # Keyword validation: 'president'
  mutate(q7_reversed = if_else(
    grepl("president", question_text["q7"], ignore.case = TRUE),
    safe_reverse_4pt(q7),
    NA_real_  # Validation failed!
  )),

  # q8: I'm going to name a number of institutions. For each one, pl...
  # Keyword validation: 'courts'
  mutate(q8_reversed = if_else(
    grepl("courts", question_text["q8"], ignore.case = TRUE),
    safe_reverse_4pt(q8),
    NA_real_  # Validation failed!
  )),

  # q9: I'm going to name a number of institutions. For each one, pl...
  # Keyword validation: 'capital'
  mutate(q9_reversed = if_else(
    grepl("capital", question_text["q9"], ignore.case = TRUE),
    safe_reverse_4pt(q9),
    NA_real_  # Validation failed!
  )),

  # q1: q1. How would you rate the overall economic condition of our...
  # Keyword validation: 'overall'
  mutate(q1_reversed = if_else(
    grepl("overall", question_text["q1"], ignore.case = TRUE),
    safe_reverse_5pt(q1),
    NA_real_  # Validation failed!
  )),

  # q4: q4. As for your own family, how do you rate the economic sit...
  # Keyword validation: 'situation'
  mutate(q4_reversed = if_else(
    grepl("situation", question_text["q4"], ignore.case = TRUE),
    safe_reverse_5pt(q4),
    NA_real_  # Validation failed!
  )),

  # q119_1: Have you or anyone you know personally witnessed an act of c...
  # Keyword validation: '119_1'
  mutate(q119_1_reversed = if_else(
    grepl("119_1", question_text["q119_1"], ignore.case = TRUE),
    safe_reverse_3pt(q119_1),
    NA_real_  # Validation failed!
  )),

  # q119_2: Have you or anyone you know personally witnessed an act of c...
  # Keyword validation: '119_2'
  mutate(q119_2_reversed = if_else(
    grepl("119_2", question_text["q119_2"], ignore.case = TRUE),
    safe_reverse_3pt(q119_2),
    NA_real_  # Validation failed!
  )),

  # q119_3: Have you or anyone you know personally witnessed an act of c...
  # Keyword validation: '119_3'
  mutate(q119_3_reversed = if_else(
    grepl("119_3", question_text["q119_3"], ignore.case = TRUE),
    safe_reverse_3pt(q119_3),
    NA_real_  # Validation failed!
  )),

  # q23: q23. General speaking, would you say that "Most people can b...
  # Keyword validation: 'trusted'
  mutate(q23_reversed = if_else(
    grepl("trusted", question_text["q23"], ignore.case = TRUE),
    safe_reverse_3pt(q23),
    NA_real_  # Validation failed!
  )),

  # q161: q161. General speaking, the influence China has on our count...
  # Keyword validation: 'general'
  mutate(q161_reversed = if_else(
    grepl("general", question_text["q161"], ignore.case = TRUE),
    safe_reverse_6pt(q161),
    NA_real_  # Validation failed!
  ))

# ============================================================
# W3 Summary
# Variables needing reversal: 57
# ============================================================


# ============================================================
