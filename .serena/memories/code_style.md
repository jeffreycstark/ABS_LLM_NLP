# Code Style and Conventions

## General Style
- **Format**: Python 3.14+ with standard formatting
- **Imports**: Standard library → third-party → local modules
- **Line length**: No strict limit, reasonable wrapping (~80-100 chars)
- **Naming**: 
  - Functions/variables: `snake_case`
  - Classes: `PascalCase`
  - Constants: `UPPER_SNAKE_CASE`

## Docstrings
- **Module docstrings**: Triple-quoted strings at file top explaining purpose
- **Class docstrings**: Brief description of class purpose
- **Method docstrings**: Present but concise, focus on parameters and returns
- **Format**: Google/informal style, not strict

Example:
```python
"""
Stage 2: Atomic JSON → Concept/Domain Extraction

This script:
1. Reads atomic JSON from Stage 1
2. Groups questions by conceptual domains
3. Extracts concepts for crosswalk generation
"""

class ConceptExtractor:
    """Extract concepts and domains from atomic questions"""
    
    def extract_concepts_batch(self, variables: List[Dict], batch_size: int = 10) -> List[Dict]:
        """
        Extract concepts from a batch of variables.
        Returns enriched variables with concept/domain annotations.
        """
```

## Type Hints
- Used consistently for function parameters and returns
- Common types: `List[Dict]`, `str`, `int`, `Dict`
- Optional types: `Optional[str]` or default `None`

## Error Handling
- Try-except blocks with fallback behavior
- Error messages include context
- Batch operations continue on error with "Unknown" defaults

## Configuration
- API keys from environment variables (`os.getenv()`)
- Hardcoded defaults in main blocks
- Model names as class parameters with defaults

## Design Patterns
- **Class-based processors**: `LabelsParser`, `AtomicJSONGenerator`, `ConceptExtractor`
- **Regex-heavy parsing**: Pattern matching for stem detection and text extraction
- **Batch processing**: Process 10 items at a time for LLM API calls
- **JSON I/O**: Heavy use of `json.load()` and `json.dump()`
- **Progressive output**: Print statements for progress tracking