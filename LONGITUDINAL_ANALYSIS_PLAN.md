# Asian Barometer Longitudinal Dataset Construction Plan

## Overview
Create a consolidated longitudinal dataset from 6 Asian Barometer waves (W1-W6_Cambodia) for panel analysis, combining ~1,637 questions into 150-200 matched question groups with proper scale normalization and concept harmonization.

## Key Design Decisions

### 1. Question Matching Strategy: Hybrid Semantic + Rule-Based
**Why**: Variable IDs are unreliable (e.g., q104 means different things across waves). Semantic embeddings provide robust matching while validation phrases catch exact matches.

**Approach**:
- **Primary**: Sentence-transformers embeddings (`all-MiniLM-L6-v2`) with FAISS index for fast similarity search
- **Secondary**: Validation phrase matching using existing `validation_phrases_improved.json`
- **Threshold**: 0.85 for auto-accept, 0.75-0.85 for manual review

**Trade-off**: Slightly lower recall (may miss some paraphrases at 0.85) but high precision (95%+ accuracy). Acceptable for medium scope.

### 2. Scale Normalization: Three-Stage Pipeline
1. **Scale Reversal** (Week 1): Execute existing `reverse_scales.R` with keyword validation
2. **Missing Value Harmonization** (Week 1): Standardize NA codes (-1, 7, 8, 9, 98, 99 → NA_real_)
3. **Statistical Standardization** (On-demand): Apply z-scores only when combining different Likert scales for analysis

**Why**: Preserves original data for auditing; allows flexible standardization based on research question.

### 3. Panel Data Structure: Long Format with Respondent Tracking
**Schema**:
```
respondent_id | country | wave | question_group_id | value_original | value_reversed | value_cleaned | concepts_canonical | match_confidence
```

**Why**: Flexible for both within-person change analysis and aggregate trends; preserves transformation history.

### 4. Concept Consolidation: Automated Clustering + Manual Review
- Cluster similar concepts using embeddings (threshold 0.8)
- Manual review of borderline cases (0.6-0.8 similarity)
- Budget: 4-6 hours of manual review for ~50-80 borderline concept groups

## Implementation Phases

### Phase 1: Foundation & Core Matching (Weeks 1-2)

#### Week 1: Data Preparation
**Tasks**:
1. Execute scale reversals on all 6 waves
   - Run existing `reverse_scales.R`
   - Output: `W*_reversed.rds` (6 files)
   - Validation: Check keyword validation passes for all 331 variables

2. Implement missing value harmonization (R script)
   - Create `harmonize_missing_values.R`
   - Standardize all NA codes to `NA_real_`
   - Output: `W*_cleaned.rds` (6 files with original + reversed + cleaned)

**Files to Create**:
- `scripts/harmonize_missing_values.R`

**Critical Files to Read**:
- `/Users/jeffreystark/Development/Research/ABS_LLM_NLP/reverse_scales.R` (existing, 3,335 lines)
- `/Users/jeffreystark/Development/Research/ABS_LLM_NLP/W*_analyzed.json` (scale metadata)

#### Week 2: Semantic Matching Infrastructure
**Tasks**:
1. Build question matcher (Python)
   - Load all questions from `W*_enriched.json`
   - Create sentence embeddings (sentence-transformers)
   - Build FAISS index for fast search
   - Output: `question_embeddings_index.faiss`, `question_metadata.json`

2. Run high-confidence matching (threshold 0.85)
   - Find semantically similar questions across waves
   - Validate with phrase matching from `validation_phrases_improved.json`
   - Output: `matched_questions_high_confidence.json` (~120-150 question groups expected)

**Files to Create**:
- `scripts/question_matcher.py` (QuestionMatcher class)
- `scripts/build_embeddings_index.py` (execution script)

**Dependencies**:
- `sentence-transformers` (pip install)
- `faiss-cpu` (pip install)
- `numpy`, `pandas`

