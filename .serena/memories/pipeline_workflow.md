# Pipeline Workflow

## Two-Phase Pipeline Architecture

### Phase I: Labels → Atomic JSON (parse_labels.py)

**Input**: `W*_labels.txt` (Asian Barometer format)
```
Variable: q38
  Question: q38. Based on your experience, how easy or difficult...? An identity document
  Value Labels:
     -1 = Missing
     1 = Very Difficult
     ...

Variable: q39
  Question: q39. A place in a public primary school for a child
  Value Labels:
     -1 = Missing
     ...
```

**Process**:
1. **LabelsParser.parse()**: Extract variables using regex
2. **detect_stem_groups()**: Identify stem-and-items patterns
   - Stem question: >80 chars OR contains phrases like "each of the following"
   - Item questions: <100 chars, no "?", follows stem
3. **AtomicJSONGenerator**: Combine stem with each item
   - Extract stem (everything before final item)
   - Prepend stem to each item question

**Output**: `W*_atomic.json` (stateless, self-contained questions)
```json
[
  {
    "variable_id": "q38",
    "question_text": "Based on your experience, how easy or difficult is it to obtain the following services? Or have you never tried to get these services from government? An identity document (such as a birth certificate or passport)",
    "value_labels": [{"value": -1, "label": "Missing"}, ...]
  },
  {
    "variable_id": "q39",
    "question_text": "Based on your experience, how easy or difficult is it to obtain the following services? Or have you never tried to get these services from government? A place in a public primary school for a child",
    "value_labels": [{"value": -1, "label": "Missing"}, ...]
  }
]
```

### Phase II: Atomic JSON → Concepts + Crosswalk (extract_concepts.py)

**Input**: `W*_atomic.json`

**Process**:
1. **ConceptExtractor**: Batch process (10 questions at a time)
2. **LLM Analysis** (Groq llama-3.3-70b-versatile):
   - Identify primary domain (e.g., "Economic Perception")
   - Extract key concepts (e.g., ["economic condition", "national level"])
3. **Fallback handling**: On error, mark as "Unknown" domain
4. **generate_crosswalk()**: Group by domain

**Outputs**:
- `W*_enriched.json`: Original + domain + concepts
```json
[
  {
    "variable_id": "q38",
    "question_text": "Based on your experience...",
    "value_labels": [...],
    "domain": "Service Accessibility",
    "concepts": ["government services", "accessibility", "identity documents"]
  }
]
```

- `W*_crosswalk.json`: Domain-organized for analysis
```json
{
  "metadata": {"total_variables": 269, "total_domains": 117},
  "domains": [
    {
      "domain": "Service Accessibility",
      "variable_count": 10,
      "variables": [...]
    }
  ]
}
```

## Multi-Wave Processing

### Waves Available
- W1: 207 variables, 1 stem group
- W2: 248 variables, 9 stem groups
- W3: 269 variables, 9 stem groups
- W4: 286 variables, 4 stem groups
- W5: 305 variables, 8 stem groups
- W6_Cambodia: 322 variables, 12 stem groups

### Batch Processing Pattern
```python
from parse_labels import main as parse_main
from extract_concepts import main as extract_main

waves = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6_Cambodia']

for wave in waves:
    # Phase I
    parse_main(f'{wave}_labels.txt', f'{wave}_atomic.json')
    
    # Phase II
    extract_main(
        f'{wave}_atomic.json',
        f'{wave}_enriched.json',
        f'{wave}_crosswalk.json'
    )
```

## Key Challenges

### Stem Detection Edge Cases
- Questions with multiple question marks
- Short stems (<80 chars) but clear pattern phrases
- Variable ID prefixes (e.g., "q38.") must be removed

### Rate Limits
- Groq free tier: 100,000 tokens/day
- ~240-250 variables per day with llama-3.3-70b
- Solution: Wait for reset, don't switch models mid-wave

### Quality Control
- Check "Unknown" domain count
- Verify domain naming consistency across waves
- Cross-validate concept assignments