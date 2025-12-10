# ============================================================
# Asian Barometer W5 - Scale Reversal Script
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

# W5 Reversal Functions with Keyword Validation
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
