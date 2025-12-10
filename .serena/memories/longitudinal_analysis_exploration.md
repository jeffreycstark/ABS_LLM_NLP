# Asian Barometer Longitudinal Analysis - Exploration Summary

## Data Landscape
- **6 waves**: W1 (207 vars), W2 (248), W3 (269), W4 (286), W5 (305), W6_Cambodia (322)
- **Core panel**: 45 variables appear in ALL 6 waves (prime candidates)
- **Extended panel**: 105 variables in 5 waves, 14 in 4 waves
- **Total unique**: 775 variables across all waves (475 wave-specific)

## Critical Challenge: Same Variable ID, Different Questions
**Example q104 (appears in all 6 waves but asks COMPLETELY DIFFERENT QUESTIONS):**
- W1: "How satisfied with current government?" (5-pt, needs reversal)
- W2: "Government will solve important problem?" (4-pt, no reversal)
- W3: "Rich/poor treated equally?" (4-pt, no reversal)
- W4: "When leaders break laws, courts can't act?" (4-pt, no reversal)
- W5: "Democracy suitable?" (6-pt, no reversal)
- W6: "Rich/poor treated equally?" (4-pt, no reversal)

**Implication**: Variable ID matching is UNRELIABLE. Need semantic matching.

## Scale Landscape
- **Dominant**: 4-point Likert (71-127 per wave)
- **Common**: Binary (51-68), 5-pt (21-38), 6-pt (17-67)
- **Rare**: 3-pt (6-29), 10-pt (1-12)
- **Reversal needs**: 5-36% of variables per wave (331 total identified)

## Existing Infrastructure
1. **Python pipeline**: LLM concept extraction + rule-based scale analysis
2. **R pipeline**: Scale reversal with keyword validation (reverse_scales.R)
3. **Metadata**: validation_phrases_improved.json with distinctive 3-word phrases
4. **Missing**: Cross-wave matching, standardization, combining logic

## Key Files
- `W*_enriched.json`: Variables + domain + LLM concepts
- `W*_analyzed.json`: Variables + scale_analysis metadata
- `W*_crosswalk.json`: Domain-organized structure
- `reverse_scales.R`: Reversal functions with validation
- `validation_phrases_improved.json`: Question matching phrases
