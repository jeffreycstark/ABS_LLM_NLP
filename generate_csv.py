"""
Convert enriched JSON to CSV formats for concepts export
"""

import json
import csv
import sys


def json_to_csv(enriched_json_file: str, output_csv: str, output_detailed_csv: str):
    """
    Convert enriched JSON to two CSV formats:
    1. Basic: variable_id, domain, concepts, question_text
    2. Detailed: includes value_labels
    """

    print(f"Loading {enriched_json_file}...")
    with open(enriched_json_file, "r", encoding="utf-8") as f:
        variables = json.load(f)

    print(f"Converting {len(variables)} variables to CSV...")

    # Generate basic CSV with validation phrases
    with open(output_csv, "w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "variable_id", 
            "domain", 
            "concepts", 
            "question_text",
            "validation_phrase",
            "validation_phrase_occurrences",
            "validation_phrase_score"
        ])

        for var in variables:
            concepts_str = ", ".join(var.get("concepts", []))
            writer.writerow(
                [
                    var["variable_id"],
                    var.get("domain", "Unknown"),
                    concepts_str,
                    var["question_text"],
                    var.get("validation_phrase", ""),
                    var.get("validation_phrase_occurrences", 0),
                    var.get("validation_phrase_score", 0.0),
                ]
            )

    print(f"✅ Basic CSV saved to {output_csv}")

    # Generate detailed CSV with value labels and validation phrases
    with open(output_detailed_csv, "w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerow([
            "variable_id", 
            "domain", 
            "concepts", 
            "question_text", 
            "value_labels",
            "validation_phrase",
            "validation_phrase_occurrences",
            "validation_phrase_score"
        ])

        for var in variables:
            concepts_str = ", ".join(var.get("concepts", []))

            # Format value labels as "value=label; value=label; ..."
            value_labels = var.get("value_labels", [])
            labels_str = "; ".join(
                [f"{vl['value']}={vl['label']}" for vl in value_labels]
            )

            writer.writerow(
                [
                    var["variable_id"],
                    var.get("domain", "Unknown"),
                    concepts_str,
                    var["question_text"],
                    labels_str,
                    var.get("validation_phrase", ""),
                    var.get("validation_phrase_occurrences", 0),
                    var.get("validation_phrase_score", 0.0),
                ]
            )

    print(f"✅ Detailed CSV saved to {output_detailed_csv}")


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print(
            "Usage: python generate_csv.py <enriched_json> <output_csv> <output_detailed_csv>"
        )
        print(
            "Example: python generate_csv.py W5_enriched.json W5_concepts.csv W5_concepts_detailed.csv"
        )
        sys.exit(1)

    enriched_json = sys.argv[1]
    output_csv = sys.argv[2]
    output_detailed_csv = sys.argv[3]

    json_to_csv(enriched_json, output_csv, output_detailed_csv)
