#!/usr/bin/env python3
"""
Asian Barometer Question Semantic Matching System

Uses sentence-transformers embeddings + FAISS for fast similarity search
to identify matching questions across waves.

Thresholds:
- ≥0.85: Auto-accept (high confidence match)
- 0.75-0.85: Manual review needed
- <0.75: Low confidence (likely different questions)
"""

import json
from pathlib import Path
from collections import defaultdict
from datetime import datetime
from sentence_transformers import SentenceTransformer
import faiss


class QuestionMatcher:
    """Semantic matching engine for cross-wave question comparison."""

    def __init__(self, model_name="all-MiniLM-L6-v2"):
        """Initialize with sentence transformer model."""
        print(f"Loading sentence transformer model: {model_name}")
        self.model = SentenceTransformer(model_name)
        self.questions = []  # List of (wave, var_id, question_text, concepts)
        self.embeddings = None
        self.index = None
        self.validation_phrases = {}

    def load_validation_phrases(self, filepath="validation_phrases_improved.json"):
        """Load validation phrases for secondary verification."""
        print(f"\nLoading validation phrases from {filepath}")
        with open(filepath, "r") as f:
            data = json.load(f)

        # Extract phrases by wave and variable
        for wave, wave_data in data.items():
            if wave.startswith("W"):
                for var_id, phrase_info in wave_data.get("questions", {}).items():
                    key = f"{wave}_{var_id}"
                    self.validation_phrases[key] = phrase_info.get(
                        "validation_phrase", ""
                    )

        print(f"  Loaded {len(self.validation_phrases)} validation phrases")

    def load_crosswalk(self, wave_name, filepath):
        """Load questions from a wave's crosswalk JSON."""
        print(f"\nLoading {wave_name} from {filepath}")
        with open(filepath, "r") as f:
            data = json.load(f)

        count = 0
        for domain_name, domain_data in data.items():
            concepts = domain_data.get("concepts", [])
            for concept in concepts:
                for question in concept.get("questions", []):
                    var_id = question.get("variable_id", "")
                    question_text = question.get("question_text", "")
                    concept_name = concept.get("concept_name", "")

                    if question_text:
                        self.questions.append(
                            {
                                "wave": wave_name,
                                "var_id": var_id,
                                "question_text": question_text,
                                "concept": concept_name,
                                "domain": domain_name,
                            }
                        )
                        count += 1

        print(f"  Loaded {count} questions from {wave_name}")
        return count

    def build_embeddings(self):
        """Generate embeddings for all questions."""
        print(f"\n{'=' * 60}")
        print("Building embeddings for all questions")
        print(f"{'=' * 60}")

        texts = [q["question_text"] for q in self.questions]

        print(f"Encoding {len(texts)} questions...")
        self.embeddings = self.model.encode(
            texts, convert_to_numpy=True, show_progress_bar=True
        )

        print(f"✓ Generated embeddings: shape {self.embeddings.shape}")

    def build_faiss_index(self):
        """Build FAISS index for fast similarity search."""
        print("\nBuilding FAISS index...")

        # Normalize embeddings for cosine similarity
        faiss.normalize_L2(self.embeddings)

        # Create index
        dimension = self.embeddings.shape[1]
        self.index = faiss.IndexFlatIP(dimension)  # Inner product = cosine similarity
        self.index.add(self.embeddings)

        print(f"✓ FAISS index built with {self.index.ntotal} vectors")

    def find_matches(self, top_k=10):
        """Find similar questions across waves for each question."""
        print(f"\n{'=' * 60}")
        print("Finding cross-wave matches")
        print(f"{'=' * 60}")

        matches = []

        for idx, question in enumerate(self.questions):
            # Search for similar questions
            query_embedding = self.embeddings[idx : idx + 1]
            similarities, indices = self.index.search(query_embedding, top_k + 1)

            # Skip first result (self-match)
            for sim, match_idx in zip(similarities[0][1:], indices[0][1:]):
                match = self.questions[match_idx]

                # Only consider cross-wave matches
                if match["wave"] != question["wave"]:
                    # Check validation phrase match
                    phrase_match = self._check_phrase_match(
                        question["wave"],
                        question["var_id"],
                        match["wave"],
                        match["var_id"],
                    )

                    matches.append(
                        {
                            "wave1": question["wave"],
                            "var1": question["var_id"],
                            "question1": question["question_text"],
                            "concept1": question["concept"],
                            "domain1": question["domain"],
                            "wave2": match["wave"],
                            "var2": match["var_id"],
                            "question2": match["question_text"],
                            "concept2": match["concept"],
                            "domain2": match["domain"],
                            "similarity": float(sim),
                            "phrase_match": phrase_match,
                        }
                    )

        print(f"✓ Generated {len(matches)} potential cross-wave matches")
        return matches

    def _check_phrase_match(self, wave1, var1, wave2, var2):
        """Check if validation phrases match between two questions."""
        key1 = f"{wave1}_{var1}"
        key2 = f"{wave2}_{var2}"

        phrase1 = self.validation_phrases.get(key1, "").lower()
        phrase2 = self.validation_phrases.get(key2, "").lower()

        if phrase1 and phrase2:
            # Check if phrases overlap
            words1 = set(phrase1.split())
            words2 = set(phrase2.split())
            overlap = (
                len(words1 & words2) / max(len(words1), len(words2))
                if words1 and words2
                else 0
            )
            return overlap > 0.5

        return False

    def categorize_matches(self, matches):
        """Categorize matches by similarity threshold."""
        auto_accept = []
        manual_review = []
        low_confidence = []

        for match in matches:
            sim = match["similarity"]
            if sim >= 0.85:
                auto_accept.append(match)
            elif sim >= 0.75:
                manual_review.append(match)
            else:
                low_confidence.append(match)

        # Remove duplicates (same pair appearing twice in different order)
        auto_accept = self._deduplicate_pairs(auto_accept)
        manual_review = self._deduplicate_pairs(manual_review)

        return {
            "auto_accept": auto_accept,
            "manual_review": manual_review,
            "low_confidence": low_confidence,
        }

    def _deduplicate_pairs(self, matches):
        """Remove duplicate pairs (A→B and B→A)."""
        seen = set()
        unique = []

        for match in matches:
            # Create canonical pair key (sorted)
            pair = tuple(
                sorted(
                    [(match["wave1"], match["var1"]), (match["wave2"], match["var2"])]
                )
            )

            if pair not in seen:
                seen.add(pair)
                unique.append(match)

        return unique


