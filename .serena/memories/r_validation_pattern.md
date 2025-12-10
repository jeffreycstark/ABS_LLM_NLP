# R Scale Reversal Validation Pattern

## Purpose
Double-check that we're reversing the correct ABS survey question by validating against unique keywords in the question text.

## Pattern Structure
```r
w1 <- w1 %>%
  # ir002: Is this the first questionnaire the interviewer have complet...
  # Keyword validation: 'questionnaire'
  mutate(ir002_reversed = if_else(
    grepl("questionnaire", question_text["ir002"], ignore.case = TRUE),
    safe_reverse_2pt(ir002),
    NA_real_  # Validation failed!
  ))
```

## How It Works
1. **Validation keyword**: Extract a distinctive word/phrase from the question text (e.g., "questionnaire")
2. **grepl() check**: Verify that `question_text["ir002"]` contains that keyword
3. **Safe reversal**: Only reverse if validation passes
4. **Failure handling**: Returns `NA_real_` if keyword doesn't match (prevents reversing wrong question)

## Requirements for Validation Keywords
- Must be **unique** or highly distinctive within the wave's questions
- Should be specific enough to identify exactly one question
- Case-insensitive matching for robustness
- Prefer content words over common function words

## File Location
`reverse_scales.R` - contains all scale reversal operations with validation

## Related Processing
- Crosswalk files contain `question_text` for each `variable_id`
- Enriched files have the same structure
- Need to identify suitable validation keywords for each question requiring reversal
