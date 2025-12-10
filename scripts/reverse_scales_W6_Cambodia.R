# ============================================================
# Asian Barometer W6_Cambodia - Scale Reversal Script
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

# W6_Cambodia Reversal Functions with Keyword Validation
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
