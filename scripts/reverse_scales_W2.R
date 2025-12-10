# ============================================================
# Asian Barometer W2 - Scale Reversal Script
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

# W2 Reversal Functions with Keyword Validation
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

# ============================================================
# W2 Variable Recodings with Validation
# ============================================================

w2 <- w2 %>%
  # ir3a_1: Spouse
  # Keyword validation: 'spouse'
  mutate(ir3a_1_reversed = if_else(
    grepl("spouse", question_text["ir3a_1"], ignore.case = TRUE),
    safe_reverse_2pt(ir3a_1),
    NA_real_  # Validation failed!
  )),

  # ir3a_2: Children
  # Keyword validation: 'children'
  mutate(ir3a_2_reversed = if_else(
    grepl("children", question_text["ir3a_2"], ignore.case = TRUE),
    safe_reverse_2pt(ir3a_2),
    NA_real_  # Validation failed!
  )),

  # ir3a_3: Parents or parents in law
  # Keyword validation: 'parents'
  mutate(ir3a_3_reversed = if_else(
    grepl("parents", question_text["ir3a_3"], ignore.case = TRUE),
    safe_reverse_2pt(ir3a_3),
    NA_real_  # Validation failed!
  )),

  # ir3a_4: Neighbors/Passers by
  # Keyword validation: 'passers'
  mutate(ir3a_4_reversed = if_else(
    grepl("passers", question_text["ir3a_4"], ignore.case = TRUE),
    safe_reverse_2pt(ir3a_4),
    NA_real_  # Validation failed!
  )),

  # ir3a_5: Party/Government Official
  # Keyword validation: 'party'
  mutate(ir3a_5_reversed = if_else(
    grepl("party", question_text["ir3a_5"], ignore.case = TRUE),
    safe_reverse_2pt(ir3a_5),
    NA_real_  # Validation failed!
  )),

  # ir3a_6: Others
  # Keyword validation: 'others'
  mutate(ir3a_6_reversed = if_else(
    grepl("others", question_text["ir3a_6"], ignore.case = TRUE),
    safe_reverse_2pt(ir3a_6),
    NA_real_  # Validation failed!
  )),

  # q119_1: Have you or anyone you know personally witnessed an act of c...
  # Keyword validation: '119_1'
  mutate(q119_1_reversed = if_else(
    grepl("119_1", question_text["q119_1"], ignore.case = TRUE),
    safe_reverse_2pt(q119_1),
    NA_real_  # Validation failed!
  )),

  # q119_2: Have you or anyone you know personally witnessed an act of c...
  # Keyword validation: '119_2'
  mutate(q119_2_reversed = if_else(
    grepl("119_2", question_text["q119_2"], ignore.case = TRUE),
    safe_reverse_2pt(q119_2),
    NA_real_  # Validation failed!
  )),

  # q119_3: Have you or anyone you know personally witnessed an act of c...
  # Keyword validation: '119_3'
  mutate(q119_3_reversed = if_else(
    grepl("119_3", question_text["q119_3"], ignore.case = TRUE),
    safe_reverse_2pt(q119_3),
    NA_real_  # Validation failed!
  )),

  # q156: Relation: The European Community or European Union
  # Keyword validation: 'union'
  mutate(q156_reversed = if_else(
    grepl("union", question_text["q156"], ignore.case = TRUE),
    safe_reverse_2pt(q156),
    NA_real_  # Validation failed!
  )),

  # q157: Relation: The United Nations or UN
  # Keyword validation: 'nations'
  mutate(q157_reversed = if_else(
    grepl("nations", question_text["q157"], ignore.case = TRUE),
    safe_reverse_2pt(q157),
    NA_real_  # Validation failed!
  )),

  # q158: Relation: International Monetary Fund or IMF
  # Keyword validation: 'monetary'
  mutate(q158_reversed = if_else(
    grepl("monetary", question_text["q158"], ignore.case = TRUE),
    safe_reverse_2pt(q158),
    NA_real_  # Validation failed!
  )),

  # q159: Relation: World Bank
  # Keyword validation: 'world'
  mutate(q159_reversed = if_else(
    grepl("world", question_text["q159"], ignore.case = TRUE),
    safe_reverse_2pt(q159),
    NA_real_  # Validation failed!
  )),

  # q20: Are you a member of any organization or formal groups?
  # Keyword validation: 'member'
  mutate(q20_reversed = if_else(
    grepl("member", question_text["q20"], ignore.case = TRUE),
    safe_reverse_2pt(q20),
    NA_real_  # Validation failed!
  )),

  # q51_1: On the whole, how would you rate the freeness and fairness o...
  # Keyword validation: 'information'
  mutate(q51_1_reversed = if_else(
    grepl("information", question_text["q51_1"], ignore.case = TRUE),
    safe_reverse_2pt(q51_1),
    NA_real_  # Validation failed!
  )),

  # q51_2: On the whole, how would you rate the freeness and fairness o...
  # Keyword validation: 'newspaper'
  mutate(q51_2_reversed = if_else(
    grepl("newspaper", question_text["q51_2"], ignore.case = TRUE),
    safe_reverse_2pt(q51_2),
    NA_real_  # Validation failed!
  )),

  # q51_3: On the whole, how would you rate the freeness and fairness o...
  # Keyword validation: 'radio'
  mutate(q51_3_reversed = if_else(
    grepl("radio", question_text["q51_3"], ignore.case = TRUE),
    safe_reverse_2pt(q51_3),
    NA_real_  # Validation failed!
  )),

  # q51_4: On the whole, how would you rate the freeness and fairness o...
  # Keyword validation: 'internet'
  mutate(q51_4_reversed = if_else(
    grepl("internet", question_text["q51_4"], ignore.case = TRUE),
    safe_reverse_2pt(q51_4),
    NA_real_  # Validation failed!
  )),

  # q51_5: On the whole, how would you rate the freeness and fairness o...
  # Keyword validation: 'short'
  mutate(q51_5_reversed = if_else(
    grepl("short", question_text["q51_5"], ignore.case = TRUE),
    safe_reverse_2pt(q51_5),
    NA_real_  # Validation failed!
  )),

  # q51_6: On the whole, how would you rate the freeness and fairness o...
  # Keyword validation: 'contact'
  mutate(q51_6_reversed = if_else(
    grepl("contact", question_text["q51_6"], ignore.case = TRUE),
    safe_reverse_2pt(q51_6),
    NA_real_  # Validation failed!
  )),

  # q51_7: On the whole, how would you rate the freeness and fairness o...
  # Keyword validation: 'other'
  mutate(q51_7_reversed = if_else(
    grepl("other", question_text["q51_7"], ignore.case = TRUE),
    safe_reverse_2pt(q51_7),
    NA_real_  # Validation failed!
  )),

  # q51_8: On the whole, how would you rate the freeness and fairness o...
  # Keyword validation: 'magazine'
  mutate(q51_8_reversed = if_else(
    grepl("magazine", question_text["q51_8"], ignore.case = TRUE),
    safe_reverse_2pt(q51_8),
    NA_real_  # Validation failed!
  )),

  # se10a: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'total'
  mutate(se10a_reversed = if_else(
    grepl("total", question_text["se10a"], ignore.case = TRUE),
    safe_reverse_2pt(se10a),
    NA_real_  # Validation failed!
  )),

  # se10b: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'tractor'
  mutate(se10b_reversed = if_else(
    grepl("tractor", question_text["se10b"], ignore.case = TRUE),
    safe_reverse_2pt(se10b),
    NA_real_  # Validation failed!
  )),

  # se10c: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'color'
  mutate(se10c_reversed = if_else(
    grepl("color", question_text["se10c"], ignore.case = TRUE),
    safe_reverse_2pt(se10c),
    NA_real_  # Validation failed!
  )),

  # se10d: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'cable'
  mutate(se10d_reversed = if_else(
    grepl("cable", question_text["se10d"], ignore.case = TRUE),
    safe_reverse_2pt(se10d),
    NA_real_  # Validation failed!
  )),

  # se10e: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'scooter'
  mutate(se10e_reversed = if_else(
    grepl("scooter", question_text["se10e"], ignore.case = TRUE),
    safe_reverse_2pt(se10e),
    NA_real_  # Validation failed!
  )),

  # se10f: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'telephone'
  mutate(se10f_reversed = if_else(
    grepl("telephone", question_text["se10f"], ignore.case = TRUE),
    safe_reverse_2pt(se10f),
    NA_real_  # Validation failed!
  )),

  # se10g: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'mobile'
  mutate(se10g_reversed = if_else(
    grepl("mobile", question_text["se10g"], ignore.case = TRUE),
    safe_reverse_2pt(se10g),
    NA_real_  # Validation failed!
  )),

  # se10h: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'electric'
  mutate(se10h_reversed = if_else(
    grepl("electric", question_text["se10h"], ignore.case = TRUE),
    safe_reverse_2pt(se10h),
    NA_real_  # Validation failed!
  )),

  # se10i: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'bicycle'
  mutate(se10i_reversed = if_else(
    grepl("bicycle", question_text["se10i"], ignore.case = TRUE),
    safe_reverse_2pt(se10i),
    NA_real_  # Validation failed!
  )),

  # se10j: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'transistor'
  mutate(se10j_reversed = if_else(
    grepl("transistor", question_text["se10j"], ignore.case = TRUE),
    safe_reverse_2pt(se10j),
    NA_real_  # Validation failed!
  )),

  # se10k: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'pumping'
  mutate(se10k_reversed = if_else(
    grepl("pumping", question_text["se10k"], ignore.case = TRUE),
    safe_reverse_2pt(se10k),
    NA_real_  # Validation failed!
  )),

  # se10l: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'fridge'
  mutate(se10l_reversed = if_else(
    grepl("fridge", question_text["se10l"], ignore.case = TRUE),
    safe_reverse_2pt(se10l),
    NA_real_  # Validation failed!
  )),

  # se10m: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'camera'
  mutate(se10m_reversed = if_else(
    grepl("camera", question_text["se10m"], ignore.case = TRUE),
    safe_reverse_2pt(se10m),
    NA_real_  # Validation failed!
  )),

  # se10n: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'goats'
  mutate(se10n_reversed = if_else(
    grepl("goats", question_text["se10n"], ignore.case = TRUE),
    safe_reverse_2pt(se10n),
    NA_real_  # Validation failed!
  )),

  # se10o: Does the total income of your household allow you to satisfa...
  # Keyword validation: 'buffalo'
  mutate(se10o_reversed = if_else(
    grepl("buffalo", question_text["se10o"], ignore.case = TRUE),
    safe_reverse_2pt(se10o),
    NA_real_  # Validation failed!
  )),

  # se12b: Respondent is also the chief wage earner?
  # Keyword validation: 'chief'
  mutate(se12b_reversed = if_else(
    grepl("chief", question_text["se12b"], ignore.case = TRUE),
    safe_reverse_2pt(se12b),
    NA_real_  # Validation failed!
  )),

  # ir13a: How far is it between the nearest public transportation stop...
  # Keyword validation: 'office'
  mutate(ir13a_reversed = if_else(
    grepl("office", question_text["ir13a"], ignore.case = TRUE),
    safe_reverse_2pt(ir13a),
    NA_real_  # Validation failed!
  )),

  # ir13b: How far is it between the nearest public transportation stop...
  # Keyword validation: 'school'
  mutate(ir13b_reversed = if_else(
    grepl("school", question_text["ir13b"], ignore.case = TRUE),
    safe_reverse_2pt(ir13b),
    NA_real_  # Validation failed!
  )),

  # ir13d: How far is it between the nearest public transportation stop...
  # Keyword validation: 'sewerage'
  mutate(ir13d_reversed = if_else(
    grepl("sewerage", question_text["ir13d"], ignore.case = TRUE),
    safe_reverse_2pt(ir13d),
    NA_real_  # Validation failed!
  )),

  # ir13e: How far is it between the nearest public transportation stop...
  # Keyword validation: 'health'
  mutate(ir13e_reversed = if_else(
    grepl("health", question_text["ir13e"], ignore.case = TRUE),
    safe_reverse_2pt(ir13e),
    NA_real_  # Validation failed!
  )),

  # ir13f: How far is it between the nearest public transportation stop...
  # Keyword validation: 'signal'
  mutate(ir13f_reversed = if_else(
    grepl("signal", question_text["ir13f"], ignore.case = TRUE),
    safe_reverse_2pt(ir13f),
    NA_real_  # Validation failed!
  )),

  # ir13g: How far is it between the nearest public transportation stop...
  # Keyword validation: 'recreational'
  mutate(ir13g_reversed = if_else(
    grepl("recreational", question_text["ir13g"], ignore.case = TRUE),
    safe_reverse_2pt(ir13g),
    NA_real_  # Validation failed!
  )),

  # ir13h: How far is it between the nearest public transportation stop...
  # Keyword validation: 'churches'
  mutate(ir13h_reversed = if_else(
    grepl("churches", question_text["ir13h"], ignore.case = TRUE),
    safe_reverse_2pt(ir13h),
    NA_real_  # Validation failed!
  )),

  # ir13i: How far is it between the nearest public transportation stop...
  # Keyword validation: 'halls'
  mutate(ir13i_reversed = if_else(
    grepl("halls", question_text["ir13i"], ignore.case = TRUE),
    safe_reverse_2pt(ir13i),
    NA_real_  # Validation failed!
  )),

  # ir13k: How far is it between the nearest public transportation stop...
  # Keyword validation: 'market'
  mutate(ir13k_reversed = if_else(
    grepl("market", question_text["ir13k"], ignore.case = TRUE),
    safe_reverse_2pt(ir13k),
    NA_real_  # Validation failed!
  )),

  # irII13c: How far is it between the nearest public transportation stop...
  # Keyword validation: 'station'
  mutate(irII13c_reversed = if_else(
    grepl("station", question_text["irII13c"], ignore.case = TRUE),
    safe_reverse_2pt(irII13c),
    NA_real_  # Validation failed!
  )),

  # q52: When you get together with your family members or friends, h...
  # Keyword validation: 'discuss'
  mutate(q52_reversed = if_else(
    grepl("discuss", question_text["q52"], ignore.case = TRUE),
    safe_reverse_3pt(q52),
    NA_real_  # Validation failed!
  )),

  # q112: How often do government officials withhold important informa...
  # Keyword validation: 'withhold'
  mutate(q112_reversed = if_else(
    grepl("withhold", question_text["q112"], ignore.case = TRUE),
    safe_reverse_4pt(q112),
    NA_real_  # Validation failed!
  )),

  # q113: How often do national government officials abide by the law?...
  # Keyword validation: 'abide'
  mutate(q113_reversed = if_else(
    grepl("abide", question_text["q113"], ignore.case = TRUE),
    safe_reverse_4pt(q113),
    NA_real_  # Validation failed!
  )),

  # q114: How often do your think our elections offer the voters a rea...
  # Keyword validation: 'offer'
  mutate(q114_reversed = if_else(
    grepl("offer", question_text["q114"], ignore.case = TRUE),
    safe_reverse_4pt(q114),
    NA_real_  # Validation failed!
  )),

  # q48: On the whole, how would you rate the freeness and fairness o...
  # Keyword validation: 'describe'
  mutate(q48_reversed = if_else(
    grepl("describe", question_text["q48"], ignore.case = TRUE),
    safe_reverse_5pt(q48),
    NA_real_  # Validation failed!
  )),

  # ir2: Is this the first questionnaire interviewers have completed?
  # Keyword validation: 'questionnaire'
  mutate(ir2_reversed = if_else(
    grepl("questionnaire", question_text["ir2"], ignore.case = TRUE),
    safe_reverse_3pt(ir2),
    NA_real_  # Validation failed!
  ))

# ============================================================
# W2 Summary