**Critical Files to Read**:
- `/Users/jeffreystark/Development/Research/ABS_LLM_NLP/validation_phrases_improved.json`
- `/Users/jeffreystark/Development/Research/ABS_LLM_NLP/W*_enriched.json` (all 6 waves)

**Validation Checkpoint**:
- Verify core democracy questions (q100-q109) matched across all 6 waves
- Spot-check 10 random matches manually
- Target: 120-150 high-confidence question groups

---

### Phase 2: Extended Matching & Manual Review (Week 3)

#### Tasks:
1. Lower threshold matching (0.75-0.85)
   - Identify additional question groups requiring manual review
   - Output: `uncertain_matches_for_review.csv` (~80-120 borderline cases expected)

2. Manual review session (Budget: 6-8 hours)
   - Review borderline matches in batches
   - Criteria: Same concept despite different wording?
   - Decisions: Accept, reject, or split into multiple groups
   - Output: `manual_match_decisions.csv`

3. Update matching results
   - Incorporate manual decisions
   - Output: `matched_questions_final.json` (target: 150-200 question groups)

**Files to Create**:
- `scripts/export_uncertain_matches.py`
- `scripts/incorporate_manual_decisions.py`
- `data/manual_match_decisions.csv` (human-edited)

**Manual Review Template** (CSV):
```
match_id | wave1 | var_id1 | question1 | wave2 | var_id2 | question2 | similarity | decision | notes
```

**Validation Checkpoint**:
- Manual review precision >95% (validate 20 accepted matches)
- Coverage: 150-200 question groups spanning 5-6 waves

---

### Phase 3: Concept Consolidation (Week 4)

#### Tasks:
1. Automated concept clustering
   - Extract concepts from all matched questions (from `W*_enriched.json`)
   - Cluster semantically similar concepts (threshold 0.8)
   - Select canonical concept per cluster
   - Output: `consolidated_concepts_auto.json`

2. Manual concept review (Budget: 4-6 hours)
   - Review borderline concept merges (0.6-0.8 similarity)
   - Criteria: Same underlying construct?
   - Output: `concept_consolidation_decisions.csv`

3. Create concept genealogy
   - Document concept lineage across waves
   - Track original → canonical mapping
   - Output: `concept_genealogy.json`

**Files to Create**:
- `scripts/concept_consolidator.py` (ConceptConsolidator class)
- `scripts/export_concept_review.py`
- `data/concept_consolidation_decisions.csv` (human-edited)

**Critical Files to Read**:
- `/Users/jeffreystark/Development/Research/ABS_LLM_NLP/W*_enriched.json` (concepts field)
- `/Users/jeffreystark/Development/Research/ABS_LLM_NLP/W*_crosswalk.json` (domain structure)

**Validation Checkpoint**:
- Concepts coherent within groups (spot-check 20 groups)
- No semantic drift across waves
- Wave-specific concepts clearly flagged

---

### Phase 4: Panel Dataset Construction (Week 5)

#### Tasks:
1. **Merge respondent data with matched questions**
   - Load actual survey response data (*.dta, *.sav, or *.rds files)
   - Join with matched question groups
   - Handle respondent ID tracking across waves (panel structure)
   - Apply all transformations (reversal, cleaning)
   - Output: `asian_barometer_panel_long.rds`

2. **Create dataset variants**
   - Core panel: Questions in 5-6 waves (target: 45-60 groups)
   - Extended panel: Questions in 3-4 waves (target: 90-140 groups)
   - Wave-specific catalog: 1-2 wave questions
   - Output: `asian_barometer_core_panel.rds`, `asian_barometer_extended_panel.rds`

3. **Add standardization functions** (R utility library)
   - Z-score standardization
   - Percent-of-maximum transformation
   - Apply on-demand based on analysis needs
   - Output: `scripts/standardization_functions.R`

