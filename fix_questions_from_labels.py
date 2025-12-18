#!/usr/bin/env python3
"""
Fix questions in combined_detailed.csv by parsing original labels.txt files
to get questions WITHOUT stem concatenation bugs.
"""

import pandas as pd
import re
from pathlib import Path

# Paths
csv_path = Path("/Users/jeffreystark/Development/Research/AsianBarometer-ResearchHub/data/crosswalks/combined_detailed.csv")
current_dir = Path("/Users/jeffreystark/Development/Research/ABS_LLM_NLP")

def parse_labels_file(file_path: Path):
    """Parse a labels.txt file to extract original questions"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Split by variable blocks
    variable_pattern = r"Variable: (\w+)\s+Question: (.*?)\s+Value Labels:"
    matches = re.findall(variable_pattern, content, re.DOTALL)

    # Create mapping
    mapping = {}
    for var_id, question in matches:
        mapping[var_id.strip()] = question.strip()

    return mapping

# Load the CSV
print(f"Loading CSV from {csv_path}...")
df = pd.read_csv(csv_path)
print(f"Loaded {len(df)} rows")

# Create a mapping of wave -> variable_id -> original_question
wave_data = {}

# Parse all labels.txt files
for wave_num in [1, 2, 3, 4, 5]:
    labels_path = current_dir / f"W{wave_num}_labels.txt"
    if labels_path.exists():
        print(f"Parsing {labels_path.name}...")
        wave_key = f"wave{wave_num}"
        wave_data[wave_key] = parse_labels_file(labels_path)
        print(f"  Loaded {len(wave_data[wave_key])} variables for {wave_key}")

# Parse Cambodia file for wave6
cambodia_path = current_dir / "W6_Cambodia_labels.txt"
if cambodia_path.exists():
    print(f"Parsing {cambodia_path.name}...")
    wave_data['wave6'] = parse_labels_file(cambodia_path)
    print(f"  Loaded {len(wave_data['wave6'])} variables for wave6")

# Now update the CSV
print("\nUpdating questions in CSV...")
updated_count = 0
missing_count = 0

for idx, row in df.iterrows():
    wave = row['wave']
    var_id = row['variable_id']

    # Look up the original question
    if wave in wave_data and var_id in wave_data[wave]:
        original_question = wave_data[wave][var_id]
        df.at[idx, 'question_text'] = original_question
        updated_count += 1
    else:
        missing_count += 1
        if missing_count <= 20:  # Print first 20 missing
            print(f"  Missing: {wave}/{var_id}")

print(f"\nUpdated {updated_count} questions")
print(f"Missing {missing_count} questions")

if missing_count > 20:
    print(f"  (showing first 20 missing, {missing_count - 20} more not shown)")

# Save the updated CSV
output_path = csv_path
print(f"\nSaving updated CSV to {output_path}...")
df.to_csv(output_path, index=False)
print("Done!")

print("\n" + "="*60)
print("Summary:")
print(f"  Total rows: {len(df)}")
print(f"  Updated: {updated_count}")
print(f"  Missing: {missing_count}")
print("="*60)
