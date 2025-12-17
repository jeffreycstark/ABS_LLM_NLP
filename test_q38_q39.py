"""Test the q38/q39 stem parsing"""

import json
from parse_labels import LabelsParser, AtomicJSONGenerator

# Parse the file
parser = LabelsParser("W3_labels.txt")
variables = parser.parse()

# Find q38-q41
q38_group = [v for v in variables if v["variable_id"] in ["q38", "q39", "q40", "q41"]]

print("=== INPUT VARIABLES ===")
for v in q38_group:
    print(f"\n{v['variable_id']}: {v['question_text'][:100]}...")

# Generate atomic JSON
generator = AtomicJSONGenerator()
atomic = generator.generate_for_group(q38_group)

print("\n\n=== ATOMIC JSON OUTPUT ===")
print(json.dumps(atomic, indent=2, ensure_ascii=False))
