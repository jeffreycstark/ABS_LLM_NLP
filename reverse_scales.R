# ============================================================
# Asian Barometer Multi-Wave Reversal Script
# Auto-generated with keyword validation
# ============================================================

# This script reverses scales where higher values indicate
# LESS of the attribute (e.g., 1=Satisfied, 4=Dissatisfied)
#
# Each recoding includes:
# 1. Scale-specific reversal function (4pt, 5pt, 6pt, etc.)
# 2. Keyword validation to ensure correct question
# 3. Missing value handling
# 4. Outlier detection
# ============================================================

# ============================================================
# W1 Reversal Functions with Keyword Validation
# Generated automatically from scale analysis
# ============================================================

library(dplyr)


safe_reverse_2pt <- function(x, missing_codes = c(99)) {
  dplyr::case_when(
    x %in% 1:2 ~ 3 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_4pt <- function(x, missing_codes = c(99)) {
  dplyr::case_when(
    x %in% 1:4 ~ 5 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_5pt <- function(x, missing_codes = c(98, 99)) {
  dplyr::case_when(
    x %in% 1:5 ~ 6 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_3pt <- function(x, missing_codes = c(9, 98, 99)) {
  dplyr::case_when(
    x %in% 1:9 ~ 10 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

# ============================================================
# W1 Variable Recodings with Validation
# ============================================================

tog

  # ir009: Was the interview conducted with the assisance of an interpr...
  # Keyword validation: 'conducted'
  mutate(ir009_reversed = if_else(
    grepl("conducted", question_text["ir009"], ignore.case = TRUE),
    safe_reverse_2pt(ir009),
    NA_real_  # Validation failed!
  )),

  # ir010c: Tell us whetherthe interviewee's residence has public water ...
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
# W2 Reversal Functions with Keyword Validation
# Generated automatically from scale analysis
# ============================================================

library(dplyr)


safe_reverse_2pt <- function(x, missing_codes = c(0)) {
  dplyr::case_when(
    x %in% 1:2 ~ 3 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_3pt <- function(x, missing_codes = c(7, 8, 9)) {
  dplyr::case_when(
    x %in% 1:3 ~ 4 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_4pt <- function(x, missing_codes = c(7, 8, 9)) {
  dplyr::case_when(
    x %in% 1:4 ~ 5 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_5pt <- function(x, missing_codes = c(8, 9)) {
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
# Variables needing reversal: 54
# ============================================================


# ============================================================
# W3 Reversal Functions with Keyword Validation
# Generated automatically from scale analysis
# ============================================================

library(dplyr)


safe_reverse_2pt <- function(x, missing_codes = c(-1)) {
  dplyr::case_when(
    x %in% 1:2 ~ 3 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_3pt <- function(x, missing_codes = c(-1, 7, 8, 9)) {
  dplyr::case_when(
    x %in% 1:3 ~ 4 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_4pt <- function(x, missing_codes = c(-1, 9)) {
  dplyr::case_when(
    x %in% 1:4 ~ 5 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_5pt <- function(x, missing_codes = c(-1, 7, 8, 9)) {
  dplyr::case_when(
    x %in% 1:5 ~ 6 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_6pt <- function(x, missing_codes = c(-1, 0, 7, 8, 9)) {
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
# W4 Reversal Functions with Keyword Validation
# Generated automatically from scale analysis
# ============================================================

library(dplyr)


safe_reverse_2pt <- function(x, missing_codes = c(-1, 7, 8, 9)) {
  dplyr::case_when(
    x %in% 1:2 ~ 3 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_3pt <- function(x, missing_codes = c(-1)) {
  dplyr::case_when(
    x %in% 1:3 ~ 4 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_4pt <- function(x, missing_codes = c(-1)) {
  dplyr::case_when(
    x %in% 1:4 ~ 5 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_5pt <- function(x, missing_codes = c(-1, 7, 8, 9)) {
  dplyr::case_when(
    x %in% 1:5 ~ 6 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_6pt <- function(x, missing_codes = c(-1, 7, 8, 9)) {
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
# Variables needing reversal: 71
# ============================================================


# ============================================================
# W5 Reversal Functions with Keyword Validation
# Generated automatically from scale analysis
# ============================================================

library(dplyr)


safe_reverse_2pt <- function(x, missing_codes = c(-1)) {
  dplyr::case_when(
    x %in% 1:2 ~ 3 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_3pt <- function(x, missing_codes = c(-1, 0, 7, 9)) {
  dplyr::case_when(
    x %in% 1:3 ~ 4 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_4pt <- function(x, missing_codes = c(-1)) {
  dplyr::case_when(
    x %in% 1:4 ~ 5 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_5pt <- function(x, missing_codes = c(-1, 7, 8, 9)) {
  dplyr::case_when(
    x %in% 1:5 ~ 6 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_6pt <- function(x, missing_codes = c(-1, 7, 8, 9)) {
  dplyr::case_when(
    x %in% 1:6 ~ 7 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

# ============================================================
# W5 Variable Recodings with Validation
# ============================================================

w5 <- w5 %>%
  # IR10a: ir10a Was the interview conducted with the assistance of an ...
  # Keyword validation: 'ir10a'
  mutate(IR10a_reversed = if_else(
    grepl("ir10a", question_text["IR10a"], ignore.case = TRUE),
    safe_reverse_2pt(IR10a),
    NA_real_  # Validation failed!
  )),

  # IR11c: ir11c Is electricity the main source of lighting in the hous...
  # Keyword validation: 'ir11c'
  mutate(IR11c_reversed = if_else(
    grepl("ir11c", question_text["IR11c"], ignore.case = TRUE),
    safe_reverse_2pt(IR11c),
    NA_real_  # Validation failed!
  )),

  # IR11d: ir11d Is this neighborhood coverd by mobile phone network(si...
  # Keyword validation: 'ir11d'
  mutate(IR11d_reversed = if_else(
    grepl("ir11d", question_text["IR11d"], ignore.case = TRUE),
    safe_reverse_2pt(IR11d),
    NA_real_  # Validation failed!
  )),

  # IR3: ir3 In the interview, other than the respondent, were others...
  # Keyword validation: 'present'
  mutate(IR3_reversed = if_else(
    grepl("present", question_text["IR3"], ignore.case = TRUE),
    safe_reverse_2pt(IR3),
    NA_real_  # Validation failed!
  )),

  # Ir2: ir2 Is this the first questionnaire you have completed?
  # Keyword validation: 'questionnaire'
  mutate(Ir2_reversed = if_else(
    grepl("questionnaire", question_text["Ir2"], ignore.case = TRUE),
    safe_reverse_2pt(Ir2),
    NA_real_  # Validation failed!
  )),

  # SE15A: Se15a Do you or your fmaily own the following?Car/Jeep/Van
  # Keyword validation: 'se15a'
  mutate(SE15A_reversed = if_else(
    grepl("se15a", question_text["SE15A"], ignore.case = TRUE),
    safe_reverse_2pt(SE15A),
    NA_real_  # Validation failed!
  )),

  # SE15B: Se15b Tractor
  # Keyword validation: 'se15b'
  mutate(SE15B_reversed = if_else(
    grepl("se15b", question_text["SE15B"], ignore.case = TRUE),
    safe_reverse_2pt(SE15B),
    NA_real_  # Validation failed!
  )),

  # SE15C: Se15c Color or B/W Television
  # Keyword validation: 'se15c'
  mutate(SE15C_reversed = if_else(
    grepl("se15c", question_text["SE15C"], ignore.case = TRUE),
    safe_reverse_2pt(SE15C),
    NA_real_  # Validation failed!
  )),

  # SE15D: Se15d Cable Televsion
  # Keyword validation: 'se15d'
  mutate(SE15D_reversed = if_else(
    grepl("se15d", question_text["SE15D"], ignore.case = TRUE),
    safe_reverse_2pt(SE15D),
    NA_real_  # Validation failed!
  )),

  # SE15E: Se15e Scooter/Motorcycle/Moped
  # Keyword validation: 'se15e'
  mutate(SE15E_reversed = if_else(
    grepl("se15e", question_text["SE15E"], ignore.case = TRUE),
    safe_reverse_2pt(SE15E),
    NA_real_  # Validation failed!
  )),

  # SE15F: Se15f Telephone
  # Keyword validation: 'se15f'
  mutate(SE15F_reversed = if_else(
    grepl("se15f", question_text["SE15F"], ignore.case = TRUE),
    safe_reverse_2pt(SE15F),
    NA_real_  # Validation failed!
  )),

  # SE15G: Se15g Mobile Telephone
  # Keyword validation: 'se15g'
  mutate(SE15G_reversed = if_else(
    grepl("se15g", question_text["SE15G"], ignore.case = TRUE),
    safe_reverse_2pt(SE15G),
    NA_real_  # Validation failed!
  )),

  # SE15H: Se15h Electric fan/cooler
  # Keyword validation: 'se15h'
  mutate(SE15H_reversed = if_else(
    grepl("se15h", question_text["SE15H"], ignore.case = TRUE),
    safe_reverse_2pt(SE15H),
    NA_real_  # Validation failed!
  )),

  # SE15I: Se15i Bicycle
  # Keyword validation: 'se15i'
  mutate(SE15I_reversed = if_else(
    grepl("se15i", question_text["SE15I"], ignore.case = TRUE),
    safe_reverse_2pt(SE15I),
    NA_real_  # Validation failed!
  )),

  # SE15J: Se15j Radio/transistor
  # Keyword validation: 'se15j'
  mutate(SE15J_reversed = if_else(
    grepl("se15j", question_text["SE15J"], ignore.case = TRUE),
    safe_reverse_2pt(SE15J),
    NA_real_  # Validation failed!
  )),

  # SE15K: Se15k Pumping set
  # Keyword validation: 'se15k'
  mutate(SE15K_reversed = if_else(
    grepl("se15k", question_text["SE15K"], ignore.case = TRUE),
    safe_reverse_2pt(SE15K),
    NA_real_  # Validation failed!
  )),

  # SE15L: Se15l Fridge
  # Keyword validation: 'se15l'
  mutate(SE15L_reversed = if_else(
    grepl("se15l", question_text["SE15L"], ignore.case = TRUE),
    safe_reverse_2pt(SE15L),
    NA_real_  # Validation failed!
  )),

  # SE15M: Se15m Camera
  # Keyword validation: 'se15m'
  mutate(SE15M_reversed = if_else(
    grepl("se15m", question_text["SE15M"], ignore.case = TRUE),
    safe_reverse_2pt(SE15M),
    NA_real_  # Validation failed!
  )),

  # SE15N: Se15n Goats/Sheep
  # Keyword validation: 'se15n'
  mutate(SE15N_reversed = if_else(
    grepl("se15n", question_text["SE15N"], ignore.case = TRUE),
    safe_reverse_2pt(SE15N),
    NA_real_  # Validation failed!
  )),

  # SE15O: Se15o Cows/Buffalo
  # Keyword validation: 'se15o'
  mutate(SE15O_reversed = if_else(
    grepl("se15o", question_text["SE15O"], ignore.case = TRUE),
    safe_reverse_2pt(SE15O),
    NA_real_  # Validation failed!
  )),

  # q127: 127 Have you or anyone you know personally witnessed an act ...
  # Keyword validation: 'anyone'
  mutate(q127_reversed = if_else(
    grepl("anyone", question_text["q127"], ignore.case = TRUE),
    safe_reverse_2pt(q127),
    NA_real_  # Validation failed!
  )),

  # q127a_1: 127a_1 Did you personally witness it or were you told about ...
  # Keyword validation: '127a_1'
  mutate(q127a_1_reversed = if_else(
    grepl("127a_1", question_text["q127a_1"], ignore.case = TRUE),
    safe_reverse_2pt(q127a_1),
    NA_real_  # Validation failed!
  )),

  # q127a_2: 127a_2  Did you personally witness it or were you told about...
  # Keyword validation: '127a_2'
  mutate(q127a_2_reversed = if_else(
    grepl("127a_2", question_text["q127a_2"], ignore.case = TRUE),
    safe_reverse_2pt(q127a_2),
    NA_real_  # Validation failed!
  )),

  # q127a_3: 127a_3  Did you personally witness it or were you told about...
  # Keyword validation: '127a_3'
  mutate(q127a_3_reversed = if_else(
    grepl("127a_3", question_text["q127a_3"], ignore.case = TRUE),
    safe_reverse_2pt(q127a_3),
    NA_real_  # Validation failed!
  )),

  # q157: 157 Which of the following statements do you agree with the ...
  # Keyword validation: 'limit'
  mutate(q157_reversed = if_else(
    grepl("limit", question_text["q157"], ignore.case = TRUE),
    safe_reverse_2pt(q157),
    NA_real_  # Validation failed!
  )),

  # q35: 35. Did you attend a campaign meeting or rally in the last n...
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

  # q50: 50 Do you currently use any of the following social media ne...
  # Keyword validation: 'facebook'
  mutate(q50_reversed = if_else(
    grepl("facebook", question_text["q50"], ignore.case = TRUE),
    safe_reverse_2pt(q50),
    NA_real_  # Validation failed!
  )),

  # q51a: 50 Do you currently use any of the following social media ne...
  # Keyword validation: 'connect'
  mutate(q51a_reversed = if_else(
    grepl("connect", question_text["q51a"], ignore.case = TRUE),
    safe_reverse_2pt(q51a),
    NA_real_  # Validation failed!
  )),

  # q51b: 50 Do you currently use any of the following social media ne...
  # Keyword validation: 'expresss'
  mutate(q51b_reversed = if_else(
    grepl("expresss", question_text["q51b"], ignore.case = TRUE),
    safe_reverse_2pt(q51b),
    NA_real_  # Validation failed!
  )),

  # q51c: 50 Do you currently use any of the following social media ne...
  # Keyword validation: 'share'
  mutate(q51c_reversed = if_else(
    grepl("share", question_text["q51c"], ignore.case = TRUE),
    safe_reverse_2pt(q51c),
    NA_real_  # Validation failed!
  )),

  # q51d: 50 Do you currently use any of the following social media ne...
  # Keyword validation: 'primarily'
  mutate(q51d_reversed = if_else(
    grepl("primarily", question_text["q51d"], ignore.case = TRUE),
    safe_reverse_2pt(q51d),
    NA_real_  # Validation failed!
  )),

  # SE10D: se10d Is he or she currently seeking employment?
  # Keyword validation: 'se10d'
  mutate(SE10D_reversed = if_else(
    grepl("se10d", question_text["SE10D"], ignore.case = TRUE),
    safe_reverse_3pt(SE10D),
    NA_real_  # Validation failed!
  )),

  # SE9D: se9d Are you currently seeking employment?
  # Keyword validation: 'seeking'
  mutate(SE9D_reversed = if_else(
    grepl("seeking", question_text["SE9D"], ignore.case = TRUE),
    safe_reverse_3pt(SE9D),
    NA_real_  # Validation failed!
  )),

  # q132: 132 Which of the following statements comes closest to your ...
  # Keyword validation: 'comes'
  mutate(q132_reversed = if_else(
    grepl("comes", question_text["q132"], ignore.case = TRUE),
    safe_reverse_3pt(q132),
    NA_real_  # Validation failed!
  )),

  # q22: 22 Would you say that "Most people can be trusted" or "that ...
  # Keyword validation: 'trusted'
  mutate(q22_reversed = if_else(
    grepl("trusted", question_text["q22"], ignore.case = TRUE),
    safe_reverse_3pt(q22),
    NA_real_  # Validation failed!
  )),

  # q33: 33 Did you vote in the last national election?
  # Keyword validation: 'national'
  mutate(q33_reversed = if_else(
    grepl("national", question_text["q33"], ignore.case = TRUE),
    safe_reverse_3pt(q33),
    NA_real_  # Validation failed!
  )),

  # q48: 48 When you get together with your family members or friends...
  # Keyword validation: 'discuss'
  mutate(q48_reversed = if_else(
    grepl("discuss", question_text["q48"], ignore.case = TRUE),
    safe_reverse_3pt(q48),
    NA_real_  # Validation failed!
  )),

  # IR4: ir4 Has the respondent ever refused to be interviewed during...
  # Keyword validation: 'refused'
  mutate(IR4_reversed = if_else(
    grepl("refused", question_text["IR4"], ignore.case = TRUE),
    safe_reverse_4pt(IR4),
    NA_real_  # Validation failed!
  )),

  # q122: 122 How much do you feel that having elections makes the gov...
  # Keyword validation: 'having'
  mutate(q122_reversed = if_else(
    grepl("having", question_text["q122"], ignore.case = TRUE),
    safe_reverse_4pt(q122),
    NA_real_  # Validation failed!
  )),

  # q1: 1. How would you rate the overall economic condition of our ...
  # Keyword validation: 'overall'
  mutate(q1_reversed = if_else(
    grepl("overall", question_text["q1"], ignore.case = TRUE),
    safe_reverse_5pt(q1),
    NA_real_  # Validation failed!
  )),

  # q117: 117 How often do government officials withhold important inf...
  # Keyword validation: 'withhold'
  mutate(q117_reversed = if_else(
    grepl("withhold", question_text["q117"], ignore.case = TRUE),
    safe_reverse_5pt(q117),
    NA_real_  # Validation failed!
  )),

  # q118: 118 How often do you think government leaders break the law ...
  # Keyword validation: 'break'
  mutate(q118_reversed = if_else(
    grepl("break", question_text["q118"], ignore.case = TRUE),
    safe_reverse_5pt(q118),
    NA_real_  # Validation failed!
  )),

  # q119: 119 How often do you think our elections offer the voters a ...
  # Keyword validation: 'offer'
  mutate(q119_reversed = if_else(
    grepl("offer", question_text["q119"], ignore.case = TRUE),
    safe_reverse_5pt(q119),
    NA_real_  # Validation failed!
  )),

  # q39: 39 How easy or difficult to obtain roads in good condition
  # Keyword validation: 'roads'
  mutate(q39_reversed = if_else(
    grepl("roads", question_text["q39"], ignore.case = TRUE),
    safe_reverse_5pt(q39),
    NA_real_  # Validation failed!
  )),

  # q4: 4. As for your own family, how do you rate the economic situ...
  # Keyword validation: 'today'
  mutate(q4_reversed = if_else(
    grepl("today", question_text["q4"], ignore.case = TRUE),
    safe_reverse_5pt(q4),
    NA_real_  # Validation failed!
  )),

  # q40: 40 How easy or difficult to obtain running water
  # Keyword validation: 'running'
  mutate(q40_reversed = if_else(
    grepl("running", question_text["q40"], ignore.case = TRUE),
    safe_reverse_5pt(q40),
    NA_real_  # Validation failed!
  )),

  # q41: 41 How easy or difficult to obtain public transportation
  # Keyword validation: 'transportation'
  mutate(q41_reversed = if_else(
    grepl("transportation", question_text["q41"], ignore.case = TRUE),
    safe_reverse_5pt(q41),
    NA_real_  # Validation failed!
  )),

  # q42: 42 How easy or difficult to obtain healthcare
  # Keyword validation: 'healthcare'
  mutate(q42_reversed = if_else(
    grepl("healthcare", question_text["q42"], ignore.case = TRUE),
    safe_reverse_5pt(q42),
    NA_real_  # Validation failed!
  )),

  # q43: 43 How easy or difficult to obtain help from the pollice whe...
  # Keyword validation: 'pollice'
  mutate(q43_reversed = if_else(
    grepl("pollice", question_text["q43"], ignore.case = TRUE),
    safe_reverse_5pt(q43),
    NA_real_  # Validation failed!
  )),

  # q44: 44 How easy or difficult to obtain access to the internet
  # Keyword validation: 'access'
  mutate(q44_reversed = if_else(
    grepl("access", question_text["q44"], ignore.case = TRUE),
    safe_reverse_5pt(q44),
    NA_real_  # Validation failed!
  )),

  # q182: 182 General speaking, the influence China has on our country...
  # Keyword validation: 'general'
  mutate(q182_reversed = if_else(
    grepl("general", question_text["q182"], ignore.case = TRUE),
    safe_reverse_6pt(q182),
    NA_real_  # Validation failed!
  )),

  # q184: 184 General speaking, the influence the United States has on...
  # Keyword validation: 'general'
  mutate(q184_reversed = if_else(
    grepl("general", question_text["q184"], ignore.case = TRUE),
    safe_reverse_6pt(q184),
    NA_real_  # Validation failed!
  )),

  # q91: 90 Would you say our system of government works fine as it i...
  # Keyword validation: 'protects'
  mutate(q91_reversed = if_else(
    grepl("protects", question_text["q91"], ignore.case = TRUE),
    safe_reverse_6pt(q91),
    NA_real_  # Validation failed!
  )),

  # q92: 90 Would you say our system of government works fine as it i...
  # Keyword validation: 'clean'
  mutate(q92_reversed = if_else(
    grepl("clean", question_text["q92"], ignore.case = TRUE),
    safe_reverse_6pt(q92),
    NA_real_  # Validation failed!
  )),

  # q93: 90 Would you say our system of government works fine as it i...
  # Keyword validation: 'protests'
  mutate(q93_reversed = if_else(
    grepl("protests", question_text["q93"], ignore.case = TRUE),
    safe_reverse_6pt(q93),
    NA_real_  # Validation failed!
  )),

  # q94: 90 Would you say our system of government works fine as it i...
  # Keyword validation: 'making'
  mutate(q94_reversed = if_else(
    grepl("making", question_text["q94"], ignore.case = TRUE),
    safe_reverse_6pt(q94),
    NA_real_  # Validation failed!
  )),

  # q95: 95 Political leaders rule by following their own wisdom rath...
  # Keyword validation: 'wisdom'
  mutate(q95_reversed = if_else(
    grepl("wisdom", question_text["q95"], ignore.case = TRUE),
    safe_reverse_6pt(q95),
    NA_real_  # Validation failed!
  )),

  # q96: 96 Rule by one party that represents the interests of all cl...
  # Keyword validation: 'represents'
  mutate(q96_reversed = if_else(
    grepl("represents", question_text["q96"], ignore.case = TRUE),
    safe_reverse_6pt(q96),
    NA_real_  # Validation failed!
  )),

  # q97: 97 Qualified candidates are pre-selected by religious leader...
  # Keyword validation: 'qualified'
  mutate(q97_reversed = if_else(
    grepl("qualified", question_text["q97"], ignore.case = TRUE),
    safe_reverse_6pt(q97),
    NA_real_  # Validation failed!
  )),

  # SE10: se10 Are you the main earner in your household?
  # Keyword validation: 'earner'
  mutate(SE10_reversed = if_else(
    grepl("earner", question_text["SE10"], ignore.case = TRUE),
    safe_reverse_3pt(SE10),
    NA_real_  # Validation failed!
  ))

# ============================================================
# W5 Summary
# Variables needing reversal: 62
# ============================================================


# ============================================================
# W6_Cambodia Reversal Functions with Keyword Validation
# Generated automatically from scale analysis
# ============================================================

library(dplyr)


safe_reverse_2pt <- function(x, missing_codes = c(-1, 0)) {
  dplyr::case_when(
    x %in% 1:2 ~ 3 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_3pt <- function(x, missing_codes = c(-1, 0)) {
  dplyr::case_when(
    x %in% 1:3 ~ 4 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_4pt <- function(x, missing_codes = c(-1, 0)) {
  dplyr::case_when(
    x %in% 1:4 ~ 5 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_5pt <- function(x, missing_codes = c(7, 8, 9)) {
  dplyr::case_when(
    x %in% 1:5 ~ 6 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

safe_reverse_6pt <- function(x, missing_codes = c(-1, 0, 7, 8, 9)) {
  dplyr::case_when(
    x %in% 1:6 ~ 7 - x,
    x %in% missing_codes ~ NA_real_,
    TRUE ~ NA_real_  # Outliers
  )
}

# ============================================================
# W6_Cambodia Variable Recodings with Validation
# ============================================================

w6_cambodia <- w6_cambodia %>%
  # IR10a: IR10a Was the interview conducted with the assistance of an ...
  # Keyword validation: 'ir10a'
  mutate(IR10a_reversed = if_else(
    grepl("ir10a", question_text["IR10a"], ignore.case = TRUE),
    safe_reverse_2pt(IR10a),
    NA_real_  # Validation failed!
  )),

  # IR11c: IR11c Is electricity the main source of lighting in the hous...
  # Keyword validation: 'ir11c'
  mutate(IR11c_reversed = if_else(
    grepl("ir11c", question_text["IR11c"], ignore.case = TRUE),
    safe_reverse_2pt(IR11c),
    NA_real_  # Validation failed!
  )),

  # IR2: IR2 Is this the first questionnaire you have completed?
  # Keyword validation: 'questionnaire'
  mutate(IR2_reversed = if_else(
    grepl("questionnaire", question_text["IR2"], ignore.case = TRUE),
    safe_reverse_2pt(IR2),
    NA_real_  # Validation failed!
  )),

  # IR2c_other: IR2c_other 

Variable: IR3 
  Question: IR3 In the interview...
  # Keyword validation: 'ir2c_other'
  mutate(IR2c_other_reversed = if_else(
    grepl("ir2c_other", question_text["IR2c_other"], ignore.case = TRUE),
    safe_reverse_2pt(IR2c_other),
    NA_real_  # Validation failed!
  )),

  # IR3a_1: IR2c_other 

Variable: IR3 
  Question: IR3 In the interview...
  # Keyword validation: 'ir3a_1'
  mutate(IR3a_1_reversed = if_else(
    grepl("ir3a_1", question_text["IR3a_1"], ignore.case = TRUE),
    safe_reverse_2pt(IR3a_1),
    NA_real_  # Validation failed!
  )),

  # IR3a_2: IR2c_other 

Variable: IR3 
  Question: IR3 In the interview...
  # Keyword validation: 'ir3a_2'
  mutate(IR3a_2_reversed = if_else(
    grepl("ir3a_2", question_text["IR3a_2"], ignore.case = TRUE),
    safe_reverse_2pt(IR3a_2),
    NA_real_  # Validation failed!
  )),

  # IR3a_3: IR2c_other 

Variable: IR3 
  Question: IR3 In the interview...
  # Keyword validation: 'ir3a_3'
  mutate(IR3a_3_reversed = if_else(
    grepl("ir3a_3", question_text["IR3a_3"], ignore.case = TRUE),
    safe_reverse_2pt(IR3a_3),
    NA_real_  # Validation failed!
  )),

  # IR3a_4: IR2c_other 

Variable: IR3 
  Question: IR3 In the interview...
  # Keyword validation: 'ir3a_4'
  mutate(IR3a_4_reversed = if_else(
    grepl("ir3a_4", question_text["IR3a_4"], ignore.case = TRUE),
    safe_reverse_2pt(IR3a_4),
    NA_real_  # Validation failed!
  )),

  # IR3a_5: IR2c_other 

Variable: IR3 
  Question: IR3 In the interview...
  # Keyword validation: 'ir3a_5'
  mutate(IR3a_5_reversed = if_else(
    grepl("ir3a_5", question_text["IR3a_5"], ignore.case = TRUE),
    safe_reverse_2pt(IR3a_5),
    NA_real_  # Validation failed!
  )),

  # IR3a_6_other: IR2c_other 

Variable: IR3 
  Question: IR3 In the interview...
  # Keyword validation: 'ir3a_6_other'
  mutate(IR3a_6_other_reversed = if_else(
    grepl("ir3a_6_other", question_text["IR3a_6_other"], ignore.case = TRUE),
    safe_reverse_2pt(IR3a_6_other),
    NA_real_  # Validation failed!
  )),

  # SE15a: SE15a Do you or your family own the following: Car/Jeep/Van?...
  # Keyword validation: 'se15a'
  mutate(SE15a_reversed = if_else(
    grepl("se15a", question_text["SE15a"], ignore.case = TRUE),
    safe_reverse_2pt(SE15a),
    NA_real_  # Validation failed!
  )),

  # SE15b: SE15b Tractor<optional>
  # Keyword validation: 'se15b'
  mutate(SE15b_reversed = if_else(
    grepl("se15b", question_text["SE15b"], ignore.case = TRUE),
    safe_reverse_2pt(SE15b),
    NA_real_  # Validation failed!
  )),

  # SE15c: SE15c Color or B/W Television (Non-Cable)<optional>
  # Keyword validation: 'se15c'
  mutate(SE15c_reversed = if_else(
    grepl("se15c", question_text["SE15c"], ignore.case = TRUE),
    safe_reverse_2pt(SE15c),
    NA_real_  # Validation failed!
  )),

  # SE15d: SE15d Cable Television<optional>
  # Keyword validation: 'se15d'
  mutate(SE15d_reversed = if_else(
    grepl("se15d", question_text["SE15d"], ignore.case = TRUE),
    safe_reverse_2pt(SE15d),
    NA_real_  # Validation failed!
  )),

  # SE15e: SE15e Scooter/Motorcycle/Moped<optional>
  # Keyword validation: 'se15e'
  mutate(SE15e_reversed = if_else(
    grepl("se15e", question_text["SE15e"], ignore.case = TRUE),
    safe_reverse_2pt(SE15e),
    NA_real_  # Validation failed!
  )),

  # SE15f: SE15f Telephone (Landline)<optional>
  # Keyword validation: 'se15f'
  mutate(SE15f_reversed = if_else(
    grepl("se15f", question_text["SE15f"], ignore.case = TRUE),
    safe_reverse_2pt(SE15f),
    NA_real_  # Validation failed!
  )),

  # SE15g: SE15g Mobile Telephone<optional>
  # Keyword validation: 'se15g'
  mutate(SE15g_reversed = if_else(
    grepl("se15g", question_text["SE15g"], ignore.case = TRUE),
    safe_reverse_2pt(SE15g),
    NA_real_  # Validation failed!
  )),

  # SE15h: SE15h Electric Fan/Cooler<optional>
  # Keyword validation: 'se15h'
  mutate(SE15h_reversed = if_else(
    grepl("se15h", question_text["SE15h"], ignore.case = TRUE),
    safe_reverse_2pt(SE15h),
    NA_real_  # Validation failed!
  )),

  # SE15i: SE15i Bicycle<optional>
  # Keyword validation: 'se15i'
  mutate(SE15i_reversed = if_else(
    grepl("se15i", question_text["SE15i"], ignore.case = TRUE),
    safe_reverse_2pt(SE15i),
    NA_real_  # Validation failed!
  )),

  # SE15j: SE15j Radio/Transistor<optional>
  # Keyword validation: 'se15j'
  mutate(SE15j_reversed = if_else(
    grepl("se15j", question_text["SE15j"], ignore.case = TRUE),
    safe_reverse_2pt(SE15j),
    NA_real_  # Validation failed!
  )),

  # SE15k: SE15k Pumping Set<optional>
  # Keyword validation: 'se15k'
  mutate(SE15k_reversed = if_else(
    grepl("se15k", question_text["SE15k"], ignore.case = TRUE),
    safe_reverse_2pt(SE15k),
    NA_real_  # Validation failed!
  )),

  # SE15l: SE15l Fridge<optional>
  # Keyword validation: 'se15l'
  mutate(SE15l_reversed = if_else(
    grepl("se15l", question_text["SE15l"], ignore.case = TRUE),
    safe_reverse_2pt(SE15l),
    NA_real_  # Validation failed!
  )),

  # SE15m: SE15m Camera<optional>
  # Keyword validation: 'se15m'
  mutate(SE15m_reversed = if_else(
    grepl("se15m", question_text["SE15m"], ignore.case = TRUE),
    safe_reverse_2pt(SE15m),
    NA_real_  # Validation failed!
  )),

  # SE15n: SE15n Goats/Sheep<optional>
  # Keyword validation: 'se15n'
  mutate(SE15n_reversed = if_else(
    grepl("se15n", question_text["SE15n"], ignore.case = TRUE),
    safe_reverse_2pt(SE15n),
    NA_real_  # Validation failed!
  )),

  # SE15o: SE15o Cows/Buffalo<optional>
  # Keyword validation: 'se15o'
  mutate(SE15o_reversed = if_else(
    grepl("se15o", question_text["SE15o"], ignore.case = TRUE),
    safe_reverse_2pt(SE15o),
    NA_real_  # Validation failed!
  )),

  # SE15p: SE15p Internet Connection at home<optional>
  # Keyword validation: 'se15p'
  mutate(SE15p_reversed = if_else(
    grepl("se15p", question_text["SE15p"], ignore.case = TRUE),
    safe_reverse_2pt(SE15p),
    NA_real_  # Validation failed!
  )),

  # SE15q: SE15q Boat<optional>
  # Keyword validation: 'se15q'
  mutate(SE15q_reversed = if_else(
    grepl("se15q", question_text["SE15q"], ignore.case = TRUE),
    safe_reverse_2pt(SE15q),
    NA_real_  # Validation failed!
  )),

  # SE9eother: SE9e. Other specify responses 

Variable: SE10 
  Question: ...
  # Keyword validation: 'earner'
  mutate(SE9eother_reversed = if_else(
    grepl("earner", question_text["SE9eother"], ignore.case = TRUE),
    safe_reverse_2pt(SE9eother),
    NA_real_  # Validation failed!
  )),

  # q118: 118 Have you or anyone you know personally witnessed an act ...
  # Keyword validation: 'anyone'
  mutate(q118_reversed = if_else(
    grepl("anyone", question_text["q118"], ignore.case = TRUE),
    safe_reverse_2pt(q118),
    NA_real_  # Validation failed!
  )),

  # q119a: 119a Did you personally witness it or were you told about it...
  # Keyword validation: 'witness'
  mutate(q119a_reversed = if_else(
    grepl("witness", question_text["q119a"], ignore.case = TRUE),
    safe_reverse_2pt(q119a),
    NA_real_  # Validation failed!
  )),

  # q119b: 119b Did you personally witness it or were you told about it...
  # Keyword validation: 'witness'
  mutate(q119b_reversed = if_else(
    grepl("witness", question_text["q119b"], ignore.case = TRUE),
    safe_reverse_2pt(q119b),
    NA_real_  # Validation failed!
  )),

  # q119c: 119c Did you personally witness it or were you told about it...
  # Keyword validation: 'witness'
  mutate(q119c_reversed = if_else(
    grepl("witness", question_text["q119c"], ignore.case = TRUE),
    safe_reverse_2pt(q119c),
    NA_real_  # Validation failed!
  )),

  # q138: 138 Have you or your family members previously contracted th...
  # Keyword validation: 'previously'
  mutate(q138_reversed = if_else(
    grepl("previously", question_text["q138"], ignore.case = TRUE),
    safe_reverse_2pt(q138),
    NA_real_  # Validation failed!
  )),

  # q139a: 139a Did you or a member of your family suffer from serious ...
  # Keyword validation: 'illness'
  mutate(q139a_reversed = if_else(
    grepl("illness", question_text["q139a"], ignore.case = TRUE),
    safe_reverse_2pt(q139a),
    NA_real_  # Validation failed!
  )),

  # q139b: 139b Did you or a member of your family suffer from loss of ...
  # Keyword validation: 'suffer'
  mutate(q139b_reversed = if_else(
    grepl("suffer", question_text["q139b"], ignore.case = TRUE),
    safe_reverse_2pt(q139b),
    NA_real_  # Validation failed!
  )),

  # q139c: 139c Did you or a member of your family suffer from loss of ...
  # Keyword validation: 'suffer'
  mutate(q139c_reversed = if_else(
    grepl("suffer", question_text["q139c"], ignore.case = TRUE),
    safe_reverse_2pt(q139c),
    NA_real_  # Validation failed!
  )),

  # q139d: 139d Did you or a member of your family suffer from disrupti...
  # Keyword validation: 'disruption'
  mutate(q139d_reversed = if_else(
    grepl("disruption", question_text["q139d"], ignore.case = TRUE),
    safe_reverse_2pt(q139d),
    NA_real_  # Validation failed!
  )),

  # q157: 157 Choose one statement.
  # Keyword validation: 'choose'
  mutate(q157_reversed = if_else(
    grepl("choose", question_text["q157"], ignore.case = TRUE),
    safe_reverse_2pt(q157),
    NA_real_  # Validation failed!
  )),

  # q21_other: 21 Other specify responses 

Variable: q22 
  Question: 22 W...
  # Keyword validation: 'trusted'
  mutate(q21_other_reversed = if_else(
    grepl("trusted", question_text["q21_other"], ignore.case = TRUE),
    safe_reverse_2pt(q21_other),
    NA_real_  # Validation failed!
  )),

  # q35: 35 Did you attend a campaign meeting or rally in the last na...
  # Keyword validation: 'attend'
  mutate(q35_reversed = if_else(
    grepl("attend", question_text["q35"], ignore.case = TRUE),
    safe_reverse_2pt(q35),
    NA_real_  # Validation failed!
  )),

  # q36: 36 Try to persuade others to vote for a certain candidate or...
  # Keyword validation: 'persuade'
  mutate(q36_reversed = if_else(
    grepl("persuade", question_text["q36"], ignore.case = TRUE),
    safe_reverse_2pt(q36),
    NA_real_  # Validation failed!
  )),

  # q37: 37 Did you do anything else to help out or work for a party ...
  # Keyword validation: 'anything'
  mutate(q37_reversed = if_else(
    grepl("anything", question_text["q37"], ignore.case = TRUE),
    safe_reverse_2pt(q37),
    NA_real_  # Validation failed!
  )),

  # q51a_Facebook: 51a Which social media and text messaging services do you ac...
  # Keyword validation: 'messaging'
  mutate(q51a_Facebook_reversed = if_else(
    grepl("messaging", question_text["q51a_Facebook"], ignore.case = TRUE),
    safe_reverse_2pt(q51a_Facebook),
    NA_real_  # Validation failed!
  )),

  # q51b_Twitter: 51b Twitter
  # Keyword validation: 'twitter'
  mutate(q51b_Twitter_reversed = if_else(
    grepl("twitter", question_text["q51b_Twitter"], ignore.case = TRUE),
    safe_reverse_2pt(q51b_Twitter),
    NA_real_  # Validation failed!
  )),

  # q51c_Instagram: 51c Instagram
  # Keyword validation: 'instagram'
  mutate(q51c_Instagram_reversed = if_else(
    grepl("instagram", question_text["q51c_Instagram"], ignore.case = TRUE),
    safe_reverse_2pt(q51c_Instagram),
    NA_real_  # Validation failed!
  )),

  # q51d_Youtube: 51d Youtube
  # Keyword validation: 'youtube'
  mutate(q51d_Youtube_reversed = if_else(
    grepl("youtube", question_text["q51d_Youtube"], ignore.case = TRUE),
    safe_reverse_2pt(q51d_Youtube),
    NA_real_  # Validation failed!
  )),

  # q51e_Tiktok: 51e Tiktok
  # Keyword validation: 'tiktok'
  mutate(q51e_Tiktok_reversed = if_else(
    grepl("tiktok", question_text["q51e_Tiktok"], ignore.case = TRUE),
    safe_reverse_2pt(q51e_Tiktok),
    NA_real_  # Validation failed!
  )),

  # q51f_Messenger: q51f Messenger
  # Keyword validation: 'messenger'
  mutate(q51f_Messenger_reversed = if_else(
    grepl("messenger", question_text["q51f_Messenger"], ignore.case = TRUE),
    safe_reverse_2pt(q51f_Messenger),
    NA_real_  # Validation failed!
  )),

  # q51g_Telegram: q51g Telegram
  # Keyword validation: 'telegram'
  mutate(q51g_Telegram_reversed = if_else(
    grepl("telegram", question_text["q51g_Telegram"], ignore.case = TRUE),
    safe_reverse_2pt(q51g_Telegram),
    NA_real_  # Validation failed!
  )),

  # q51h_Line: q51h Line
  # Keyword validation: 'q51h Line'
  mutate(q51h_Line_reversed = if_else(
    grepl("q51h Line", question_text["q51h_Line"], ignore.case = TRUE),
    safe_reverse_2pt(q51h_Line),
    NA_real_  # Validation failed!
  )),

  # q51i_Whatsapp: q51i Whatsapp
  # Keyword validation: 'whatsapp'
  mutate(q51i_Whatsapp_reversed = if_else(
    grepl("whatsapp", question_text["q51i_Whatsapp"], ignore.case = TRUE),
    safe_reverse_2pt(q51i_Whatsapp),
    NA_real_  # Validation failed!
  )),

  # q51j_Snapchat: q51j Snapchat
  # Keyword validation: 'snapchat'
  mutate(q51j_Snapchat_reversed = if_else(
    grepl("snapchat", question_text["q51j_Snapchat"], ignore.case = TRUE),
    safe_reverse_2pt(q51j_Snapchat),
    NA_real_  # Validation failed!
  )),

  # q51k_Vchat: q51k Vchat
  # Keyword validation: 'vchat'
  mutate(q51k_Vchat_reversed = if_else(
    grepl("vchat", question_text["q51k_Vchat"], ignore.case = TRUE),
    safe_reverse_2pt(q51k_Vchat),
    NA_real_  # Validation failed!
  )),

  # q51l_Tumblr: q51l Tumblr
  # Keyword validation: 'tumblr'
  mutate(q51l_Tumblr_reversed = if_else(
    grepl("tumblr", question_text["q51l_Tumblr"], ignore.case = TRUE),
    safe_reverse_2pt(q51l_Tumblr),
    NA_real_  # Validation failed!
  )),

  # IR11d: IR11d Is this neighborhood covered by mobile network?
  # Keyword validation: 'ir11d'
  mutate(IR11d_reversed = if_else(
    grepl("ir11d", question_text["IR11d"], ignore.case = TRUE),
    safe_reverse_3pt(IR11d),
    NA_real_  # Validation failed!
  )),

  # SE10d: SE10d Is he or she currently seeking employment?
  # Keyword validation: 'se10d'
  mutate(SE10d_reversed = if_else(
    grepl("se10d", question_text["SE10d"], ignore.case = TRUE),
    safe_reverse_3pt(SE10d),
    NA_real_  # Validation failed!
  )),

  # SE9d: SE9d Are you currently seeking employment?
  # Keyword validation: 'seeking'
  mutate(SE9d_reversed = if_else(
    grepl("seeking", question_text["SE9d"], ignore.case = TRUE),
    safe_reverse_3pt(SE9d),
    NA_real_  # Validation failed!
  )),

  # q124: 124 Which of the following statements comes closest to your ...
  # Keyword validation: 'comes'
  mutate(q124_reversed = if_else(
    grepl("comes", question_text["q124"], ignore.case = TRUE),
    safe_reverse_3pt(q124),
    NA_real_  # Validation failed!
  )),

  # q143a: 143aWhen there is a public health challenge like the coronav...
  # Keyword validation: '143awhen'
  mutate(q143a_reversed = if_else(
    grepl("143awhen", question_text["q143a"], ignore.case = TRUE),
    safe_reverse_3pt(q143a),
    NA_real_  # Validation failed!
  )),

  # q143b: 143aWhen there is a public health challenge like the coronav...
  # Keyword validation: 'limit'
  mutate(q143b_reversed = if_else(
    grepl("limit", question_text["q143b"], ignore.case = TRUE),
    safe_reverse_3pt(q143b),
    NA_real_  # Validation failed!
  )),

  # q143c: 143aWhen there is a public health challenge like the coronav...
  # Keyword validation: 'censor'
  mutate(q143c_reversed = if_else(
    grepl("censor", question_text["q143c"], ignore.case = TRUE),
    safe_reverse_3pt(q143c),
    NA_real_  # Validation failed!
  )),

  # q143d: 143aWhen there is a public health challenge like the coronav...
  # Keyword validation: 'track'
  mutate(q143d_reversed = if_else(
    grepl("track", question_text["q143d"], ignore.case = TRUE),
    safe_reverse_3pt(q143d),
    NA_real_  # Validation failed!
  )),

  # q143e: 143aWhen there is a public health challenge like the coronav...
  # Keyword validation: 'impose'
  mutate(q143e_reversed = if_else(
    grepl("impose", question_text["q143e"], ignore.case = TRUE),
    safe_reverse_3pt(q143e),
    NA_real_  # Validation failed!
  )),

  # q33: 33 Did you vote in the national election?
  # Keyword validation: 'national'
  mutate(q33_reversed = if_else(
    grepl("national", question_text["q33"], ignore.case = TRUE),
    safe_reverse_3pt(q33),
    NA_real_  # Validation failed!
  )),

  # q49: 49 When you get together with your family members or friends...
  # Keyword validation: 'discuss'
  mutate(q49_reversed = if_else(
    grepl("discuss", question_text["q49"], ignore.case = TRUE),
    safe_reverse_3pt(q49),
    NA_real_  # Validation failed!
  )),

  # q79: 79 In recent years and thinking about election campaigns, ha...
  # Keyword validation: 'recent'
  mutate(q79_reversed = if_else(
    grepl("recent", question_text["q79"], ignore.case = TRUE),
    safe_reverse_3pt(q79),
    NA_real_  # Validation failed!
  )),

  # IR3a_6_other_clarify: IR3a_other_clarify 

Variable: IR4 
  Question: IR4 Has the ...
  # Keyword validation: 'ir3a_other_clarify'
  mutate(IR3a_6_other_clarify_reversed = if_else(
    grepl("ir3a_other_clarify", question_text["IR3a_6_other_clarify"], ignore.case = TRUE),
    safe_reverse_4pt(IR3a_6_other_clarify),
    NA_real_  # Validation failed!
  )),

  # q10: 6 What do you think the economic situation of your family wi...
  # Keyword validation: 'specific'
  mutate(q10_reversed = if_else(
    grepl("specific", question_text["q10"], ignore.case = TRUE),
    safe_reverse_4pt(q10),
    NA_real_  # Validation failed!
  )),

  # q11: 6 What do you think the economic situation of your family wi...
  # Keyword validation: 'parliament'
  mutate(q11_reversed = if_else(
    grepl("parliament", question_text["q11"], ignore.case = TRUE),
    safe_reverse_4pt(q11),
    NA_real_  # Validation failed!
  )),

  # q110: 110 How often do you think our elections offer the voters a ...
  # Keyword validation: 'offer'
  mutate(q110_reversed = if_else(
    grepl("offer", question_text["q110"], ignore.case = TRUE),
    safe_reverse_4pt(q110),
    NA_real_  # Validation failed!
  )),

  # q113: 113 How much do you feel that having elections make the gove...
  # Keyword validation: 'having'
  mutate(q113_reversed = if_else(
    grepl("having", question_text["q113"], ignore.case = TRUE),
    safe_reverse_4pt(q113),
    NA_real_  # Validation failed!
  )),

  # q12: 6 What do you think the economic situation of your family wi...
  # Keyword validation: 'service'
  mutate(q12_reversed = if_else(
    grepl("service", question_text["q12"], ignore.case = TRUE),
    safe_reverse_4pt(q12),
    NA_real_  # Validation failed!
  )),

  # q13: 6 What do you think the economic situation of your family wi...
  # Keyword validation: 'armed'
  mutate(q13_reversed = if_else(
    grepl("armed", question_text["q13"], ignore.case = TRUE),
    safe_reverse_4pt(q13),
    NA_real_  # Validation failed!
  )),

  # q14: 6 What do you think the economic situation of your family wi...
  # Keyword validation: 'police'
  mutate(q14_reversed = if_else(
    grepl("police", question_text["q14"], ignore.case = TRUE),
    safe_reverse_4pt(q14),
    NA_real_  # Validation failed!
  )),

  # q15: 6 What do you think the economic situation of your family wi...
  # Keyword validation: 'local'
  mutate(q15_reversed = if_else(
    grepl("local", question_text["q15"], ignore.case = TRUE),
    safe_reverse_4pt(q15),
    NA_real_  # Validation failed!
  )),

  # q16: 6 What do you think the economic situation of your family wi...
  # Keyword validation: 'commission'
  mutate(q16_reversed = if_else(
    grepl("commission", question_text["q16"], ignore.case = TRUE),
    safe_reverse_4pt(q16),
    NA_real_  # Validation failed!
  )),

  # q17: 6 What do you think the economic situation of your family wi...
  # Keyword validation: 'organizations'
  mutate(q17_reversed = if_else(
    grepl("organizations", question_text["q17"], ignore.case = TRUE),
    safe_reverse_4pt(q17),
    NA_real_  # Validation failed!
  )),

  # q24: 24 How much trust do you have in each of the following types...
  # Keyword validation: 'relatives'
  mutate(q24_reversed = if_else(
    grepl("relatives", question_text["q24"], ignore.case = TRUE),
    safe_reverse_4pt(q24),
    NA_real_  # Validation failed!
  )),

  # q25: 24 How much trust do you have in each of the following types...
  # Keyword validation: 'neighbors'
  mutate(q25_reversed = if_else(
    grepl("neighbors", question_text["q25"], ignore.case = TRUE),
    safe_reverse_4pt(q25),
    NA_real_  # Validation failed!
  )),

  # q26: 24 How much trust do you have in each of the following types...
  # Keyword validation: 'interact'
  mutate(q26_reversed = if_else(
    grepl("interact", question_text["q26"], ignore.case = TRUE),
    safe_reverse_4pt(q26),
    NA_real_  # Validation failed!
  )),

  # q27: 24 How much trust do you have in each of the following types...
  # Keyword validation: 'first'
  mutate(q27_reversed = if_else(
    grepl("first", question_text["q27"], ignore.case = TRUE),
    safe_reverse_4pt(q27),
    NA_real_  # Validation failed!
  )),

  # q39: 39 How easy or difficult to obtain the roads in good conditi...
  # Keyword validation: 'roads'
  mutate(q39_reversed = if_else(
    grepl("roads", question_text["q39"], ignore.case = TRUE),
    safe_reverse_4pt(q39),
    NA_real_  # Validation failed!
  )),

  # q40: 40 How easy or difficult to obtain running water
  # Keyword validation: 'running'
  mutate(q40_reversed = if_else(
    grepl("running", question_text["q40"], ignore.case = TRUE),
    safe_reverse_4pt(q40),
    NA_real_  # Validation failed!
  )),

  # q41: 41 How easy or difficult to obtain public transportation
  # Keyword validation: 'transportation'
  mutate(q41_reversed = if_else(
    grepl("transportation", question_text["q41"], ignore.case = TRUE),
    safe_reverse_4pt(q41),
    NA_real_  # Validation failed!
  )),

  # q42: 42 How easy or difficult to obtain healthcare
  # Keyword validation: 'healthcare'
  mutate(q42_reversed = if_else(
    grepl("healthcare", question_text["q42"], ignore.case = TRUE),
    safe_reverse_4pt(q42),
    NA_real_  # Validation failed!
  )),

  # q43: 43 How easy or difficult to obtain help from the police when...
  # Keyword validation: 'police'
  mutate(q43_reversed = if_else(
    grepl("police", question_text["q43"], ignore.case = TRUE),
    safe_reverse_4pt(q43),
    NA_real_  # Validation failed!
  )),

  # q44: 44 How easy or difficult to obtain access to the Internet
  # Keyword validation: 'access'
  mutate(q44_reversed = if_else(
    grepl("access", question_text["q44"], ignore.case = TRUE),
    safe_reverse_4pt(q44),
    NA_real_  # Validation failed!
  )),

  # q45: 45 How easy or difficult to obtain childcare
  # Keyword validation: 'childcare'
  mutate(q45_reversed = if_else(
    grepl("childcare", question_text["q45"], ignore.case = TRUE),
    safe_reverse_4pt(q45),
    NA_real_  # Validation failed!
  )),

  # q52a: 52a How often do you use social media to talk to or to conne...
  # Keyword validation: 'connect'
  mutate(q52a_reversed = if_else(
    grepl("connect", question_text["q52a"], ignore.case = TRUE),
    safe_reverse_4pt(q52a),
    NA_real_  # Validation failed!
  )),

  # q52b: 52b How often do you use social media to express my opinion ...
  # Keyword validation: 'issues'
  mutate(q52b_reversed = if_else(
    grepl("issues", question_text["q52b"], ignore.case = TRUE),
    safe_reverse_4pt(q52b),
    NA_real_  # Validation failed!
  )),

  # q52c: 52c How often do you use social media to share news or infor...
  # Keyword validation: 'share'
  mutate(q52c_reversed = if_else(
    grepl("share", question_text["q52c"], ignore.case = TRUE),
    safe_reverse_4pt(q52c),
    NA_real_  # Validation failed!
  )),

  # q52d: 52d How often do you use social media to organize to influen...
  # Keyword validation: 'organize'
  mutate(q52d_reversed = if_else(
    grepl("organize", question_text["q52d"], ignore.case = TRUE),
    safe_reverse_4pt(q52d),
    NA_real_  # Validation failed!
  )),

  # q7: 6 What do you think the economic situation of your family wi...
  # Keyword validation: 'excutive'
  mutate(q7_reversed = if_else(
    grepl("excutive", question_text["q7"], ignore.case = TRUE),
    safe_reverse_4pt(q7),
    NA_real_  # Validation failed!
  )),

  # q8: 6 What do you think the economic situation of your family wi...
  # Keyword validation: 'courts'
  mutate(q8_reversed = if_else(
    grepl("courts", question_text["q8"], ignore.case = TRUE),
    safe_reverse_4pt(q8),
    NA_real_  # Validation failed!
  )),

  # q9: 6 What do you think the economic situation of your family wi...
  # Keyword validation: 'capital'
  mutate(q9_reversed = if_else(
    grepl("capital", question_text["q9"], ignore.case = TRUE),
    safe_reverse_4pt(q9),
    NA_real_  # Validation failed!
  )),

  # q1: 1 How would you rate the overall economic condition of our c...
  # Keyword validation: 'overall'
  mutate(q1_reversed = if_else(
    grepl("overall", question_text["q1"], ignore.case = TRUE),
    safe_reverse_5pt(q1),
    NA_real_  # Validation failed!
  )),

  # q108: 108 How often do government officials withhold important inf...
  # Keyword validation: 'withhold'
  mutate(q108_reversed = if_else(
    grepl("withhold", question_text["q108"], ignore.case = TRUE),
    safe_reverse_5pt(q108),
    NA_real_  # Validation failed!
  )),

  # q109: 109 How often do you think government leaders break the law ...
  # Keyword validation: 'abuse'
  mutate(q109_reversed = if_else(
    grepl("abuse", question_text["q109"], ignore.case = TRUE),
    safe_reverse_5pt(q109),
    NA_real_  # Validation failed!
  )),

  # q141: 141 How much do you trust the Covid-19 related information p...
  # Keyword validation: 'related'
  mutate(q141_reversed = if_else(
    grepl("related", question_text["q141"], ignore.case = TRUE),
    safe_reverse_5pt(q141),
    NA_real_  # Validation failed!
  )),

  # q144: 144 Have you been vaccinated against Covid-19?
  # Keyword validation: 'vaccinated'
  mutate(q144_reversed = if_else(
    grepl("vaccinated", question_text["q144"], ignore.case = TRUE),
    safe_reverse_5pt(q144),
    NA_real_  # Validation failed!
  )),

  # q4: 4 As for your own family, how do you rate the economic situa...
  # Keyword validation: 'today'
  mutate(q4_reversed = if_else(
    grepl("today", question_text["q4"], ignore.case = TRUE),
    safe_reverse_5pt(q4),
    NA_real_  # Validation failed!
  )),

  # q175: 175 Generally speaking, the influence the United States toda...
  # Keyword validation: 'united'
  mutate(q175_reversed = if_else(
    grepl("united", question_text["q175"], ignore.case = TRUE),
    safe_reverse_6pt(q175),
    NA_real_  # Validation failed!
  )),

  # q177: 177 Generally speaking, the influence China today has on wor...
  # Keyword validation: 'world'
  mutate(q177_reversed = if_else(
    grepl("world", question_text["q177"], ignore.case = TRUE),
    safe_reverse_6pt(q177),
    NA_real_  # Validation failed!
  )),

  # q178: 178 Generally speaking, the influence the E.U. today has on ...
  # Keyword validation: 'world'
  mutate(q178_reversed = if_else(
    grepl("world", question_text["q178"], ignore.case = TRUE),
    safe_reverse_6pt(q178),
    NA_real_  # Validation failed!
  )),

  # q182: 182 Generally speaking, the influence China has on our count...
  # Keyword validation: 'china'
  mutate(q182_reversed = if_else(
    grepl("china", question_text["q182"], ignore.case = TRUE),
    safe_reverse_6pt(q182),
    NA_real_  # Validation failed!
  )),

  # q184: 184 General speaking, the influence USA has on our country i...
  # Keyword validation: 'general'
  mutate(q184_reversed = if_else(
    grepl("general", question_text["q184"], ignore.case = TRUE),
    safe_reverse_6pt(q184),
    NA_real_  # Validation failed!
  )),

  # IR12a: IR12a Post-office
  # Keyword validation: 'ir12a'
  mutate(IR12a_reversed = if_else(
    grepl("ir12a", question_text["IR12a"], ignore.case = TRUE),
    safe_reverse_3pt(IR12a),
    NA_real_  # Validation failed!
  )),

  # IR12b: IR12b School
  # Keyword validation: 'ir12b'
  mutate(IR12b_reversed = if_else(
    grepl("ir12b", question_text["IR12b"], ignore.case = TRUE),
    safe_reverse_3pt(IR12b),
    NA_real_  # Validation failed!
  )),

  # IR12c: IR12c Police station
  # Keyword validation: 'ir12c'
  mutate(IR12c_reversed = if_else(
    grepl("ir12c", question_text["IR12c"], ignore.case = TRUE),
    safe_reverse_3pt(IR12c),
    NA_real_  # Validation failed!
  )),

  # IR12d: IR12d Sewerage system that most houses could access
  # Keyword validation: 'ir12d'
  mutate(IR12d_reversed = if_else(
    grepl("ir12d", question_text["IR12d"], ignore.case = TRUE),
    safe_reverse_3pt(IR12d),
    NA_real_  # Validation failed!
  )),

  # IR12e: IR12e Health clinic
  # Keyword validation: 'ir12e'
  mutate(IR12e_reversed = if_else(
    grepl("ir12e", question_text["IR12e"], ignore.case = TRUE),
    safe_reverse_3pt(IR12e),
    NA_real_  # Validation failed!
  )),

  # IR12f: IR12f Signal for cellular phone
  # Keyword validation: 'ir12f'
  mutate(IR12f_reversed = if_else(
    grepl("ir12f", question_text["IR12f"], ignore.case = TRUE),
    safe_reverse_3pt(IR12f),
    NA_real_  # Validation failed!
  )),

  # IR12g: IR12g Recreational facilities, e.g., a sports field
  # Keyword validation: 'ir12g'
  mutate(IR12g_reversed = if_else(
    grepl("ir12g", question_text["IR12g"], ignore.case = TRUE),
    safe_reverse_3pt(IR12g),
    NA_real_  # Validation failed!
  )),

  # IR12h: IR12h Any churches, mosques, temples or other public places ...
  # Keyword validation: 'ir12h'
  mutate(IR12h_reversed = if_else(
    grepl("ir12h", question_text["IR12h"], ignore.case = TRUE),
    safe_reverse_3pt(IR12h),
    NA_real_  # Validation failed!
  )),

  # IR12i: IR12i Any town halls or community buildings that can be used...
  # Keyword validation: 'ir12i'
  mutate(IR12i_reversed = if_else(
    grepl("ir12i", question_text["IR12i"], ignore.case = TRUE),
    safe_reverse_3pt(IR12i),
    NA_real_  # Validation failed!
  )),

  # IR12k: IR12k Market stalls (selling groceries and/or clothing)
  # Keyword validation: 'ir12k'
  mutate(IR12k_reversed = if_else(
    grepl("ir12k", question_text["IR12k"], ignore.case = TRUE),
    safe_reverse_3pt(IR12k),
    NA_real_  # Validation failed!
  ))

# ============================================================
# W6_Cambodia Summary
# Variables needing reversal: 116
# ============================================================