**Panel Data Schema**:
```r
tibble(
  respondent_id = character(),        # Panel ID (unique person across waves)
  country = character(),              # Country code
  wave = character(),                 # W1, W2, ..., W6_Cambodia
  question_group_id = character(),    # Matched question group
  variable_id_wave = character(),     # Original wave-specific variable ID

  # Question metadata
  question_text_canonical = character(),
  question_text_original = character(),

  # Scale metadata
  original_scale_type = character(),  # likert_4, likert_5, etc.
  original_scale_points = integer(),
  original_reversed = logical(),

  # Response values
  value_original = double(),
  value_reversed = double(),
  value_cleaned = double(),

  # Concepts
  concepts_canonical = list(),
  concepts_original = list(),
  domain = character(),

  # Quality flags
  match_confidence = double(),
  comparability_status = character()
)
```

**Files to Create**:
- `scripts/build_panel_dataset.R`
- `scripts/standardization_functions.R`

**Critical Assumption**:
- Respondent IDs exist and are consistent across waves
- Survey data files have compatible formats

**Validation Checkpoint**:
- All 1,637 original questions accounted for
- No duplicate respondent-wave-question combinations
- Panel structure valid (respondents tracked correctly)
- Missing data patterns documented

---

### Phase 5: Documentation & Validation (Week 6)

#### Tasks:
1. **Create codebook**
   - Variable definitions for all question groups
   - Scale information and transformation details
   - Concept mappings and genealogy
   - Output: `CODEBOOK.md`

2. **Write methodology documentation**
   - Matching algorithm description
   - Scale normalization procedures
   - Validation results and quality metrics
   - Output: `METHODOLOGY.md`

3. **Generate validation reports**
   - Matching statistics (coverage, precision)
   - Scale distribution checks
   - Missing data summary
   - Test-retest reliability for repeated questions
   - Output: `VALIDATION_REPORT.md`

4. **Create usage examples**
   - Sample trend analysis (R script)
   - Panel regression example
   - Cross-wave comparison
   - Output: `examples/usage_examples.R`

**Files to Create**:
- `CODEBOOK.md`
- `METHODOLOGY.md`
- `VALIDATION_REPORT.md`
- `examples/usage_examples.R`
- `scripts/generate_validation_report.R`

**Validation Strategies**:

**Level 1: Automated Checks**
```r
# Data quality validation
validate_panel_data <- function(data) {
  list(
    no_duplicates = check_unique_rows(data),
    missing_patterns = summarise_missing(data),
    value_ranges = check_ranges_by_scale(data),
    wave_coverage = count_questions_by_wave(data),
    transformation_chains = verify_reversals(data)
  )
}
```

**Level 2: Statistical Validation**
- Test-retest reliability for repeated questions (target: r > 0.5)
- Scale distribution checks (flag if SD = 0 or extreme skewness)
- Cross-wave correlation patterns

**Level 3: Manual Audit** (Budget: 2-4 hours)
- Review 10% random sample of matched question groups
- Validate concept assignments for 20 core questions
- Spot-check transformation chains

---

## Expected Outputs

### Data Files
1. **Wave-level cleaned data** (6 files)
   - `data/cleaned/W*_cleaned.rds`
   - Contains: original, reversed, and cleaned versions

2. **Matching metadata**
   - `data/matching/question_embeddings_index.faiss`
   - `data/matching/question_metadata.json`
   - `data/matching/matched_questions_final.json`
   - `data/matching/concept_genealogy.json`

3. **Longitudinal datasets** (3 files)
   - `data/panel/asian_barometer_core_panel.rds` (45-60 question groups, 5-6 waves)
   - `data/panel/asian_barometer_extended_panel.rds` (150-200 question groups, 3+ waves)
   - `data/panel/asian_barometer_wave_specific.rds` (catalog only, 1-2 waves)

### Documentation Files
- `CODEBOOK.md` - Variable definitions and metadata
- `METHODOLOGY.md` - Processing pipeline description
- `VALIDATION_REPORT.md` - Quality assurance results
- `examples/usage_examples.R` - Sample analyses