def generate_detailed_report(categorized, output_path):
    """Generate detailed match report with all question pairs."""
    print(f"\nGenerating detailed report: {output_path}")

    with open(output_path, "w") as f:
        f.write("# Asian Barometer Cross-Wave Question Matching Report\n\n")
        f.write(f"**Generated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write("---\n\n")

        # Auto-accept matches
        f.write("## High Confidence Matches (≥0.85 similarity)\n\n")
        f.write(
            f"**Count**: {len(categorized['auto_accept'])} unique question pairs\n\n"
        )

        for i, match in enumerate(
            sorted(
                categorized["auto_accept"], key=lambda x: x["similarity"], reverse=True
            ),
            1,
        ):
            f.write(f"### Match {i}: Similarity {match['similarity']:.3f}\n\n")
            f.write(f"**Wave 1**: {match['wave1']} - {match['var1']}\n")
            f.write(f"- Question: {match['question1']}\n")
            f.write(f"- Concept: {match['concept1']}\n")
            f.write(f"- Domain: {match['domain1']}\n\n")

            f.write(f"**Wave 2**: {match['wave2']} - {match['var2']}\n")
            f.write(f"- Question: {match['question2']}\n")
            f.write(f"- Concept: {match['concept2']}\n")
            f.write(f"- Domain: {match['domain2']}\n\n")

            if match["phrase_match"]:
                f.write("✓ Validation phrases match\n\n")
            else:
                f.write("⚠ Validation phrases differ\n\n")

            f.write("---\n\n")

        # Manual review matches
        f.write("\n## Manual Review Required (0.75-0.85 similarity)\n\n")
        f.write(
            f"**Count**: {len(categorized['manual_review'])} unique question pairs\n\n"
        )

        for i, match in enumerate(
            sorted(
                categorized["manual_review"],
                key=lambda x: x["similarity"],
                reverse=True,
            ),
            1,
        ):
            f.write(f"### Review {i}: Similarity {match['similarity']:.3f}\n\n")
            f.write(
                f"**{match['wave1']}.{match['var1']}** ↔ **{match['wave2']}.{match['var2']}**\n\n"
            )
            f.write(f"Q1: {match['question1'][:100]}...\n\n")
            f.write(f"Q2: {match['question2'][:100]}...\n\n")
            f.write("---\n\n")

    print("✓ Detailed report saved")


def generate_summary_statistics(categorized, all_questions, output_path):
    """Generate summary statistics report."""
    print(f"Generating summary statistics: {output_path}")

    total_questions = len(all_questions)

    # Count unique questions involved in each category
    auto_vars = set()
    manual_vars = set()

    for match in categorized["auto_accept"]:
        auto_vars.add((match["wave1"], match["var1"]))
        auto_vars.add((match["wave2"], match["var2"]))

    for match in categorized["manual_review"]:
        manual_vars.add((match["wave1"], match["var1"]))
        manual_vars.add((match["wave2"], match["var2"]))

    # Questions with no good matches
    all_vars = {(q["wave"], q["var_id"]) for q in all_questions}
    matched_vars = auto_vars | manual_vars
    unmatched_vars = all_vars - matched_vars

    with open(output_path, "w") as f:
        f.write("# Asian Barometer Question Matching - Summary Statistics\n\n")
        f.write(f"**Generated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write("---\n\n")

        f.write("## Overall Statistics\n\n")
        f.write(f"- **Total questions analyzed**: {total_questions}\n")
        f.write(
            f"- **Unique question pairs identified**: {len(categorized['auto_accept']) + len(categorized['manual_review'])}\n\n"
        )

        f.write("## Match Quality Distribution\n\n")
        f.write("| Category | Pair Count | % of Total Pairs |\n")
        f.write("|----------|------------|------------------|\n")

        total_pairs = len(categorized["auto_accept"]) + len(
            categorized["manual_review"]
        )

        auto_pct = (
            100 * len(categorized["auto_accept"]) / total_pairs
            if total_pairs > 0
            else 0
        )
        manual_pct = (
            100 * len(categorized["manual_review"]) / total_pairs
            if total_pairs > 0
            else 0
        )

        f.write(
            f"| High confidence (≥0.85) | {len(categorized['auto_accept'])} | {auto_pct:.1f}% |\n"
        )
        f.write(
            f"| Manual review (0.75-0.85) | {len(categorized['manual_review'])} | {manual_pct:.1f}% |\n"
        )
        f.write("| Low confidence (<0.75) | Not reported | - |\n\n")

        f.write("## Question Coverage\n\n")
        f.write("| Category | Question Count | % of Total Questions |\n")
        f.write("|----------|----------------|----------------------|\n")

        auto_q_pct = 100 * len(auto_vars) / total_questions
        manual_q_pct = 100 * len(manual_vars) / total_questions
        unmatched_pct = 100 * len(unmatched_vars) / total_questions

        f.write(
            f"| Questions in high-conf matches | {len(auto_vars)} | {auto_q_pct:.1f}% |\n"
        )
        f.write(
            f"| Questions in manual review | {len(manual_vars)} | {manual_q_pct:.1f}% |\n"
        )
        f.write(
            f"| Questions with no good match | {len(unmatched_vars)} | {unmatched_pct:.1f}% |\n\n"
        )

        # Per-wave breakdown
        f.write("## Questions by Wave\n\n")
        wave_counts = defaultdict(int)
        for q in all_questions:
            wave_counts[q["wave"]] += 1

        f.write("| Wave | Total Questions |\n")
        f.write("|------|----------------|\n")
        for wave in sorted(wave_counts.keys()):
            f.write(f"| {wave} | {wave_counts[wave]} |\n")

        f.write("\n## Match Distribution by Wave Pair\n\n")
        pair_counts = defaultdict(int)
        for match in categorized["auto_accept"] + categorized["manual_review"]:
            pair = tuple(sorted([match["wave1"], match["wave2"]]))
            pair_counts[pair] += 1

        f.write("| Wave Pair | Match Count |\n")
        f.write("|-----------|-------------|\n")
        for pair in sorted(pair_counts.keys()):
            f.write(f"| {pair[0]} ↔ {pair[1]} | {pair_counts[pair]} |\n")

    print("✓ Summary statistics saved")


def main():
    """Main execution."""
    print("\n" + "=" * 60)
    print("Asian Barometer Semantic Question Matcher")
    print("=" * 60)

    # Initialize matcher
    matcher = QuestionMatcher()

    # Load validation phrases
    matcher.load_validation_phrases()

    # Load all crosswalk files
    waves = ["W1", "W2", "W3", "W4", "W5", "W6_Cambodia"]
    for wave in waves:
        filepath = f"{wave}_crosswalk.json"
        if Path(filepath).exists():
            matcher.load_crosswalk(wave, filepath)
        else:
            print(f"⚠ Warning: {filepath} not found, skipping")

    print(f"\n{'=' * 60}")
    print(f"Total questions loaded: {len(matcher.questions)}")
    print(f"{'=' * 60}")

    # Build embeddings and index
    matcher.build_embeddings()
    matcher.build_faiss_index()

    # Find matches
    all_matches = matcher.find_matches(top_k=10)

    # Categorize by threshold
    categorized = matcher.categorize_matches(all_matches)

    print(f"\n{'=' * 60}")
    print("Match Categorization Results")
    print(f"{'=' * 60}")
    print(f"  High confidence (≥0.85): {len(categorized['auto_accept'])} pairs")
    print(f"  Manual review (0.75-0.85): {len(categorized['manual_review'])} pairs")
    print(
        f"  Low confidence (<0.75): {len(categorized['low_confidence'])} pairs (not reported)"
    )

    # Generate reports
    output_dir = Path("matching_results")
    output_dir.mkdir(exist_ok=True)

    detailed_path = output_dir / "question_matches_detailed.md"
    summary_path = output_dir / "question_matches_summary.md"

    generate_detailed_report(categorized, detailed_path)
    generate_summary_statistics(categorized, matcher.questions, summary_path)

    print(f"\n{'=' * 60}")
    print("✓ Complete! Reports generated:")
    print(f"  - {detailed_path}")
    print(f"  - {summary_path}")
    print(f"{'=' * 60}\n")


if __name__ == "__main__":
    main()
