# Asian Barometer Survey - LLM Concept Extraction Pipeline

## Project Purpose
This project processes Asian Barometer survey questionnaires to extract concepts and create crosswalks for cross-survey comparison. It uses LLMs to:
1. Parse survey labels into atomic (stateless) JSON format
2. Extract conceptual domains and concepts from questions
3. Generate crosswalks organized by domain for research analysis

## Tech Stack
- **Language**: Python 3.14+
- **Package Manager**: uv (not pip)
- **Dependencies**: 
  - `groq` - Groq API client for LLM concept extraction
  - `huggingface_hub` - Legacy, being phased out
  - `pandas` - For CSV export
  - `openai` - Not actively used

## Project Structure
```
.
├── parse_labels.py          # Phase I: labels.txt → atomic JSON
├── extract_concepts.py      # Phase II: atomic JSON → concepts/crosswalk
├── test_q38_q39.py         # Debug/testing script
├── main.py, main2.py, main3.py  # Early experiments (legacy)
├── W[1-6]_labels.txt       # Input: Raw survey labels
├── W[1-6]_atomic.json      # Phase I output: Stateless questions
├── W[1-6]_enriched.json    # Phase II output: Questions + concepts
├── W[1-6]_crosswalk.json   # Phase II output: Domain-organized
└── W[1-6]_concepts*.csv    # Human-readable exports
```

## Data Flow
1. **Input**: `W*_labels.txt` - Asian Barometer survey format
2. **Phase I**: `parse_labels.py` → Detect stem-and-items patterns → Generate atomic JSON
3. **Phase II**: `extract_concepts.py` → LLM extracts domains/concepts → Generate crosswalk
4. **Export**: CSV files for spreadsheet analysis

## Key Concepts
- **Stem-and-items**: Survey pattern where first question has stem + item, subsequent questions share the stem
- **Atomic JSON**: Self-contained questions with full text (stem + item combined)
- **Crosswalk**: Domain-organized mapping for cross-survey comparison
- **Groq API**: Using llama-3.3-70b-versatile model for concept extraction