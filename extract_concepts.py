"""
Stage 2: Atomic JSON → Concept/Domain Extraction

This script:
1. Reads atomic JSON from Stage 1
2. Groups questions by conceptual domains
3. Extracts concepts for crosswalk generation
"""

import os
import json
from typing import List, Dict
from groq import Groq


class ConceptExtractor:
    """Extract concepts and domains from atomic questions"""

    def __init__(self, model="llama-3.3-70b-versatile"):
        """
        Initialize with Groq API.

        Models available:
        - llama-3.3-70b-versatile (best quality, recommended)
        - llama-3.1-8b-instant (faster, good quality)
        - mixtral-8x7b-32768 (alternative)
        """
        api_key = os.getenv("GROQ_API_KEY")
        if not api_key:
            raise ValueError("GROQ_API_KEY environment variable not set. Get your free key at: https://console.groq.com")

        self.client = Groq(api_key=api_key)
        self.model = model

    def extract_concepts_batch(self, variables: List[Dict], batch_size: int = 10) -> List[Dict]:
        """
        Extract concepts from a batch of variables.
        Returns enriched variables with concept/domain annotations.
        """
        enriched = []

        for i in range(0, len(variables), batch_size):
            batch = variables[i:i + batch_size]
            print(f"  Processing batch {i//batch_size + 1} ({len(batch)} questions)...")

            try:
                concepts = self._extract_batch_concepts(batch)
                enriched.extend(concepts)
            except Exception as e:
                print(f"    Error processing batch: {e}")
                # Fallback: add empty concepts
                for var in batch:
                    var_copy = var.copy()
                    var_copy['concepts'] = []
                    var_copy['domain'] = "Unknown"
                    enriched.append(var_copy)

        return enriched

    def _extract_batch_concepts(self, variables: List[Dict]) -> List[Dict]:
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


def generate_crosswalk(enriched_variables: List[Dict], output_file: str):
    """
    Generate a crosswalk mapping from enriched variables.
    Groups variables by domain and concepts.
    """

    # Group by domain
    domain_groups = {}
    for var in enriched_variables:
        domain = var.get('domain', 'Unknown')
        if domain not in domain_groups:
            domain_groups[domain] = []
        domain_groups[domain].append(var)

    crosswalk = {
        "metadata": {
            "total_variables": len(enriched_variables),
            "total_domains": len(domain_groups)
        },
        "domains": []
    }

    for domain, vars_list in sorted(domain_groups.items()):
        domain_entry = {
            "domain": domain,
            "variable_count": len(vars_list),
            "variables": [
                {
                    "variable_id": v['variable_id'],
                    "question_text": v['question_text'],
                    "concepts": v.get('concepts', []),
                    "value_labels": v['value_labels']
                }
                for v in vars_list
            ]
        }
        crosswalk["domains"].append(domain_entry)

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(crosswalk, f, indent=2, ensure_ascii=False)

    print(f"\nCrosswalk saved to {output_file}")
    print(f"  Total domains: {len(domain_groups)}")
    for domain, vars_list in sorted(domain_groups.items()):
        print(f"    {domain}: {len(vars_list)} variables")


def main(atomic_json_file: str, enriched_output: str, crosswalk_output: str):
    """Main pipeline: Atomic JSON → Concepts → Crosswalk"""

    print(f"Loading atomic JSON from {atomic_json_file}...")
    with open(atomic_json_file, 'r', encoding='utf-8') as f:
        variables = json.load(f)
    print(f"Loaded {len(variables)} variables")

    print("\nExtracting concepts and domains...")
    extractor = ConceptExtractor()
    enriched = extractor.extract_concepts_batch(variables, batch_size=10)

    print(f"\nSaving enriched variables to {enriched_output}...")
    with open(enriched_output, 'w', encoding='utf-8') as f:
        json.dump(enriched, f, indent=2, ensure_ascii=False)

    print("\nGenerating crosswalk...")
    generate_crosswalk(enriched, crosswalk_output)

    print("\n✅ Pipeline complete!")
    print(f"  Atomic JSON: {atomic_json_file}")
    print(f"  Enriched: {enriched_output}")
    print(f"  Crosswalk: {crosswalk_output}")


if __name__ == "__main__":
    atomic_json = "W6_Cambodia_analyzed.json"
    enriched_output = "W6_Cambodia_enriched.json"
    crosswalk_output = "W6_Cambodia_crosswalk.json"
    main(atomic_json, enriched_output, crosswalk_output)