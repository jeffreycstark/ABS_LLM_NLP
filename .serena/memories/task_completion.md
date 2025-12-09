# Task Completion Procedures

## When a Task is Complete

### 1. Verify Outputs
```bash
# Check that expected files were created
ls -lh W*_atomic.json W*_enriched.json W*_crosswalk.json

# Validate JSON structure
python -m json.tool <filename> > /dev/null

# Check variable counts
python -c "import json; print(len(json.load(open('W1_atomic.json'))))"
```

### 2. Quality Checks
- **Phase I (parse_labels.py)**:
  - Verify stem groups detected match expectations
  - Check atomic JSON has complete question text (stem + item)
  - Confirm variable count matches input

- **Phase II (extract_concepts.py)**:
  - Check for "Unknown" domain count (should be minimal)
  - Verify domain categorization is reasonable
  - Confirm no rate limit errors in output

### 3. Git Workflow
```bash
# Stage changes
git add <files>

# Commit with descriptive message
git commit -m "Brief summary

Detailed explanation:
- What changed
- Why it changed
- Impact/results"

# Push (if remote configured)
git push origin main
```

### 4. No Linting/Formatting Requirements
- **No linters**: Black, flake8, pylint not configured
- **No formatters**: No auto-formatting required
- **No type checking**: mypy not used
- **No tests**: No pytest or unittest suite

Manual code review is sufficient. Focus on:
- Code runs without errors
- Outputs are correct
- Logic is clear

### 5. Documentation
- Update memory files if significant changes
- Add inline comments for complex logic
- No formal docs generation required

### 6. Rate Limit Management
If hitting Groq API rate limits:
- Wait 7-10 minutes for reset
- Don't switch models mid-wave (maintain consistency)
- Monitor token usage in error messages
- Free tier: 100,000 tokens/day for llama-3.3-70b

### 7. Export CSV (if needed)
```python
import json, csv

with open('W1_enriched.json') as f:
    data = json.load(f)

with open('W1_concepts.csv', 'w') as f:
    writer = csv.writer(f)
    writer.writerow(['variable_id', 'domain', 'concepts', 'question_text'])
    for var in data:
        writer.writerow([
            var['variable_id'],
            var.get('domain', 'Unknown'),
            ', '.join(var.get('concepts', [])),
            var['question_text']
        ])
```