#!/usr/bin/env python3
"""
Asian Barometer Question Semantic Matching System - FULL CORPUS

Runs on complete dataset across all 6 waves.
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
        self.questions = []
        self.embeddings = None
        self.index = None
        self.validation_phrases = {}

    def load_validation_phrases(self, filepath="validation_phrases_improved.json"):
        """Load validation phrases for secondary verification."""
        print(f"\nLoading validation phrases from {filepath}")
        try:
            with open(filepath, "r") as f:
                data = json.load(f)

            for wave, wave_data in data.items():
                if wave.startswith("W"):
                    for var_id, phrase_info in wave_data.get("questions", {}).items():
                        key = f"{wave}_{var_id}"
                        self.validation_phrases[key] = phrase_info.get(
                            "validation_phrase", ""
                        )

            print(f"  ✓ Loaded {len(self.validation_phrases)} validation phrases")
        except Exception as e:
            print(f"  ⚠ Warning: Could not load validation phrases: {e}")

    def load_crosswalk(self, wave_name, filepath):
        """Load questions from a wave's crosswalk JSON."""
        print(f"\nLoading {wave_name} from {filepath}")
        try:
            with open(filepath, "r") as f:
                data = json.load(f)

            count = 0
            domains = data.get("domains", [])

            for domain in domains:
                domain_name = domain.get("domain", "Unknown")
                variables = domain.get("variables", [])

                for var in variables:
                    var_id = var.get("variable_id", "")
                    question_text = var.get("question_text", "")
                    concepts = var.get("concepts", [])

                    if question_text:
                        self.questions.append(
                            {
                                "wave": wave_name,
                                "var_id": var_id,
                                "question_text": question_text,
                                "concepts": concepts,
                                "domain": domain_name,
                            }
                        )
                        count += 1

            print(f"  ✓ Loaded {count} questions from {wave_name}")
            return count
        except Exception as e:
            print(f"  ✗ Error loading {wave_name}: {e}")
            return 0

    def build_embeddings(self):
        """Generate embeddings for all questions."""
        print(f"\n{'=' * 60}")
        print("Building embeddings for all questions")
        print(f"{'=' * 60}")

        texts = [q["question_text"] for q in self.questions]

        print(f"Encoding {len(texts)} questions...")
        self.embeddings = self.model.encode(
            texts, convert_to_numpy=True, show_progress_bar=True, batch_size=32
        )

        print(f"✓ Generated embeddings: shape {self.embeddings.shape}")

    def build_faiss_index(self):
        """Build FAISS index for fast similarity search."""
        print("\nBuilding FAISS index...")

        faiss.normalize_L2(self.embeddings)
        dimension = self.embeddings.shape[1]
        self.index = faiss.IndexFlatIP(dimension)
        self.index.add(self.embeddings)

        print(f"✓ FAISS index built with {self.index.ntotal} vectors")

    def find_matches(self, top_k=20):
        """Find similar questions across waves."""
        print(f"\n{'=' * 60}")
        print("Finding cross-wave matches")
        print(f"{'=' * 60}")

        matches = []

        for idx, question in enumerate(self.questions):
            if idx % 100 == 0:
                print(f"  Processing question {idx}/{len(self.questions)}...")

            query_embedding = self.embeddings[idx : idx + 1]
            similarities, indices = self.index.search(query_embedding, top_k + 1)

            for sim, match_idx in zip(similarities[0][1:], indices[0][1:]):
                match = self.questions[match_idx]

                if match["wave"] != question["wave"]:
                    # Check if questions target different subjects (e.g., relatives vs neighbors)
                    if self._check_target_mismatch(
                        question["question_text"], match["question_text"]
                    ):
                        continue  # Skip this match - different targets

                    phrase_match = self._check_phrase_match(
                        question["wave"],
                        question["var_id"],
                        match["wave"],
                        match["var_id"],
                    )

                    concept_overlap = self._check_concept_overlap(
                        question["concepts"], match["concepts"]
                    )

                    matches.append(
                        {
                            "wave1": question["wave"],
                            "var1": question["var_id"],
                            "question1": question["question_text"],
                            "concepts1": question["concepts"],
                            "domain1": question["domain"],
                            "wave2": match["wave"],
                            "var2": match["var_id"],
                            "question2": match["question_text"],
                            "concepts2": match["concepts"],
                            "domain2": match["domain"],
                            "similarity": float(sim),
                            "phrase_match": phrase_match,
                            "concept_overlap": concept_overlap,
                        }
                    )

        print(f"✓ Generated {len(matches)} potential cross-wave matches")
        return matches

    def _check_phrase_match(self, wave1, var1, wave2, var2):
        """Check if validation phrases match."""
        key1 = f"{wave1}_{var1}"
        key2 = f"{wave2}_{var2}"

        phrase1 = self.validation_phrases.get(key1, "").lower()
        phrase2 = self.validation_phrases.get(key2, "").lower()

        if phrase1 and phrase2:
            words1 = set(phrase1.split())
            words2 = set(phrase2.split())
            if words1 and words2:
                overlap = len(words1 & words2) / max(len(words1), len(words2))
                return overlap > 0.5

        return False

    def _check_concept_overlap(self, concepts1, concepts2):
        """Check overlap between concept lists."""
        if not concepts1 or not concepts2:
            return 0.0

        set1 = {c.lower() for c in concepts1}
        set2 = {c.lower() for c in concepts2}

        if not set1 or not set2:
            return 0.0

        overlap = len(set1 & set2) / max(len(set1), len(set2))
        return overlap

    def _check_target_mismatch(self, text1, text2):
        """Check if questions target different subjects (e.g., relatives vs neighbors).

        Returns True if questions should NOT be matched due to different targets.
        """
        # Define mutually exclusive target groups
        target_keywords = {
            "relatives": [
                "relative",
                "relatives",
                "family member",
                "family members",
                "kinship",
            ],
            "neighbors": ["neighbor", "neighbours", "neighbors", "neighbour"],
            "acquaintances": ["acquaintance", "acquaintances", "people you know"],
            "strangers": ["stranger", "strangers", "people you meet", "unfamiliar"],
            "colleagues": [
                "colleague",
                "colleagues",
                "coworker",
                "coworkers",
                "workmate",
            ],
            "government": [
                "government official",
                "officials",
                "bureaucrat",
                "civil servant",
            ],
            "police": ["police", "law enforcement", "police officer"],
            "military": ["military", "armed forces", "soldier"],
            "judges": ["judge", "judges", "judiciary", "court"],
            "president": ["president", "prime minister", "head of state"],
            "parliament": [
                "parliament",
                "legislature",
                "congress",
                "national assembly",
            ],
            "political_parties": ["political party", "political parties", "party"],
            "media": ["media", "press", "newspaper", "television", "tv", "radio"],
            "courts": ["court", "courts", "legal system"],
            "local_govt": ["local government", "municipal", "city government", "mayor"],
        }

        text1_lower = text1.lower()
        text2_lower = text2.lower()

        # Find which targets each question mentions
        targets1 = set()
        targets2 = set()

        for target_group, keywords in target_keywords.items():
            for keyword in keywords:
                if keyword in text1_lower:
                    targets1.add(target_group)
                if keyword in text2_lower:
                    targets2.add(target_group)

        # If both questions have identified targets and they're completely different, reject
        if targets1 and targets2 and len(targets1 & targets2) == 0:
            return True  # Mismatch - don't match

        return False  # No mismatch detected

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

        auto_accept = self._deduplicate_pairs(auto_accept)
        manual_review = self._deduplicate_pairs(manual_review)

        return {
            "auto_accept": auto_accept,
            "manual_review": manual_review,
            "low_confidence": low_confidence,
        }

    def _deduplicate_pairs(self, matches):
        """Remove duplicate pairs, keeping highest similarity."""
        pair_map = {}

        for match in matches:
            pair = tuple(
                sorted(
                    [(match["wave1"], match["var1"]), (match["wave2"], match["var2"])]
                )
            )

            if (
                pair not in pair_map
                or match["similarity"] > pair_map[pair]["similarity"]
            ):
                pair_map[pair] = match

        return list(pair_map.values())


