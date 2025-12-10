# Asian Barometer Survey Processing Pipeline - Complete Reference

## Critical Scale Classification Logic

### Value 7 Convention (81.5% of cases)
**Value 7 = ALWAYS first NA** ("don't understand the question")

**Algorithm**: Look at value immediately BEFORE 7 = max substantive value
- If value before 7 is 6 → 6-point Likert (1-6)
- If value before 7 is 5 → 5-point Likert (1-5)
- If value before 7 is 4 → 4-point Likert (1-4)
- If value before 7 is 2 or 1 → Binary scale

### 10+ Values Rule (CRITICAL)
**If num_points >= 10 → NOT Likert**
- scale_10: values 0-10 or 1-10
- categorical: >10 distinct values
- 18.5% of value 7 labels are substantive (country codes, occupations, etc.)

### Implementation: intelligent_guesser.py
- Lines 112-190: `classify_scale()` method
- Lines 226-237: 10+ values check (MUST come BEFORE Likert classification)
- Lines 34-38: NA patterns including "don't understand"

## Distinctive Keyword Extraction

### Frequency-Based Selection (NO Priority Words)
1. Build word frequency Counter across ALL questions in wave
2. For each question: select word with LOWEST frequency = most distinctive
3. Filter: stop words + words < 5 characters
4. Results: "withhold", "earner", "opportunities" NOT "trust", "democracy"

### Implementation
- export_reversal_guide.py: Lines 17-57
- generate_r_recoders.py: Lines 30-60

## R Script Validation Pattern

All 370 reversal functions include keyword validation:
```r
# Keyword validation: 'distinctive_word'
mutate(var_id_reversed = if_else(
  grepl("distinctive_word", question_text["var_id"], ignore.case = TRUE),
  safe_reverse_Npt(var_id),
  NA_real_  # Validation failed!
))
```

## Groq Concept Extraction

### Models
- **llama-3.3-70b-versatile**: Primary (100K tokens/day)
- **llama-3.1-8b-instant**: Fallback (separate limit)

### Implementation: extract_concepts.py
- Line 19: Model parameter
- Batch size: 10 questions
- Error handling: Falls back to "Unknown" domain

## Processing Pipeline

```
W{N}_atomic.json → W{N}_analyzed.json → W{N}_enriched.json → CSVs
```

## Current Status (All 6 Waves Complete)

### Reversal Variables
- W1: 10 (4.8%), W2: 54 (21.8%), W3: 57 (21.2%)
- W4: 71 (24.8%), W5: 62 (20.3%), W6_Cambodia: 116 (36.0%)
- **Total: 370** (down from 688 before corrections)

### Concept Extraction
- W5: 305 variables, 86 domains
- W6_Cambodia: 322 variables, 116 domains (5 unknown)

## Key Corrections

1. **Likert 7**: 144 (47.2%) → 1 (0.3%) by "value before 7" algorithm
2. **10+ values**: Now properly categorical, not Likert
3. **Keywords**: Frequency-based, not priority words

## Value 7 Distribution
- 751 (81.5%): "don't understand" → Likert NA
- 170 (18.5%): Substantive → Categorical/10-point

## Files Requiring Manual Review
- value_7_na_questions.json: 25 questions with "No answer"/"Not applicable"

## Commands

```bash
# Reclassify
python3 intelligent_guesser.py W{N}_atomic.json W{N}_analyzed.json

# Extract concepts
python3 extract_concepts.py  # Edit line 202 for wave

# Generate CSVs
python3 export_reversal_guide.py
python3 generate_r_recoders.py
python3 generate_csv.py W{N}_enriched.json W{N}_concepts.csv W{N}_concepts_detailed.csv
```