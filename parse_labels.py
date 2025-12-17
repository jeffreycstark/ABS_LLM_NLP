"""
Stage 1: Parse Asian Barometer labels.txt → Atomic JSON

This script:
1. Parses labels.txt files to extract variables and questions
2. Detects stem-and-items patterns
3. Uses LLM to generate stateless JSON for each variable
"""

import os
import re
import json
from typing import List, Dict
from huggingface_hub import InferenceClient


class LabelsParser:
    """Parse Asian Barometer labels.txt format"""

    def __init__(self, file_path: str):
        self.file_path = file_path
        self.variables = []

    def parse(self) -> List[Dict]:
        """Parse the labels file into structured data"""
        with open(self.file_path, "r", encoding="utf-8") as f:
            content = f.read()

        # Split by variable blocks
        variable_pattern = (
            r"Variable: (\w+)\s+Question: (.*?)\s+Value Labels:(.*?)(?=Variable:|$)"
        )
        matches = re.findall(variable_pattern, content, re.DOTALL)

        for var_id, question, value_labels in matches:
            # Parse value labels
            label_pattern = r"(-?\d+)\s*=\s*(.+?)(?=\s*-?\d+\s*=|\s*$)"
            labels = re.findall(label_pattern, value_labels, re.DOTALL)

            parsed_labels = [
                {"value": int(val.strip()), "label": lbl.strip()} for val, lbl in labels
            ]

            self.variables.append(
                {
                    "variable_id": var_id.strip(),
                    "question_text": question.strip(),
                    "value_labels": parsed_labels,
                }
            )

        return self.variables

    def detect_stem_groups(self) -> List[List[int]]:
        """
        Detect stem-and-items patterns using value label matching.
        Returns list of variable indices that share a stem.

        Algorithm:
        1. Look for consecutive questions with identical value labels
        2. These likely belong to the same stem-and-items group
        3. The first question in such a group is the stem (or first item)

        This approach fixes bugs where unrelated questions were incorrectly
        grouped together just because one was long with a "?" and the next
        was short without a "?".
        """
        groups = []
        i = 0

        while i < len(self.variables):
            current_var = self.variables[i]
            current_labels = self._normalize_labels(current_var["value_labels"])

            # Look ahead to find all consecutive questions with same value labels
            group = [i]
            j = i + 1

            while j < len(self.variables):
                next_var = self.variables[j]
                next_labels = self._normalize_labels(next_var["value_labels"])

                # Check if labels match
                if current_labels == next_labels:
                    group.append(j)
                    j += 1
                else:
                    # Labels differ, end of this group
                    break

            # Only keep groups with 2+ items (stem + at least one item)
            if len(group) >= 2:
                groups.append(group)
                i = j  # Skip past this group
            else:
                i += 1  # Move to next question

        return groups

    def _normalize_labels(self, value_labels: List[Dict]) -> tuple:
        """
        Normalize value labels for comparison.
        Returns a tuple of (value, label) pairs, sorted by value.
        """
        return tuple(
            sorted(
                [
                    (label["value"], label["label"].strip().lower())
                    for label in value_labels
                ]
            )
        )