def generate_detailed_report(categorized, output_path):
    """Generate comprehensive detailed report."""
    print(f"\nGenerating detailed report: {output_path}")

    with open(output_path, "w") as f:
        f.write("# Asian Barometer Cross-Wave Question Matching - FULL ANALYSIS\n\n")
        f.write(f"**Generated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write("---\n\n")

        # High confidence matches
        f.write("## High Confidence Matches (≥0.85 similarity)\n\n")
        f.write(
            f"**Count**: {len(categorized['auto_accept'])} unique question pairs\n\n"
        )
        f.write("These matches can be automatically accepted for consolidation.\n\n")

        for i, match in enumerate(
            sorted(
                categorized["auto_accept"], key=lambda x: x["similarity"], reverse=True
            ),
            1,
        ):
            f.write(f"### Match {i}: {match['similarity']:.4f}\n\n")
            f.write(f"**Wave 1**: `{match['wave1']}.{match['var1']}`\n")
            f.write(f"- **Question**: {match['question1']}\n")
            f.write(f"- **Concepts**: {', '.join(match['concepts1'][:5])}\n")
            f.write(f"- **Domain**: {match['domain1']}\n\n")

            f.write(f"**Wave 2**: `{match['wave2']}.{match['var2']}`\n")
            f.write(f"- **Question**: {match['question2']}\n")
            f.write(f"- **Concepts**: {', '.join(match['concepts2'][:5])}\n")
            f.write(f"- **Domain**: {match['domain2']}\n\n")

            f.write("**Validation**:\n")
            f.write(f"- Phrase match: {'✓' if match['phrase_match'] else '✗'}\n")
            f.write(f"- Concept overlap: {match['concept_overlap']:.2f}\n\n")
            f.write("---\n\n")

        # Manual review
        f.write("\n## Manual Review Required (0.75-0.85 similarity)\n\n")
        f.write(
            f"**Count**: {len(categorized['manual_review'])} unique question pairs\n\n"
        )
        f.write("These matches require human judgment before consolidation.\n\n")

        for i, match in enumerate(
            sorted(
                categorized["manual_review"],
                key=lambda x: x["similarity"],
                reverse=True,
            ),
            1,
        ):
            f.write(f"### Review {i}: {match['similarity']:.4f}\n\n")
            f.write(
                f"**`{match['wave1']}.{match['var1']}`** ↔ **`{match['wave2']}.{match['var2']}`**\n\n"
            )

            f.write(f"**Q1** ({match['wave1']}): {match['question1']}\n\n")
            f.write(f"**Q2** ({match['wave2']}): {match['question2']}\n\n")

            f.write(f"- Concepts Q1: {', '.join(match['concepts1'][:3])}\n")
            f.write(f"- Concepts Q2: {', '.join(match['concepts2'][:3])}\n")
            f.write(f"- Concept overlap: {match['concept_overlap']:.2f}\n")
            f.write(f"- Phrase match: {'✓' if match['phrase_match'] else '✗'}\n\n")

            f.write("**Decision**: [ ] Accept [ ] Reject [ ] Modify\n\n")
            f.write("---\n\n")

    print(
        f"✓ Detailed report saved: {len(categorized['auto_accept']) + len(categorized['manual_review'])} total pairs"
    )


def generate_summary_statistics(categorized, all_questions, output_path):
    """Generate comprehensive summary statistics."""
    print(f"Generating summary statistics: {output_path}")

    total_questions = len(all_questions)

    # Count unique questions involved
    auto_vars = set()
    manual_vars = set()

    for match in categorized["auto_accept"]:
        auto_vars.add((match["wave1"], match["var1"]))
        auto_vars.add((match["wave2"], match["var2"]))

    for match in categorized["manual_review"]:
        manual_vars.add((match["wave1"], match["var1"]))
        manual_vars.add((match["wave2"], match["var2"]))

    all_vars = {(q["wave"], q["var_id"]) for q in all_questions}
    matched_vars = auto_vars | manual_vars
    unmatched_vars = all_vars - matched_vars

    with open(output_path, "w") as f:
        f.write("# Asian Barometer Question Matching - Summary Statistics\n\n")
        f.write(f"**Generated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
        f.write("---\n\n")

        f.write("## Overall Statistics\n\n")
        f.write(f"- **Total questions analyzed**: {total_questions:,}\n")
        f.write(
            f"- **Total unique pairs identified**: {len(categorized['auto_accept']) + len(categorized['manual_review']):,}\n\n"
        )

        f.write("## Match Quality Distribution\n\n")
        f.write("| Category | Pair Count | % of Matched Pairs |\n")
        f.write("|----------|------------|--------------------|\n")

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
            f"| **High confidence (≥0.85)** | **{len(categorized['auto_accept']):,}** | **{auto_pct:.1f}%** |\n"
        )
        f.write(
            f"| **Manual review (0.75-0.85)** | **{len(categorized['manual_review']):,}** | **{manual_pct:.1f}%** |\n"
        )
        f.write(
            f"| Low confidence (<0.75) | {len(categorized['low_confidence']):,} | Not reported |\n\n"
        )

        f.write("## Question Coverage\n\n")
        f.write("| Category | Question Count | % of Total |\n")
        f.write("|----------|----------------|------------|\n")

        auto_q_pct = 100 * len(auto_vars) / total_questions
        manual_q_pct = 100 * len(manual_vars) / total_questions
        matched_pct = 100 * len(matched_vars) / total_questions
        unmatched_pct = 100 * len(unmatched_vars) / total_questions

        f.write(
            f"| Questions in auto-matches | {len(auto_vars):,} | {auto_q_pct:.1f}% |\n"
        )
        f.write(
            f"| Questions in manual review | {len(manual_vars):,} | {manual_q_pct:.1f}% |\n"
        )
        f.write(
            f"| **Total matched questions** | **{len(matched_vars):,}** | **{matched_pct:.1f}%** |\n"
        )
        f.write(
            f"| Wave-specific (no match) | {len(unmatched_vars):,} | {unmatched_pct:.1f}% |\n\n"
        )

        # Per-wave breakdown
        f.write("## Questions by Wave\n\n")
        wave_counts = defaultdict(int)
        for q in all_questions:
            wave_counts[q["wave"]] += 1

        f.write("| Wave | Total Questions |\n")
        f.write("|------|----------------:|\n")
        for wave in sorted(wave_counts.keys()):
            f.write(f"| {wave} | {wave_counts[wave]:,} |\n")
        f.write(f"| **Total** | **{total_questions:,}** |\n\n")

        # Match distribution by wave pair
        f.write("## Cross-Wave Match Distribution\n\n")
        pair_counts = defaultdict(lambda: {"auto": 0, "manual": 0})

        for match in categorized["auto_accept"]:
            pair = tuple(sorted([match["wave1"], match["wave2"]]))
            pair_counts[pair]["auto"] += 1

        for match in categorized["manual_review"]:
            pair = tuple(sorted([match["wave1"], match["wave2"]]))
            pair_counts[pair]["manual"] += 1

        f.write("| Wave Pair | Auto-Accept | Manual Review | Total |\n")
        f.write("|-----------|------------:|--------------:|------:|\n")
        for pair in sorted(pair_counts.keys()):
            auto = pair_counts[pair]["auto"]
            manual = pair_counts[pair]["manual"]
            total = auto + manual
            f.write(f"| {pair[0]} ↔ {pair[1]} | {auto:,} | {manual:,} | {total:,} |\n")

        f.write("\n## Key Insights\n\n")
        f.write(
            f"1. **Coverage**: {matched_pct:.1f}% of questions have cross-wave matches\n"
        )
        f.write(
            f"2. **Automation**: {auto_pct:.1f}% of matches are high-confidence (auto-accept)\n"
        )
        f.write(
            f"3. **Manual effort**: {len(categorized['manual_review']):,} pairs need human review\n"
        )
        f.write(
            f"4. **Wave-specific**: {len(unmatched_vars):,} questions are unique to their wave\n\n"
        )

    print("✓ Summary statistics saved")


def export_all_matches_json(categorized, output_path):
    """Export ALL matches (auto + manual) to JSON for clustering."""
    print(f"\nExporting all matches to JSON: {output_path}")

    all_matches = categorized["auto_accept"] + categorized["manual_review"]

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(
            {
                "matches": all_matches,
                "count": len(all_matches),
                "auto_count": len(categorized["auto_accept"]),
                "manual_count": len(categorized["manual_review"]),
            },
            f,
            indent=2,
        )

    print(f"✓ Exported {len(all_matches)} matches (auto + manual)")


def main():
    """Main execution for full corpus."""
    print("\n" + "=" * 60)
    print("Asian Barometer Semantic Question Matcher - FULL CORPUS")
    print("=" * 60)

    matcher = QuestionMatcher()
    matcher.load_validation_phrases()

    waves = ["W1", "W2", "W3", "W4", "W5", "W6_Cambodia"]
    for wave in waves:
        filepath = f"{wave}_crosswalk.json"
        if Path(filepath).exists():
            matcher.load_crosswalk(wave, filepath)
        else:
            print(f"⚠ Warning: {filepath} not found, skipping")

    print(f"\n{'=' * 60}")
    print(f"Total questions loaded: {len(matcher.questions):,}")
    print(f"{'=' * 60}")

    if len(matcher.questions) == 0:
        print("✗ No questions loaded. Exiting.")
        return

    matcher.build_embeddings()
    matcher.build_faiss_index()

    all_matches = matcher.find_matches(top_k=20)
    categorized = matcher.categorize_matches(all_matches)

    print(f"\n{'=' * 60}")
    print("FULL CORPUS Results")
    print(f"{'=' * 60}")
    print(f"  High confidence (≥0.85): {len(categorized['auto_accept']):,} pairs")
    print(f"  Manual review (0.75-0.85): {len(categorized['manual_review']):,} pairs")
    print(f"  Low confidence (<0.75): {len(categorized['low_confidence']):,} pairs")

    output_dir = Path("matching_results")
    output_dir.mkdir(exist_ok=True)

    detailed_path = output_dir / "question_matches_detailed.md"
    summary_path = output_dir / "question_matches_summary.md"

    generate_detailed_report(categorized, detailed_path)
    generate_summary_statistics(categorized, matcher.questions, summary_path)

    # Export all matches to JSON for clustering
    json_path = output_dir / "all_matches.json"
    export_all_matches_json(categorized, json_path)

    print(f"\n{'=' * 60}")
    print("✓ COMPLETE! Full corpus analysis finished:")
    print(f"  - Detailed: {detailed_path}")
    print(f"  - Summary: {summary_path}")
    print(f"  - JSON (all matches): {json_path}")
    print(f"{'=' * 60}\n")


if __name__ == "__main__":
    main()
