#!/usr/bin/env python3
"""
Asian Barometer Question Semantic Matching System - TEST VERSION

Runs on small subset for validation before full corpus processing.
"""

import json
import numpy as np
from pathlib import Path
from collections import defaultdict
from datetime import datetime
from sentence_transformers import SentenceTransformer
import faiss

class QuestionMatcher:
    """Semantic matching engine for cross-wave question comparison."""

    def __init__(self, model_name='all-MiniLM-L6-v2', test_mode=True, test_limit=20):
        """Initialize with sentence transformer model."""
        print(f"Loading sentence transformer model: {model_name}")
        self.model = SentenceTransformer(model_name)
        self.questions = []
        self.embeddings = None
        self.index = None
        self.validation_phrases = {}
        self.test_mode = test_mode
        self.test_limit = test_limit

        if test_mode:
            print(f"⚠ TEST MODE: Limited to {test_limit} questions per wave")

    def load_validation_phrases(self, filepath='validation_phrases_improved.json'):
        """Load validation phrases for secondary verification."""
        print(f"\nLoading validation phrases from {filepath}")
        try:
            with open(filepath, 'r') as f:
                data = json.load(f)

            # Extract phrases by wave and variable
            for wave, wave_data in data.items():
                if wave.startswith('W'):
                    for var_id, phrase_info in wave_data.get('questions', {}).items():
                        key = f"{wave}_{var_id}"
                        self.validation_phrases[key] = phrase_info.get('validation_phrase', '')

            print(f"  ✓ Loaded {len(self.validation_phrases)} validation phrases")
        except Exception as e:
            print(f"  ⚠ Warning: Could not load validation phrases: {e}")

    def load_crosswalk(self, wave_name, filepath):
        """Load questions from a wave's crosswalk JSON."""
        print(f"\nLoading {wave_name} from {filepath}")
        try:
            with open(filepath, 'r') as f:
                data = json.load(f)

            count = 0
            domains = data.get('domains', [])

            for domain in domains:
                domain_name = domain.get('domain', 'Unknown')
                variables = domain.get('variables', [])

                for var in variables:
                    if self.test_mode and count >= self.test_limit:
                        break

                    var_id = var.get('variable_id', '')
                    question_text = var.get('question_text', '')
                    concepts = var.get('concepts', [])

                    if question_text:
                        self.questions.append({
                            'wave': wave_name,
                            'var_id': var_id,
                            'question_text': question_text,
                            'concepts': concepts,  # List of keywords
                            'domain': domain_name
                        })
                        count += 1

                if self.test_mode and count >= self.test_limit:
                    break

            print(f"  ✓ Loaded {count} questions from {wave_name}")
            return count
        except Exception as e:
            print(f"  ✗ Error loading {wave_name}: {e}")
            return 0

    def build_embeddings(self):
        """Generate embeddings for all questions."""
        print(f"\n{'='*60}")
        print("Building embeddings for all questions")
        print(f"{'='*60}")

        texts = [q['question_text'] for q in self.questions]

        print(f"Encoding {len(texts)} questions...")
        self.embeddings = self.model.encode(
            texts,
            convert_to_numpy=True,
            show_progress_bar=True,
            batch_size=32
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
        print(f"\n{'='*60}")
        print("Finding cross-wave matches")
        print(f"{'='*60}")

        matches = []

        for idx, question in enumerate(self.questions):
            # Search for similar questions
            query_embedding = self.embeddings[idx:idx+1]
            similarities, indices = self.index.search(query_embedding, top_k + 1)

            # Skip first result (self-match)
            for sim, match_idx in zip(similarities[0][1:], indices[0][1:]):
                match = self.questions[match_idx]

                # Only consider cross-wave matches
                if match['wave'] != question['wave']:
                    # Check validation phrase match
                    phrase_match = self._check_phrase_match(
                        question['wave'], question['var_id'],
                        match['wave'], match['var_id']
                    )

                    # Check concept overlap
                    concept_overlap = self._check_concept_overlap(
                        question['concepts'], match['concepts']
                    )

                    matches.append({
                        'wave1': question['wave'],
                        'var1': question['var_id'],
                        'question1': question['question_text'],
                        'concepts1': question['concepts'],
                        'domain1': question['domain'],
                        'wave2': match['wave'],
                        'var2': match['var_id'],
                        'question2': match['question_text'],
                        'concepts2': match['concepts'],
                        'domain2': match['domain'],
                        'similarity': float(sim),
                        'phrase_match': phrase_match,
                        'concept_overlap': concept_overlap
                    })

        print(f"✓ Generated {len(matches)} potential cross-wave matches")
        return matches

    def _check_phrase_match(self, wave1, var1, wave2, var2):
        """Check if validation phrases match between two questions."""
        key1 = f"{wave1}_{var1}"
        key2 = f"{wave2}_{var2}"

        phrase1 = self.validation_phrases.get(key1, '').lower()
        phrase2 = self.validation_phrases.get(key2, '').lower()

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

        # Normalize concepts
        set1 = {c.lower() for c in concepts1}
        set2 = {c.lower() for c in concepts2}

        if not set1 or not set2:
            return 0.0

        overlap = len(set1 & set2) / max(len(set1), len(set2))
        return overlap

    def categorize_matches(self, matches):
        """Categorize matches by similarity threshold."""
        auto_accept = []
        manual_review = []
        low_confidence = []

        for match in matches:
            sim = match['similarity']
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
            'auto_accept': auto_accept,
            'manual_review': manual_review,
            'low_confidence': low_confidence
        }

    def _deduplicate_pairs(self, matches):
        """Remove duplicate pairs (A→B and B→A), keeping highest similarity."""
        pair_map = {}

        for match in matches:
            # Create canonical pair key (sorted)
            pair = tuple(sorted([
                (match['wave1'], match['var1']),
                (match['wave2'], match['var2'])
            ]))

            # Keep the match with highest similarity
            if pair not in pair_map or match['similarity'] > pair_map[pair]['similarity']:
                pair_map[pair] = match

        return list(pair_map.values())

