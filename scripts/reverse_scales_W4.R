# ============================================================
# Asian Barometer W4 - Scale Reversal Script
# Corrected with standardized missing value codes
# ============================================================
#
# This script reverses scales where higher values indicate
# LESS of the attribute (e.g., 1=Satisfied, 4=Dissatisfied)
#
# Each recoding includes:
# 1. Scale-specific reversal function with STANDARDIZED missing codes
# 2. Keyword validation via grepl() to ensure correct question
# 3. Missing value handling: c(-1, 7, 8, 9, 98, 99)
# 4. Outlier detection
#
# STANDARDIZED MISSING CODES:
#   -1  = Explicit missing/refusal
#   7   = Likert NA (Don't know, Not applicable, Refused)
#   8   = Likert NA (Don't know, Not applicable, Refused)
#   9   = Likert NA (Don't know, Not applicable, Refused)
#   98  = Other missing code
#   99  = Other missing code
# ============================================================

library(dplyr)

# W4 Reversal Functions with Keyword Validation
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
# W4 Variable Recodings with Validation
# ============================================================

w4 <- w4 %>%
  # fg: What do you think the economic situation of your family will...
  # Keyword validation: 'member'
  mutate(fg_reversed = if_else(
    grepl("member", question_text["fg"], ignore.case = TRUE),
    safe_reverse_2pt(fg),
    NA_real_  # Validation failed!
  )),

  # ir10a: ir10a Was the interview conducted with the assistance of an ...
  # Keyword validation: 'ir10a'
  mutate(ir10a_reversed = if_else(
    grepl("ir10a", question_text["ir10a"], ignore.case = TRUE),
    safe_reverse_2pt(ir10a),
    NA_real_  # Validation failed!
  )),

  # ir11c: ir11c Is electricity the main source of lighting in the hous...
  # Keyword validation: 'ir11c'
  mutate(ir11c_reversed = if_else(
    grepl("ir11c", question_text["ir11c"], ignore.case = TRUE),
    safe_reverse_2pt(ir11c),
    NA_real_  # Validation failed!
  )),

  # ir11d: ir11d Is this neighborhood covered by mobil phone network?
  # Keyword validation: 'ir11d'
  mutate(ir11d_reversed = if_else(
    grepl("ir11d", question_text["ir11d"], ignore.case = TRUE),
    safe_reverse_2pt(ir11d),
    NA_real_  # Validation failed!
  )),

  # ir2: ir2 Is this the first questionnaire you have completed?
  # Keyword validation: 'questionnaire'
  mutate(ir2_reversed = if_else(
    grepl("questionnaire", question_text["ir2"], ignore.case = TRUE),
    safe_reverse_2pt(ir2),
    NA_real_  # Validation failed!
  )),

  # ir3: ir3 In the interview, other than the respondent, were others...
  # Keyword validation: 'present'
  mutate(ir3_reversed = if_else(
    grepl("present", question_text["ir3"], ignore.case = TRUE),
    safe_reverse_2pt(ir3),
    NA_real_  # Validation failed!
  )),

  # q23: 23 Would you say that "Most people can be trusted" or "that ...
  # Keyword validation: 'trusted'
  mutate(q23_reversed = if_else(
    grepl("trusted", question_text["q23"], ignore.case = TRUE),
    safe_reverse_2pt(q23),
    NA_real_  # Validation failed!
  )),

  # q33: 33 Did you vote in the last national election?
  # Keyword validation: 'national'
  mutate(q33_reversed = if_else(
    grepl("national", question_text["q33"], ignore.case = TRUE),
    safe_reverse_2pt(q33),
    NA_real_  # Validation failed!
  )),

  # q35: 35. Did you attend a campaign meeting or rally?
  # Keyword validation: 'attend'
  mutate(q35_reversed = if_else(
    grepl("attend", question_text["q35"], ignore.case = TRUE),
    safe_reverse_2pt(q35),
    NA_real_  # Validation failed!
  )),

  # q36: 36. Try to persudae others to vote for a certain candidate o...
  # Keyword validation: 'persudae'
  mutate(q36_reversed = if_else(
    grepl("persudae", question_text["q36"], ignore.case = TRUE),
    safe_reverse_2pt(q36),
    NA_real_  # Validation failed!
  )),

  # q37: 37. Did you do anything else to help out or work for a party...
  # Keyword validation: 'anything'
  mutate(q37_reversed = if_else(
    grepl("anything", question_text["q37"], ignore.case = TRUE),
    safe_reverse_2pt(q37),
    NA_real_  # Validation failed!
  )),

  # q47: 47. Do you have Internet access at home?
  # Keyword validation: 'access'
  mutate(q47_reversed = if_else(
    grepl("access", question_text["q47"], ignore.case = TRUE),
    safe_reverse_2pt(q47),
    NA_real_  # Validation failed!
  )),

  # q48: 48. Do you have Internet access on a mobile phone?
  # Keyword validation: 'mobile'
  mutate(q48_reversed = if_else(
    grepl("mobile", question_text["q48"], ignore.case = TRUE),
    safe_reverse_2pt(q48),
    NA_real_  # Validation failed!
  )),

  # q50: 50. Do you currently use any of the following social media n...
  # Keyword validation: 'networks'
  mutate(q50_reversed = if_else(
    grepl("networks", question_text["q50"], ignore.case = TRUE),
    safe_reverse_2pt(q50),
    NA_real_  # Validation failed!
  )),

  # se15a: se15a Do your family own the following? Car/Jeep
  # Keyword validation: 'se15a'
  mutate(se15a_reversed = if_else(
    grepl("se15a", question_text["se15a"], ignore.case = TRUE),
    safe_reverse_2pt(se15a),
    NA_real_  # Validation failed!
  )),

  # se15b: se15b Tractor
  # Keyword validation: 'se15b'
  mutate(se15b_reversed = if_else(
    grepl("se15b", question_text["se15b"], ignore.case = TRUE),
    safe_reverse_2pt(se15b),
    NA_real_  # Validation failed!
  )),

  # se15c: se15c Color or B/W television
  # Keyword validation: 'se15c'
  mutate(se15c_reversed = if_else(
    grepl("se15c", question_text["se15c"], ignore.case = TRUE),
    safe_reverse_2pt(se15c),
    NA_real_  # Validation failed!
  )),

  # se15d: se15d Cable TV
  # Keyword validation: 'se15d'
  mutate(se15d_reversed = if_else(
    grepl("se15d", question_text["se15d"], ignore.case = TRUE),
    safe_reverse_2pt(se15d),
    NA_real_  # Validation failed!
  )),

  # se15e: se15e Scooter/motorcycle/moped
  # Keyword validation: 'se15e'
  mutate(se15e_reversed = if_else(
    grepl("se15e", question_text["se15e"], ignore.case = TRUE),
    safe_reverse_2pt(se15e),
    NA_real_  # Validation failed!
  )),

  # se15f: se15f Telephone
  # Keyword validation: 'se15f'
  mutate(se15f_reversed = if_else(
    grepl("se15f", question_text["se15f"], ignore.case = TRUE),
    safe_reverse_2pt(se15f),
    NA_real_  # Validation failed!
  )),

  # se15g: se15g Mobile phone
  # Keyword validation: 'se15g'
  mutate(se15g_reversed = if_else(
    grepl("se15g", question_text["se15g"], ignore.case = TRUE),
    safe_reverse_2pt(se15g),
    NA_real_  # Validation failed!
  )),

  # se15h: se15h Electric fan/cooler
  # Keyword validation: 'se15h'
  mutate(se15h_reversed = if_else(
    grepl("se15h", question_text["se15h"], ignore.case = TRUE),
    safe_reverse_2pt(se15h),
    NA_real_  # Validation failed!
  )),

  # se15i: se15i Bicycle
  # Keyword validation: 'se15i'
  mutate(se15i_reversed = if_else(
    grepl("se15i", question_text["se15i"], ignore.case = TRUE),
    safe_reverse_2pt(se15i),
    NA_real_  # Validation failed!
  )),

  # se15j: se15j Radio/transistor
  # Keyword validation: 'se15j'
  mutate(se15j_reversed = if_else(
    grepl("se15j", question_text["se15j"], ignore.case = TRUE),
    safe_reverse_2pt(se15j),
    NA_real_  # Validation failed!
  )),

  # se15k: se15k pumping set
  # Keyword validation: 'se15k'
  mutate(se15k_reversed = if_else(
    grepl("se15k", question_text["se15k"], ignore.case = TRUE),
    safe_reverse_2pt(se15k),
    NA_real_  # Validation failed!
  )),

  # se15l: se15l Fridge
  # Keyword validation: 'se15l'
  mutate(se15l_reversed = if_else(
    grepl("se15l", question_text["se15l"], ignore.case = TRUE),
    safe_reverse_2pt(se15l),
    NA_real_  # Validation failed!
  )),

  # se15m: se15m Camera
  # Keyword validation: 'se15m'
  mutate(se15m_reversed = if_else(
    grepl("se15m", question_text["se15m"], ignore.case = TRUE),
    safe_reverse_2pt(se15m),
    NA_real_  # Validation failed!
  )),

  # se15n: se15n Goats/sheep
  # Keyword validation: 'se15n'
  mutate(se15n_reversed = if_else(
    grepl("se15n", question_text["se15n"], ignore.case = TRUE),
    safe_reverse_2pt(se15n),
    NA_real_  # Validation failed!
  )),

  # se15o: se15o Cows/Buffalo
  # Keyword validation: 'se15o'
  mutate(se15o_reversed = if_else(
    grepl("se15o", question_text["se15o"], ignore.case = TRUE),
    safe_reverse_2pt(se15o),
    NA_real_  # Validation failed!
  )),

  # ir11b: ir11b Is there tape water in the household?
  # Keyword validation: 'ir11b'
  mutate(ir11b_reversed = if_else(
    grepl("ir11b", question_text["ir11b"], ignore.case = TRUE),
    safe_reverse_3pt(ir11b),
    NA_real_  # Validation failed!
  )),

  # q125: 125 Which of the following statements comes closest to your ...
  # Keyword validation: 'closest'
  mutate(q125_reversed = if_else(
    grepl("closest", question_text["q125"], ignore.case = TRUE),
    safe_reverse_3pt(q125),
    NA_real_  # Validation failed!
  )),

  # q46: 46. When you get together with your family members or friend...
  # Keyword validation: 'discuss'
  mutate(q46_reversed = if_else(
    grepl("discuss", question_text["q46"], ignore.case = TRUE),
    safe_reverse_3pt(q46),
    NA_real_  # Validation failed!
  )),

  # se10d: se10d Is he or she currently seeking employment?
  # Keyword validation: 'se10d'
  mutate(se10d_reversed = if_else(
    grepl("se10d", question_text["se10d"], ignore.case = TRUE),
    safe_reverse_3pt(se10d),
    NA_real_  # Validation failed!
  )),

  # se9d: se9d Are you currently seeking employment?
  # Keyword validation: 'seeking'
  mutate(se9d_reversed = if_else(
    grepl("seeking", question_text["se9d"], ignore.case = TRUE),
    safe_reverse_3pt(se9d),
    NA_real_  # Validation failed!
  )),

  # ir4: ir4 Has the respondent ever refused to be interviewed during...
  # Keyword validation: 'refused'
  mutate(ir4_reversed = if_else(
    grepl("refused", question_text["ir4"], ignore.case = TRUE),
    safe_reverse_4pt(ir4),
    NA_real_  # Validation failed!
  )),

  # q10: What do you think the economic situation of your family will...
  # Keyword validation: 'parties'
  mutate(q10_reversed = if_else(
    grepl("parties", question_text["q10"], ignore.case = TRUE),
    safe_reverse_4pt(q10),
    NA_real_  # Validation failed!
  )),

  # q11: What do you think the economic situation of your family will...
  # Keyword validation: 'parliament'
  mutate(q11_reversed = if_else(
    grepl("parliament", question_text["q11"], ignore.case = TRUE),
    safe_reverse_4pt(q11),
    NA_real_  # Validation failed!
  )),

  # q110: 110 Do officials who commit crimes go unpunished?
  # Keyword validation: 'commit'
  mutate(q110_reversed = if_else(
    grepl("commit", question_text["q110"], ignore.case = TRUE),
    safe_reverse_4pt(q110),
    NA_real_  # Validation failed!
  )),

  # q111: 111 How often do government officials withhold important inf...
  # Keyword validation: 'withhold'
  mutate(q111_reversed = if_else(
    grepl("withhold", question_text["q111"], ignore.case = TRUE),
    safe_reverse_4pt(q111),
    NA_real_  # Validation failed!
  )),

  # q112: 112 How often do you think government leaders break the law ...
  # Keyword validation: 'abuse'
  mutate(q112_reversed = if_else(
    grepl("abuse", question_text["q112"], ignore.case = TRUE),
    safe_reverse_4pt(q112),
    NA_real_  # Validation failed!
  )),

  # q113: 113 How often do you think our elections offer the voters a ...
  # Keyword validation: 'offer'
  mutate(q113_reversed = if_else(
    grepl("offer", question_text["q113"], ignore.case = TRUE),
    safe_reverse_4pt(q113),
    NA_real_  # Validation failed!
  )),

  # q116: 116 How much do you feel that having elections makes the gov...
  # Keyword validation: 'having'
  mutate(q116_reversed = if_else(
    grepl("having", question_text["q116"], ignore.case = TRUE),
    safe_reverse_4pt(q116),
    NA_real_  # Validation failed!
  )),

  # q12: What do you think the economic situation of your family will...
  # Keyword validation: 'civil'
  mutate(q12_reversed = if_else(
    grepl("civil", question_text["q12"], ignore.case = TRUE),
    safe_reverse_4pt(q12),
    NA_real_  # Validation failed!
  )),

  # q13: What do you think the economic situation of your family will...
  # Keyword validation: 'military'
  mutate(q13_reversed = if_else(
    grepl("military", question_text["q13"], ignore.case = TRUE),
    safe_reverse_4pt(q13),
    NA_real_  # Validation failed!
  )),

  # q14: What do you think the economic situation of your family will...
  # Keyword validation: 'police'
  mutate(q14_reversed = if_else(
    grepl("police", question_text["q14"], ignore.case = TRUE),
    safe_reverse_4pt(q14),
    NA_real_  # Validation failed!
  )),

  # q15: What do you think the economic situation of your family will...
  # Keyword validation: 'local'
  mutate(q15_reversed = if_else(
    grepl("local", question_text["q15"], ignore.case = TRUE),
    safe_reverse_4pt(q15),
    NA_real_  # Validation failed!
  )),

  # q16: What do you think the economic situation of your family will...
  # Keyword validation: 'newspaper'
  mutate(q16_reversed = if_else(
    grepl("newspaper", question_text["q16"], ignore.case = TRUE),
    safe_reverse_4pt(q16),
    NA_real_  # Validation failed!
  )),

  # q17: What do you think the economic situation of your family will...
  # Keyword validation: 'television'
  mutate(q17_reversed = if_else(
    grepl("television", question_text["q17"], ignore.case = TRUE),
    safe_reverse_4pt(q17),
    NA_real_  # Validation failed!
  )),

  # q18: What do you think the economic situation of your family will...
  # Keyword validation: 'commission'
  mutate(q18_reversed = if_else(
    grepl("commission", question_text["q18"], ignore.case = TRUE),
    safe_reverse_4pt(q18),
    NA_real_  # Validation failed!
  )),

  # q19: What do you think the economic situation of your family will...
  # Keyword validation: 'organizations'
  mutate(q19_reversed = if_else(
    grepl("organizations", question_text["q19"], ignore.case = TRUE),
    safe_reverse_4pt(q19),
    NA_real_  # Validation failed!
  )),

  # q26: 26. How much do you trust your relatives?
  # Keyword validation: 'relatives'
  mutate(q26_reversed = if_else(
    grepl("relatives", question_text["q26"], ignore.case = TRUE),
    safe_reverse_4pt(q26),
    NA_real_  # Validation failed!
  )),

  # q27: 27. Trust your neighbors
  # Keyword validation: 'neighbors'
  mutate(q27_reversed = if_else(
    grepl("neighbors", question_text["q27"], ignore.case = TRUE),
    safe_reverse_4pt(q27),
    NA_real_  # Validation failed!
  )),

  # q28: 28. Trust other people you interact with
  # Keyword validation: 'interact'
  mutate(q28_reversed = if_else(
    grepl("interact", question_text["q28"], ignore.case = TRUE),
    safe_reverse_4pt(q28),
    NA_real_  # Validation failed!
  )),

  # q7: What do you think the economic situation of your family will...
  # Keyword validation: 'excutive'
  mutate(q7_reversed = if_else(
    grepl("excutive", question_text["q7"], ignore.case = TRUE),
    safe_reverse_4pt(q7),
    NA_real_  # Validation failed!
  )),

  # q8: What do you think the economic situation of your family will...
  # Keyword validation: 'courts'
  mutate(q8_reversed = if_else(
    grepl("courts", question_text["q8"], ignore.case = TRUE),
    safe_reverse_4pt(q8),
    NA_real_  # Validation failed!
  )),

  # q9: What do you think the economic situation of your family will...
  # Keyword validation: 'capital'
  mutate(q9_reversed = if_else(
    grepl("capital", question_text["q9"], ignore.case = TRUE),
    safe_reverse_4pt(q9),
    NA_real_  # Validation failed!
  )),

  # q1: 1. How would you rate the overll economic condition of our c...
  # Keyword validation: 'overll'
  mutate(q1_reversed = if_else(
    grepl("overll", question_text["q1"], ignore.case = TRUE),
    safe_reverse_5pt(q1),
    NA_real_  # Validation failed!
  )),

  # q4: 4. As for your own family, how do you rate the economic situ...
  # Keyword validation: 'today'
  mutate(q4_reversed = if_else(
    grepl("today", question_text["q4"], ignore.case = TRUE),
    safe_reverse_5pt(q4),
    NA_real_  # Validation failed!
  )),

  # q169: 169 General speaking, the influence China has on our country...
  # Keyword validation: 'speaking'
  mutate(q169_reversed = if_else(
    grepl("speaking", question_text["q169"], ignore.case = TRUE),
    safe_reverse_6pt(q169),
    NA_real_  # Validation failed!
  )),

  # q171: 171 General speaking, the influence the United States has on...
  # Keyword validation: 'speaking'
  mutate(q171_reversed = if_else(
    grepl("speaking", question_text["q171"], ignore.case = TRUE),
    safe_reverse_6pt(q171),
    NA_real_  # Validation failed!
  )),

  # se10: se10.  Are you the main earner in your household?
  # Keyword validation: 'earner'
  mutate(se10_reversed = if_else(
    grepl("earner", question_text["se10"], ignore.case = TRUE),
    safe_reverse_3pt(se10),
    NA_real_  # Validation failed!
  )),

  # ir12a: ir12a. Post-office
  # Keyword validation: 'ir12a'
  mutate(ir12a_reversed = if_else(
    grepl("ir12a", question_text["ir12a"], ignore.case = TRUE),
    safe_reverse_5pt(ir12a),
    NA_real_  # Validation failed!
  )),

  # ir12b: ir12b. School
  # Keyword validation: 'ir12b'
  mutate(ir12b_reversed = if_else(
    grepl("ir12b", question_text["ir12b"], ignore.case = TRUE),
    safe_reverse_5pt(ir12b),
    NA_real_  # Validation failed!
  )),

  # ir12c: ir12c. Police station
  # Keyword validation: 'ir12c'
  mutate(ir12c_reversed = if_else(
    grepl("ir12c", question_text["ir12c"], ignore.case = TRUE),
    safe_reverse_5pt(ir12c),
    NA_real_  # Validation failed!
  )),

  # ir12d: ir12d. Sewerage system that most houses could access
  # Keyword validation: 'ir12d'
  mutate(ir12d_reversed = if_else(
    grepl("ir12d", question_text["ir12d"], ignore.case = TRUE),
    safe_reverse_5pt(ir12d),
    NA_real_  # Validation failed!
  )),

  # ir12e: ir12e. Health clinic
  # Keyword validation: 'ir12e'
  mutate(ir12e_reversed = if_else(
    grepl("ir12e", question_text["ir12e"], ignore.case = TRUE),
    safe_reverse_5pt(ir12e),
    NA_real_  # Validation failed!
  )),

  # ir12f: ir12f. Signal for cellular phone
  # Keyword validation: 'ir12f'
  mutate(ir12f_reversed = if_else(
    grepl("ir12f", question_text["ir12f"], ignore.case = TRUE),
    safe_reverse_5pt(ir12f),
    NA_real_  # Validation failed!
  )),

  # ir12g: ir12g. Recreational facilities, e.g., a sports field
  # Keyword validation: 'ir12g'
  mutate(ir12g_reversed = if_else(
    grepl("ir12g", question_text["ir12g"], ignore.case = TRUE),
    safe_reverse_5pt(ir12g),
    NA_real_  # Validation failed!
  )),

  # ir12h: ir12h. Any churches, mosques, temples or other public places...
  # Keyword validation: 'ir12h'
  mutate(ir12h_reversed = if_else(
    grepl("ir12h", question_text["ir12h"], ignore.case = TRUE),
    safe_reverse_5pt(ir12h),
    NA_real_  # Validation failed!
  )),

  # ir12i: ir12i. Any town halls or community buildings that can be use...
  # Keyword validation: 'ir12i'
  mutate(ir12i_reversed = if_else(
    grepl("ir12i", question_text["ir12i"], ignore.case = TRUE),
    safe_reverse_5pt(ir12i),
    NA_real_  # Validation failed!
  )),

  # ir12j: ir12j. Market stalls (selling groceries and/or clothing)
  # Keyword validation: 'ir12j'
  mutate(ir12j_reversed = if_else(
    grepl("ir12j", question_text["ir12j"], ignore.case = TRUE),
    safe_reverse_5pt(ir12j),
    NA_real_  # Validation failed!
  ))

# ============================================================
# W4 Summary
