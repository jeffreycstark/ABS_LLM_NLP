"""
Stage 2: Atomic JSON → Concept/Domain Extraction

This script:
1. Reads atomic JSON from Stage 1
2. Groups questions by conceptual domains
3. Extracts concepts for crosswalk generation
4. Adds validation phrases for R pattern matching
"""

import os
import json
import re
from typing import List, Dict, Tuple
from groq import Groq


# ============================================================================
# Validation Phrase Extraction Functions
# ============================================================================


def normalize_text(text: str) -> str:
    """Normalize text for comparison."""
    text = text.lower()
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def extract_ngrams(text: str, min_n: int = 3, max_n: int = 6) -> List[Tuple[str, int]]:
    """Extract all n-grams from text with their lengths.
    
    Prioritizes longer phrases (3-6 words) which are more specific and distinctive.
    """
    words = text.split()
    ngrams = []
    # Process in reverse order to try longer phrases first
    for n in range(max_n, min_n - 1, -1):
        for i in range(len(words) - n + 1):
            ngram = " ".join(words[i : i + n])
            ngrams.append((ngram, n))
    return ngrams


def is_too_generic(phrase: str) -> bool:
    """Check if a phrase is too generic to be useful."""
    generic_words = {
        "the", "is", "are", "was", "were", "be", "been", "being",
        "do", "does", "did", "doing", "done", "have", "has", "had", "having",
        "you", "your", "yours", "this", "that", "these", "those",
        "of", "to", "in", "for", "on", "at", "by", "with", "from",
        "a", "an", "and", "or", "but", "if", "so", "would", "could", "should",
        "may", "might", "will", "shall", "can", "about", "some", "any", "all",
        "more", "most", "much", "many", "very", "just", "now", "then", "here",
        "there", "where", "when", "what", "who", "which", "how", "why",
        "like", "such", "than", "only", "also", "even", "well", "still",
        "say", "said", "tell", "told", "ask", "asked", "think", "thought",
        "know", "knew", "want", "wanted", "let", "let's", "please", "thank"
    }
    
    # Generic survey phrases that should be rejected
    generic_phrases = {
        "let's talk", "tell me", "would you say", "do you think",
        "how much", "how many", "please tell", "would you", "could you",
        "can you", "what do", "what is", "what are", "how do", "how is",
        "in your", "to what", "on a scale", "the following", "in the",
        "of the", "to the", "for the", "with the", "from the", "about the",
        "you think", "you feel", "you believe", "you agree", "you would",
        "agree or disagree", "strongly agree", "somewhat agree"
    }
    
    phrase_lower = phrase.lower().strip()
    
    # Check if it's a generic survey phrase
    if phrase_lower in generic_phrases:
        return True
    
    words = phrase_lower.split()
    
    # Reject if all words are generic
    if all(w in generic_words for w in words):
        return True
    
    # Reject if >70% of words are generic (for longer phrases)
    if len(words) >= 3:
        generic_count = sum(1 for w in words if w in generic_words)
        if generic_count / len(words) > 0.7:
            return True
    
    return False


def score_phrase(phrase: str, occurrences: int, phrase_length: int) -> float:
    """Score a validation phrase based on uniqueness, length, and content."""
    if occurrences == 0:
        return 0.0

    # Uniqueness score (exponential penalty for multiple occurrences)
    uniqueness_score = 100.0 / (occurrences ** 1.5)

    # Length score (optimal around 3-5 words)
    length_scores = {1: 0.3, 2: 0.7, 3: 1.0, 4: 1.0, 5: 1.0, 6: 0.8}
    length_score = length_scores.get(phrase_length, 0.6)

    # Generic penalty
    if is_too_generic(phrase):
        return 0.0  # Completely reject generic phrases

    # Content quality bonus
    words = phrase.lower().split()
    filler_words = {"the", "a", "an", "to", "of", "in", "for", "on", "at", "by", "with"}
    
    # Bonus for starting with substantive word (not filler)
    start_bonus = 1.2 if words[0] not in filler_words else 1.0
    
    # Bonus for ending with substantive word
    end_bonus = 1.1 if words[-1] not in filler_words else 1.0
    
    # Bonus for containing capitalized words (proper nouns, acronyms)
    capitalized_bonus = 1.2 if any(w[0].isupper() for w in phrase.split()) else 1.0

    return uniqueness_score * length_score * start_bonus * end_bonus * capitalized_bonus