class AtomicJSONGenerator:
    """Generate atomic JSON using LLM"""

    def __init__(self):
        token = os.getenv("HF_TOKEN")
        self.client = InferenceClient(model="google/gemma-2-2b-it", token=token)

    def generate_for_group(self, variables: List[Dict]) -> List[Dict]:
        """
        Generate atomic JSON for a stem-and-items group.
        The first variable has the stem, subsequent ones need it prepended.
        Process pairwise: stem + each item individually for better accuracy.
        """
        if len(variables) == 1:
            # No stem processing needed
            return variables

        # Check if first variable is actually a complete question with a stem
        stem_var = variables[0]
        first_text = stem_var["question_text"]

        # If first question looks like just an item (no verb, no "?"),
        # then the true stem is missing from the data.
        # In this case, don't try to extract a stem - just return as-is
        if not self._has_question_structure(first_text):
            # All items lack a stem - return unchanged
            # A later LLM-based process can infer the missing stem if needed
            return variables

        # Extract stem from first variable
        stem_text = self._extract_stem(first_text)

        atomic_results = [stem_var]  # Keep the stem variable as-is

        # Process each subsequent item individually
        for item_var in variables[1:]:
            # Create atomic version with stem + item
            atomic_var = item_var.copy()
            # Remove variable ID from item text
            item_text = re.sub(r"^\w+\.\s+", "", item_var["question_text"])
            atomic_var["question_text"] = f"{stem_text} {item_text}"
            atomic_results.append(atomic_var)

        return atomic_results

    def _has_question_structure(self, text: str) -> bool:
        """
        Check if text is a complete question (has question structure).
        Returns False if it's just a noun phrase/item.

        Heuristic: A complete question typically has:
        - A question mark OR
        - Common question words (what, how, when, etc.) OR
        - A verb (basic check for common verbs)
        """
        text_lower = text.lower()

        # Has question mark?
        if "?" in text:
            return True

        # Has question words?
        question_words = [
            "what",
            "how",
            "when",
            "where",
            "why",
            "who",
            "which",
            "do you",
            "did you",
            "have you",
            "are you",
            "is it",
        ]
        if any(word in text_lower for word in question_words):
            return True

        # Has common verbs that indicate a question structure?
        common_verbs = [
            " is ",
            " are ",
            " do ",
            " does ",
            " did ",
            " have ",
            " has ",
            " will ",
            " would ",
            " should ",
            " can ",
            " could ",
        ]
        if any(verb in text_lower for verb in common_verbs):
            return True

        # Otherwise, it's likely just a noun phrase/item
        return False

    def _extract_stem(self, question_text: str) -> str:
        """
        Extract the stem from a question that has stem + item.
        The stem is everything before the last sentence/phrase.
        Also removes variable ID prefix (e.g., "q38. ").
        """
        # Remove variable ID prefix if present (e.g., "q38. ")
        cleaned = re.sub(r"^\w+\.\s+", "", question_text)

        # Look for common patterns: "? <Item>" or "  <Item>"
        # The stem usually ends with a question mark followed by 2+ spaces
        match = re.search(r"^(.*?\?)\s{2,}", cleaned)
        if match:
            return match.group(1).strip()

        # Fallback: Look for pattern with question mark followed by space and text
        match = re.search(r"^(.*?\?)\s+", cleaned)
        if match:
            return match.group(1).strip()

        # Last resort: Return everything up to last period or question mark
        sentences = re.split(r"[.?]\s+", cleaned)
        if len(sentences) > 1:
            return ". ".join(sentences[:-1]) + "."

        return cleaned

    def _format_group_for_llm(self, variables: List[Dict]) -> str:
        """Format a variable group for LLM processing"""

        # Build input section
        input_lines = []
        for var in variables:
            input_lines.append(f"Variable: {var['variable_id']}")
            input_lines.append(f"  Question: {var['question_text']}")
            input_lines.append("  Value Labels:")
            for label in var["value_labels"]:
                input_lines.append(f"     {label['value']} = {label['label']}")
            input_lines.append("")

        # Get stem from first variable
        stem_question = variables[0]["question_text"]
        # Extract stem (everything before last specific item)
        stem_match = re.search(r"^(.*?)\s+([A-Z].*?)$", stem_question)
        if stem_match:
            stem = stem_match.group(1).strip()
        else:
            stem = stem_question

        prompt = f"""Parse this Asian Barometer questionnaire into stateless JSON.

KEY RULES:
1. The first variable contains a STEM question + specific item
2. Subsequent variables contain ONLY specific items - you must ADD the stem
3. Each JSON object must be self-contained with the complete question
4. Value labels must be objects with "value" and "label" fields

INPUT:
{chr(10).join(input_lines)}

STEP-BY-STEP:
1. Extract stem: "{stem}"
2. For each variable, combine stem + item for complete question_text
3. Keep all value_labels

Return ONLY a JSON array of objects with keys: variable_id, question_text, value_labels
No markdown formatting."""

        return prompt


def main(input_file: str, output_file: str):
    """Main pipeline: Parse labels → Generate atomic JSON"""

    print(f"Parsing {input_file}...")
    parser = LabelsParser(input_file)
    variables = parser.parse()
    print(f"Found {len(variables)} variables")

    print("Detecting stem-and-items patterns...")
    stem_groups = parser.detect_stem_groups()
    print(f"Found {len(stem_groups)} stem groups")

    # Track which variables are in groups
    grouped_indices = set()
    for group in stem_groups:
        grouped_indices.update(group)

    print("Generating atomic JSON...")
    generator = AtomicJSONGenerator()
    atomic_variables = []

    # Process stem groups
    for group in stem_groups:
        group_vars = [variables[i] for i in group]
        print(f"  Processing group: {[v['variable_id'] for v in group_vars]}")
        atomic_group = generator.generate_for_group(group_vars)
        atomic_variables.extend(atomic_group)

    # Add standalone variables (not in any group)
    for i, var in enumerate(variables):
        if i not in grouped_indices:
            atomic_variables.append(var)

    # Sort by variable_id to maintain order
    atomic_variables.sort(key=lambda x: x["variable_id"])

    # Save output
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(atomic_variables, f, indent=2, ensure_ascii=False)

    print(f"Saved {len(atomic_variables)} atomic variables to {output_file}")


if __name__ == "__main__":
    input_file = "W6_Cambodia_labels.txt"
    output_file = "W6_Cambodia_atomic_test.json"
    main(input_file, output_file)
