"""
Reprocess Unknown variables using faster llama-3.1-8b-instant model
"""

import os
import json
from typing import List, Dict
from groq import Groq


class ConceptReprocessor:
    """Reprocess Unknown variables with a different model"""

    def __init__(self, model="llama-3.1-8b-instant"):
        api_key = os.getenv("GROQ_API_KEY")
        if not api_key:
            raise ValueError("GROQ_API_KEY environment variable not set")

        self.client = Groq(api_key=api_key)
        self.model = model
        print(f"Using model: {model}")

    def extract_batch_concepts(self, variables: List[Dict]) -> List[Dict]:
        """Extract concepts for a batch of variables using LLM"""

        # Build prompt with questions
        questions_text = []
        for i, var in enumerate(variables):
            questions_text.append(f"{i+1}. [{var['variable_id']}] {var['question_text']}")

        prompt = f"""Analyze these survey questions and identify:
1. The primary DOMAIN/TOPIC (e.g., "Economic Perception", "Trust in Government", "Service Accessibility")
2. Key CONCEPTS for each question (e.g., ["economic condition", "evaluation", "temporal comparison"])

Questions:
{chr(10).join(questions_text)}

Return a JSON array with this structure:
[
  {{
    "variable_id": "q1",
    "domain": "Economic Perception",
    "concepts": ["economic condition", "national level", "current evaluation"]
  }},
  ...
]

Return ONLY valid JSON, no markdown."""

        messages = [
            {
                "role": "system",
                "content": "You are an expert in survey methodology and concept extraction."
            },
            {
                "role": "user",
                "content": prompt
            }
        ]

        response = self.client.chat.completions.create(
            model=self.model,
            messages=messages,
            max_tokens=2048,
            temperature=0.3,
        )

        content = response.choices[0].message.content
        # Remove markdown if present
        content = content.replace('```json', '').replace('```', '').strip()

        concepts_list = json.loads(content)

        # Merge with original variables
        enriched = []
        for var in variables:
            var_copy = var.copy()
            # Find matching concept entry
            matching = next((c for c in concepts_list if c.get('variable_id') == var['variable_id']), None)
            if matching:
                var_copy['domain'] = matching.get('domain', 'Unknown')
                var_copy['concepts'] = matching.get('concepts', [])
            else:
                var_copy['domain'] = 'Unknown'
                var_copy['concepts'] = []

            enriched.append(var_copy)

        return enriched

    def reprocess_unknown(self, enriched_file: str, batch_size: int = 10) -> List[Dict]:
        """
        Load enriched JSON, find Unknown variables, reprocess them
        """
        print(f"\nLoading {enriched_file}...")
        with open(enriched_file, 'r', encoding='utf-8') as f:
            all_variables = json.load(f)

        # Find Unknown variables
        unknown_vars = [v for v in all_variables if v.get('domain') == 'Unknown']
        print(f"Found {len(unknown_vars)} Unknown variables to reprocess")

        if not unknown_vars:
            print("No Unknown variables found!")
            return all_variables

        # Reprocess in batches
        reprocessed = []
        for i in range(0, len(unknown_vars), batch_size):
            batch = unknown_vars[i:i + batch_size]
            batch_num = i // batch_size + 1
            print(f"  Processing batch {batch_num}/{(len(unknown_vars)-1)//batch_size + 1} ({len(batch)} questions)...")

            try:
                enriched_batch = self.extract_batch_concepts(batch)
                reprocessed.extend(enriched_batch)

                # Show sample results
                for v in enriched_batch[:2]:
                    print(f"    ✓ {v['variable_id']}: {v.get('domain', 'Unknown')}")

            except Exception as e:
                print(f"    ✗ Error: {e}")
                # Keep as Unknown
                reprocessed.extend(batch)

        # Merge reprocessed back into original list
        # Create lookup dict
        reprocessed_dict = {v['variable_id']: v for v in reprocessed}

        # Update original list
        final_variables = []
        updated_count = 0
        for var in all_variables:
            if var['variable_id'] in reprocessed_dict:
                final_variables.append(reprocessed_dict[var['variable_id']])
                if reprocessed_dict[var['variable_id']].get('domain') != 'Unknown':
                    updated_count += 1
            else:
                final_variables.append(var)

        print(f"\n✅ Reprocessed {len(unknown_vars)} variables")
        print(f"   Successfully updated: {updated_count}")
        print(f"   Still Unknown: {len(unknown_vars) - updated_count}")

        return final_variables


def regenerate_outputs(enriched_variables: List[Dict], base_name: str):
    """Regenerate enriched JSON, crosswalk JSON, and CSV files"""

    enriched_file = f"{base_name}_enriched.json"
    crosswalk_file = f"{base_name}_crosswalk.json"
    csv_file = f"{base_name}_concepts.csv"
    csv_detailed_file = f"{base_name}_concepts_detailed.csv"

    # Save enriched JSON
    print(f"\nSaving {enriched_file}...")
    with open(enriched_file, 'w', encoding='utf-8') as f:
        json.dump(enriched_variables, f, indent=2, ensure_ascii=False)

    # Generate crosswalk
    print(f"Generating {crosswalk_file}...")
    from extract_concepts import generate_crosswalk
    generate_crosswalk(enriched_variables, crosswalk_file)

    # Generate CSVs
    print(f"Generating CSV files...")
    import subprocess
    subprocess.run([
        'python3', 'generate_csv.py',
        enriched_file, csv_file, csv_detailed_file
    ])

    print(f"\n✅ All files updated!")


def main(enriched_file: str, base_name: str, model: str = "llama-3.1-8b-instant"):
    """Main reprocessing pipeline"""

    print(f"{'='*60}")
    print(f"Reprocessing Unknown variables from {enriched_file}")
    print(f"Using model: {model}")
    print(f"{'='*60}")

    reprocessor = ConceptReprocessor(model=model)
    final_variables = reprocessor.reprocess_unknown(enriched_file, batch_size=10)

    regenerate_outputs(final_variables, base_name)


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python reprocess_unknown.py <base_name> [model]")
        print("Example: python reprocess_unknown.py W5")
        print("         python reprocess_unknown.py W5 llama-3.1-8b-instant")
        sys.exit(1)

    base_name = sys.argv[1]
    model = sys.argv[2] if len(sys.argv) > 2 else "llama-3.1-8b-instant"

    enriched_file = f"{base_name}_enriched.json"
    main(enriched_file, base_name, model)