def find_best_validation_phrase(
    question_text: str, all_questions: List[str]
) -> Tuple[str, int, float]:
    """
    Find the best validation phrase for a question.
    Returns (phrase, occurrences, quality_score).
    """
    question_text = normalize_text(question_text)
    normalized_questions = [normalize_text(q) for q in all_questions]

    # Extract all possible n-grams (3-6 words for better specificity)
    ngrams = extract_ngrams(question_text, min_n=3, max_n=6)
    
    # If text is too short for 3-word phrases, try 2-word phrases
    if len(question_text.split()) < 3:
        ngrams = extract_ngrams(question_text, min_n=2, max_n=6)

    # Score each n-gram
    candidates = []
    for ngram, length in ngrams:
        if is_too_generic(ngram):
            continue

        # Count occurrences
        occurrences = sum(1 for q in normalized_questions if ngram in q)

        # Score the phrase
        score = score_phrase(ngram, occurrences, length)

        candidates.append({
            "phrase": ngram,
            "occurrences": occurrences,
            "length": length,
            "score": score
        })

    # Sort by score (highest first)
    candidates.sort(key=lambda x: x["score"], reverse=True)

    if candidates:
        best = candidates[0]
        return (best["phrase"], best["occurrences"], best["score"])

    # Fallback: try to find any unique word
    words = question_text.split()
    for word in words:
        if len(word) >= 6 and not is_too_generic(word):
            occurrences = sum(1 for q in normalized_questions if word in q)
            if occurrences <= 2:
                return (word, occurrences, 50.0)

    # Last resort
    if words:
        fallback = " ".join(words[:3])
        occurrences = sum(1 for q in normalized_questions if fallback in q)
        return (fallback, occurrences, 10.0)

    return ("", 0, 0.0)


def add_validation_phrases(variables: List[Dict]) -> List[Dict]:
    """Add validation phrases to all variables."""
    print("\nAdding validation phrases...")

    # Get all question texts
    all_question_texts = [v.get("question_text", "") for v in variables]

    # Find best validation phrase for each variable
    for var in variables:
        q_text = var.get("question_text", "")
        if q_text:
            phrase, occurrences, score = find_best_validation_phrase(
                q_text, all_question_texts
            )
            var["validation_phrase"] = phrase
            var["validation_phrase_occurrences"] = occurrences
            var["validation_phrase_score"] = score
        else:
            var["validation_phrase"] = ""
            var["validation_phrase_occurrences"] = 0
            var["validation_phrase_score"] = 0.0

    # Print summary
    unique_count = sum(1 for v in variables if v.get("validation_phrase_occurrences", 0) == 1)
    acceptable_count = sum(1 for v in variables if v.get("validation_phrase_occurrences", 0) <= 2)
    print(f"  Unique phrases (1 question): {unique_count}")
    print(f"  Acceptable phrases (≤2 questions): {acceptable_count}")
    print(f"  Coverage: {acceptable_count / len(variables) * 100:.1f}%")

    return variables


# ============================================================================
# Concept Extraction Class
# ============================================================================


