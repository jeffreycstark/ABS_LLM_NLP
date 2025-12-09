# Suggested Commands

## Package Management (IMPORTANT: Use uv, not pip!)
```bash
# Install dependencies
uv pip install <package>

# Install from requirements
uv pip install -r requirements.txt

# Show installed packages
uv pip list
```

## Environment Variables
```bash
# Set Groq API key (required for Phase II)
export GROQ_API_KEY="your_key_here"

# Check environment variables
env | grep GROQ
```

## Running the Pipeline

### Phase I: Parse labels → atomic JSON
```bash
python parse_labels.py
# Processes: W3_labels.txt → W3_atomic.json
# To change wave, edit __main__ block in parse_labels.py
```

### Phase II: Extract concepts → crosswalk
```bash
GROQ_API_KEY="your_key" python extract_concepts.py
# Processes: W3_atomic.json → W3_enriched.json, W3_crosswalk.json
# Requires valid Groq API key
```

### Batch Processing (from Python)
```python
from parse_labels import main as parse_main
from extract_concepts import main as extract_main

# Phase I
parse_main('W1_labels.txt', 'W1_atomic.json')

# Phase II  
extract_main('W1_atomic.json', 'W1_enriched.json', 'W1_crosswalk.json')
```

## Git Commands
```bash
# Check status
git status

# Stage all changes
git add -A

# Commit
git commit -m "Your message"

# Add remote (if not configured)
git remote add origin <url>

# Push
git push -u origin main
```

## Development Utilities (macOS Darwin)
```bash
# List files
ls -1              # Simple list
ls -lh             # Detailed with sizes

# Search files
find . -name "*.py"
grep -r "pattern" .

# View file
cat filename
head -20 filename
tail -20 filename

# Directory info
du -sh *          # Sizes of directories
wc -l *.json      # Line counts
```

## Testing/Debugging
```bash
# Test specific functionality
python test_q38_q39.py

# Debug Python interactively
python -i parse_labels.py

# Check JSON validity
python -m json.tool W1_atomic.json > /dev/null
```

## Data Analysis
```bash
# Count variables in JSON
python -c "import json; data = json.load(open('W1_atomic.json')); print(len(data))"

# Check domains in crosswalk
python -c "import json; data = json.load(open('W1_crosswalk.json')); print(data['metadata'])"

# View CSV
head -20 W3_concepts.csv
```