### Scripts/Tools
- `scripts/harmonize_missing_values.R`
- `scripts/question_matcher.py`
- `scripts/concept_consolidator.py`
- `scripts/build_panel_dataset.R`
- `scripts/standardization_functions.R`
- `scripts/generate_validation_report.R`

---

## Critical Files Reference

### Existing Files (DO NOT MODIFY)
- `/Users/jeffreystark/Development/Research/ABS_LLM_NLP/reverse_scales.R` (3,335 lines, existing reversal code)
- `/Users/jeffreystark/Development/Research/ABS_LLM_NLP/validation_phrases_improved.json` (validation phrases for 1,637 questions)
- `/Users/jeffreystark/Development/Research/ABS_LLM_NLP/W*_enriched.json` (6 files, question metadata with concepts)
- `/Users/jeffreystark/Development/Research/ABS_LLM_NLP/W*_analyzed.json` (6 files, scale analysis metadata)
- `/Users/jeffreystark/Development/Research/ABS_LLM_NLP/W*_crosswalk.json` (6 files, domain organization)

### Survey Data Files (TO BE LOADED)
- User's actual survey response data (*.dta, *.sav, or *.rds files)
- Location to be determined in Phase 4

---

## Key Assumptions

1. **Respondent IDs exist** and are consistent across waves for panel tracking
2. **Survey data format** is compatible (Stata .dta, SPSS .sav, or R .rds)
3. **Manual review capacity**: 8-16 hours total across Phases 2-3
4. **Target scope**: 150-200 matched question groups (medium priority)
5. **Panel structure**: Same individuals tracked across waves (not repeated cross-sections)

---

## Success Metrics

### Coverage
- ✅ 150-200 matched question groups (3+ waves each)
- ✅ 45-60 core question groups (5-6 waves each)
- ✅ All 1,637 original questions accounted for

### Quality
- ✅ Matching precision >95% (manual validation sample)
- ✅ Test-retest reliability r > 0.5 for repeated questions
- ✅ No duplicate respondent-wave-question records
- ✅ Transformation chains validated (original → reversed → cleaned)

### Usability
- ✅ Comprehensive codebook with variable definitions
- ✅ Usage examples for common analyses
- ✅ Methodology documentation for reproducibility
- ✅ Validation report documenting quality assurance

---

## Timeline Summary

| Week | Phase | Key Deliverables | Manual Effort |
|------|-------|------------------|---------------|
| 1-2 | Foundation | Reversed/cleaned data, high-confidence matches | 2-3 hours |
| 3 | Extended Matching | Manual review, final matches (150-200 groups) | 6-8 hours |
| 4 | Concept Consolidation | Canonical concepts, genealogy | 4-6 hours |
| 5 | Dataset Construction | Panel datasets (core, extended, wave-specific) | 1-2 hours |
| 6 | Documentation | Codebook, methodology, validation report | 2-4 hours |

**Total**: 5-6 weeks, 15-23 hours manual effort

---

## Next Steps After Planning

1. **Week 1 Sprint**: Execute Phase 1 (reversal + missing value harmonization)
2. **Week 2 Sprint**: Build semantic matching infrastructure
3. **Week 3 Check-in**: Manual review session for uncertain matches
4. **Week 4 Check-in**: Manual review session for concept consolidation
5. **Week 5 Integration**: Build final panel datasets
6. **Week 6 Finalization**: Documentation and validation

---

## Risk Mitigation

### Risk: Semantic matching misses paraphrased questions
**Mitigation**: Two-tier threshold (0.85 auto-accept, 0.75-0.85 manual review) + phrase validation

### Risk: Respondent IDs inconsistent across waves
**Mitigation**: Validate ID structure in Phase 4, create mapping table if needed

### Risk: Scale distributions change post-reversal
**Mitigation**: Statistical validation checks (distributions, test-retest reliability)

### Risk: Concept drift across waves (same term, different meaning)
**Mitigation**: Manual review of borderline concept merges, concept genealogy tracking

### Risk: Manual review capacity exceeded
**Mitigation**: Batch review sessions, focus on high-impact questions (core panel first)