class ConceptExtractor:
    """Extract concepts and domains from atomic questions"""

    def __init__(self, model="llama-3.1-8b-instant"):
        """
        Initialize with Groq API.

        Models available:
        - llama-3.1-8b-instant (faster, lower token usage, default)
        - llama-3.3-70b-versatile (best quality, higher token usage)
        - mixtral-8x7b-32768 (alternative)
        """
        api_key = os.getenv("GROQ_API_KEY")
        if not api_key:
            raise ValueError(
                "GROQ_API_KEY environment variable not set. Get your free key at: https://console.groq.com"
            )

        self.client = Groq(api_key=api_key)
        self.model = model

    def extract_concepts_batch(
        self, variables: List[Dict], batch_size: int = 10
    ) -> List[Dict]:
        """
        Extract concepts from a batch of variables.
        Returns enriched variables with concept/domain annotations.
        """
        enriched = []

        for i in range(0, len(variables), batch_size):
            batch = variables[i : i + batch_size]
            print(
                f"  Processing batch {i // batch_size + 1} ({len(batch)} questions)..."
            )

            try:
                concepts = self._extract_batch_concepts(batch)
                enriched.extend(concepts)
            except Exception as e:
                print(f"    Error processing batch: {e}")
                # Fallback: add empty concepts
                for var in batch:
                    var_copy = var.copy()
                    var_copy["concepts"] = []
                    var_copy["domain"] = "Unknown"
                    enriched.append(var_copy)

        return enriched

    def _extract_batch_concepts(self, variables: List[Dict]) -> List[Dict]:
        """Extract concepts for a batch of variables using LLM"""

        # Build prompt with questions
        questions_text = []
        for i, var in enumerate(variables):
            questions_text.append(
                f"{i + 1}. [{var['variable_id']}] {var['question_text']}"
            )

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
                "content": "You are an expert in survey methodology and concept extraction.",
            },
            {"role": "user", "content": prompt},
        ]

        response = self.client.chat.completions.create(
            model=self.model,
            messages=messages,
            max_tokens=2048,
            temperature=0.3,
        )

        content = response.choices[0].message.content
        # Remove markdown if present
        content = content.replace("```json", "").replace("```", "").strip()

        concepts_list = json.loads(content)

        # Merge with original variables
        enriched = []
        for var in variables:
            var_copy = var.copy()
            # Find matching concept entry
            matching = next(
                (
                    c
                    for c in concepts_list
                    if c.get("variable_id") == var["variable_id"]
                ),
                None,
            )
            if matching:
                var_copy["domain"] = matching.get("domain", "Unknown")
                var_copy["concepts"] = matching.get("concepts", [])
            else:
                var_copy["domain"] = "Unknown"
                var_copy["concepts"] = []

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
        domain = var.get("domain", "Unknown")
        if domain not in domain_groups:
            domain_groups[domain] = []
        domain_groups[domain].append(var)

    crosswalk = {
        "metadata": {
            "total_variables": len(enriched_variables),
            "total_domains": len(domain_groups),
        },
        "domains": [],
    }

    for domain, vars_list in sorted(domain_groups.items()):
        domain_entry = {
            "domain": domain,
            "variable_count": len(vars_list),
            "variables": [
                {
                    "variable_id": v["variable_id"],
                    "question_text": v["question_text"],
                    "concepts": v.get("concepts", []),
                    "value_labels": v["value_labels"],
                }
                for v in vars_list
            ],
        }
        crosswalk["domains"].append(domain_entry)

    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(crosswalk, f, indent=2, ensure_ascii=False)

    print(f"\nCrosswalk saved to {output_file}")
    print(f"  Total domains: {len(domain_groups)}")
    for domain, vars_list in sorted(domain_groups.items()):
        print(f"    {domain}: {len(vars_list)} variables")


def main(atomic_json_file: str, enriched_output: str, crosswalk_output: str):
    """Main pipeline: Atomic JSON → Concepts → Crosswalk"""

    print(f"Loading atomic JSON from {atomic_json_file}...")
    with open(atomic_json_file, "r", encoding="utf-8") as f:
        variables = json.load(f)
    print(f"Loaded {len(variables)} variables")

    print("\nExtracting concepts and domains...")
    extractor = ConceptExtractor()
    enriched = extractor.extract_concepts_batch(variables, batch_size=10)

    # Add validation phrases for R pattern matching
    enriched = add_validation_phrases(enriched)

    print(f"\nSaving enriched variables to {enriched_output}...")
    with open(enriched_output, "w", encoding="utf-8") as f:
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
