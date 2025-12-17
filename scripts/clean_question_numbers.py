#!/usr/bin/env python3
"""
Clean question numbers from atomic question texts.

Fixes format like:
  "24 How much trust... 25 Trust in neighbors"
To:
  "How much trust... Trust in neighbors"
Or better:
  "How much trust do you have in your neighbors?"
"""

import json
import re
from pathlib import Path


def clean_question_text(text):
    """Remove leading question numbers from text."""
    # Remove patterns like "24 " or "q24. " or "Q24: " from start
    text = re.sub(r"^\d+\s+", "", text)
    text = re.sub(r"^[qQ]\d+[\.:]\s*", "", text)

    # Remove embedded question numbers like " 25 " between sentences
    text = re.sub(r"\s+\d+\s+", " ", text)

    return text.strip()


def clean_crosswalk(input_path, output_path):
    """Clean question texts in crosswalk file."""
    print(f"Processing {input_path}")

    with open(input_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    count = 0
    for domain in data.get("domains", []):
        for variable in domain.get("variables", []):
            original = variable.get("question_text", "")
            cleaned = clean_question_text(original)

            if original != cleaned:
                variable["question_text"] = cleaned
                count += 1

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

    print(f"  ✓ Cleaned {count} questions")
    return count


def main():
    waves = ["W1", "W2", "W3", "W4", "W5", "W6_Cambodia"]

    print("=" * 60)
    print("Cleaning Question Numbers from Crosswalk Files")
    print("=" * 60)

    total = 0
    for wave in waves:
        input_path = Path(f"{wave}_crosswalk.json")
        output_path = Path(f"{wave}_crosswalk_cleaned.json")

        if input_path.exists():
            count = clean_crosswalk(input_path, output_path)
            total += count
            print(f"  Saved to: {output_path}")
        else:
            print(f"  ⚠ {input_path} not found")

    print(f"\n✓ Total questions cleaned: {total}")
    print("\nTo use cleaned files, run:")
    print("  mv W*_crosswalk_cleaned.json W*_crosswalk.json")


if __name__ == "__main__":
    main()