def generate_test_report(categorized, all_questions, output_path):
    """Generate test report with sample matches."""
    print(f"\nGenerating test report: {output_path}")

    with open(output_path, 'w') as f:
        f.write("# Asian Barometer Question Matching - TEST RUN\n\n")
        f.write(f"**Generated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"**Test Size**: {len(all_questions)} questions total\n\n")
        f.write("---\n\n")

        f.write("## Summary Statistics\n\n")
        f.write(f"- High confidence matches (≥0.85): **{len(categorized['auto_accept'])}** pairs\n")
        f.write(f"- Manual review needed (0.75-0.85): **{len(categorized['manual_review'])}** pairs\n")
        f.write(f"- Low confidence (<0.75): **{len(categorized['low_confidence'])}** pairs\n\n")

        # Show sample high-confidence matches
        f.write("## Sample High Confidence Matches (≥0.85)\n\n")
        for i, match in enumerate(sorted(categorized['auto_accept'],
                                        key=lambda x: x['similarity'], reverse=True)[:5], 1):
            f.write(f"### {i}. Similarity: {match['similarity']:.3f}\n\n")
            f.write(f"**{match['wave1']}.{match['var1']}**: {match['question1'][:100]}...\n\n")
            f.write(f"**{match['wave2']}.{match['var2']}**: {match['question2'][:100]}...\n\n")
            f.write(f"- Concepts Q1: {', '.join(match['concepts1'][:3])}\n")
            f.write(f"- Concepts Q2: {', '.join(match['concepts2'][:3])}\n")
            f.write(f"- Concept overlap: {match['concept_overlap']:.2f}\n")
            f.write(f"- Phrase match: {'✓' if match['phrase_match'] else '✗'}\n\n")
            f.write("---\n\n")

        # Show sample manual review
        f.write("## Sample Manual Review Cases (0.75-0.85)\n\n")
        for i, match in enumerate(sorted(categorized['manual_review'],
                                        key=lambda x: x['similarity'], reverse=True)[:5], 1):
            f.write(f"### {i}. Similarity: {match['similarity']:.3f}\n\n")
            f.write(f"**{match['wave1']}.{match['var1']}** ↔ **{match['wave2']}.{match['var2']}**\n\n")
            f.write(f"Q1: {match['question1'][:80]}...\n\n")
            f.write(f"Q2: {match['question2'][:80]}...\n\n")
            f.write("---\n\n")

    print(f"✓ Test report saved")

def main():
    """Main execution for test run."""
    print("\n" + "="*60)
    print("Asian Barometer Semantic Question Matcher - TEST MODE")
    print("="*60)

    # Initialize matcher in TEST mode
    matcher = QuestionMatcher(test_mode=True, test_limit=20)

    # Load validation phrases
    matcher.load_validation_phrases()

    # Load crosswalk files (limited to test_limit per wave)
    waves = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6_Cambodia']
    for wave in waves:
        filepath = f'{wave}_crosswalk.json'
        if Path(filepath).exists():
            matcher.load_crosswalk(wave, filepath)
        else:
            print(f"⚠ Warning: {filepath} not found, skipping")

    print(f"\n{'='*60}")
    print(f"Total questions loaded: {len(matcher.questions)}")
    print(f"{'='*60}")

    if len(matcher.questions) == 0:
        print("✗ No questions loaded. Exiting.")
        return

    # Build embeddings and index
    matcher.build_embeddings()
    matcher.build_faiss_index()

    # Find matches
    all_matches = matcher.find_matches(top_k=10)

    # Categorize by threshold
    categorized = matcher.categorize_matches(all_matches)

    print(f"\n{'='*60}")
    print("TEST RUN Results")
    print(f"{'='*60}")
    print(f"  High confidence (≥0.85): {len(categorized['auto_accept'])} pairs")
    print(f"  Manual review (0.75-0.85): {len(categorized['manual_review'])} pairs")
    print(f"  Low confidence (<0.75): {len(categorized['low_confidence'])} pairs")

    # Generate test report
    output_path = Path('matching_test_results.md')
    generate_test_report(categorized, matcher.questions, output_path)

    print(f"\n{'='*60}")
    print(f"✓ TEST COMPLETE! Review results in: {output_path}")
    print(f"{'='*60}\n")
    print("If results look good, run full version with test_mode=False")

if __name__ == '__main__':
    main()
