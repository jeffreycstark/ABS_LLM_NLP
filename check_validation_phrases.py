#!/usr/bin/env python3
"""
Find distinctive consecutive phrases from question text for R validation.
The phrases must exist exactly as written (in order) within the question.
"""

import json
import re
from collections import defaultdict
from typing import Dict, List, Tuple

def normalize_text(text: str) -> str:
    """Normalize text for comparison."""
    # Convert to lowercase, remove extra whitespace
    text = text.lower()
    text = re.sub(r'\s+', ' ', text)
    text = text.strip()
    return text

def extract_ngrams(text: str, n: int) -> List[str]:
    """Extract n-grams (consecutive word sequences) from text."""
    words = text.split()
    ngrams = []
    for i in range(len(words) - n + 1):
        ngram = ' '.join(words[i:i+n])
        ngrams.append(ngram)
    return ngrams

def find_distinctive_phrase(question_text: str, all_questions: List[str],
                           min_words: int = 2, max_words: int = 4) -> Tuple[str, int]:
    """
    Find the shortest distinctive phrase from the question that uniquely identifies it.
    Returns (phrase, occurrences) where occurrences is how many questions contain this phrase.
    """
    question_text = normalize_text(question_text)
    normalized_questions = [normalize_text(q) for q in all_questions]

    # Try different n-gram sizes, starting with shorter phrases
    for n in range(min_words, max_words + 1):
        ngrams = extract_ngrams(question_text, n)

        for ngram in ngrams:
            # Skip if ngram is too generic (common words only)
            if all(word in {'the', 'is', 'are', 'was', 'were', 'do', 'does',
                           'did', 'have', 'has', 'had', 'you', 'your', 'this',
                           'that', 'these', 'those', 'of', 'to', 'in', 'for',
                           'on', 'at', 'by', 'with', 'from'}
                  for word in ngram.split()):
                continue

            # Count how many questions contain this exact phrase
            occurrences = sum(1 for q in normalized_questions if ngram in q)

            # If unique or very distinctive, return it
            if occurrences == 1:
                return (ngram, occurrences)
            elif occurrences <= 2 and n >= 3:  # Accept distinctive 3+ word phrases
                return (ngram, occurrences)

    # If no good phrase found, try single distinctive words
    words = question_text.split()
    for word in words:
        if len(word) >= 6:  # Longer words are more distinctive
            occurrences = sum(1 for q in normalized_questions if word in q)
            if occurrences == 1:
                return (word, occurrences)

    # Last resort: return the longest phrase even if not unique
    if words:
        best_ngram = ' '.join(words[:min(3, len(words))])
        occurrences = sum(1 for q in normalized_questions if best_ngram in q)
        return (best_ngram, occurrences)

    return ("", 0)

def analyze_wave(wave_name: str) -> Dict:
    """Analyze a wave to find validation phrases for all questions."""

    try:
        with open(f'{wave_name}_crosswalk.json', 'r') as f:
            data = json.load(f)

        # Extract all questions
        questions = []
        if 'domains' in data and isinstance(data['domains'], list):
            for domain in data['domains']:
                if 'variables' in domain:
                    questions.extend(domain['variables'])

        # Get all question texts for comparison
        all_question_texts = [q.get('question_text', '') for q in questions]

        # Find validation phrase for each question
        results = {}
        for q in questions:
            var_id = q.get('variable_id', '')
            q_text = q.get('question_text', '')

            if not q_text or not var_id:
                continue

            phrase, occurrences = find_distinctive_phrase(q_text, all_question_texts)

            results[var_id] = {
                'question_text': q_text,
                'validation_phrase': phrase,
                'phrase_occurrences': occurrences,
                'is_unique': occurrences == 1,
                'is_acceptable': occurrences <= 2,
                'phrase_length': len(phrase.split())
            }

        # Calculate statistics
        total = len(results)
        unique = sum(1 for r in results.values() if r['is_unique'])
        acceptable = sum(1 for r in results.values() if r['is_acceptable'])
        problematic = total - acceptable

        return {
            'wave': wave_name,
            'total_questions': total,
            'unique_phrases': unique,
            'acceptable_phrases': acceptable,
            'problematic': problematic,
            'questions': results
        }

    except Exception as e:
        return {
            'wave': wave_name,
            'error': str(e)
        }

def main():
    """Main analysis function."""

    waves = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6_Cambodia']

    print("="*80)
    print("VALIDATION PHRASE ANALYSIS - CONSECUTIVE PHRASES IN QUESTIONS")
    print("="*80)
    print("\nFinding distinctive phrases that exist exactly as written in questions...")
    print()

    all_results = {}

    for wave in waves:
        print(f"\n{'='*80}")
        print(f"Analyzing {wave}...")
        print('='*80)

        result = analyze_wave(wave)
        all_results[wave] = result

        if 'error' in result:
            print(f"❌ ERROR: {result['error']}")
            continue

        print(f"\n📊 Summary:")
        print(f"  Total questions: {result['total_questions']}")
        print(f"  Unique phrases (appears in 1 question only): {result['unique_phrases']}")
        print(f"  Acceptable phrases (appears in ≤2 questions): {result['acceptable_phrases']}")
        print(f"  Problematic (appears in >2 questions): {result['problematic']}")

        coverage = (result['acceptable_phrases'] / result['total_questions'] * 100) if result['total_questions'] > 0 else 0
        print(f"  Coverage: {coverage:.1f}%")

        # Show examples of good validation phrases
        print(f"\n✅ Examples of validation phrases:")
        count = 0
        for var_id, info in sorted(result['questions'].items()):
            if info['is_unique'] and info['validation_phrase']:
                q_text_short = info['question_text'][:60] + '...' if len(info['question_text']) > 60 else info['question_text']
                phrase = info['validation_phrase']
                print(f"  • {var_id}: \"{phrase}\"")
                print(f"    Question: {q_text_short}")
                count += 1
                if count >= 3:
                    break

        # Show problematic cases
        if result['problematic'] > 0:
            print(f"\n⚠️  Problematic questions (phrase appears in multiple questions):")
            count = 0
            for var_id, info in result['questions'].items():
                if not info['is_acceptable']:
                    q_text_short = info['question_text'][:60] + '...' if len(info['question_text']) > 60 else info['question_text']
                    phrase = info['validation_phrase']
                    occurrences = info['phrase_occurrences']
                    print(f"  • {var_id}: \"{phrase}\" (appears {occurrences}x)")
                    print(f"    Question: {q_text_short}")
                    count += 1
                    if count >= 5:
                        remaining = result['problematic'] - 5
                        if remaining > 0:
                            print(f"    ... and {remaining} more")
                        break

    # Overall summary
    print(f"\n\n{'='*80}")
    print("OVERALL SUMMARY")
    print('='*80)

    total_q = sum(r.get('total_questions', 0) for r in all_results.values())
    total_unique = sum(r.get('unique_phrases', 0) for r in all_results.values())
    total_acceptable = sum(r.get('acceptable_phrases', 0) for r in all_results.values())
    total_problematic = sum(r.get('problematic', 0) for r in all_results.values())

    print(f"\nAcross all waves:")
    print(f"  Total questions: {total_q}")
    print(f"  Unique phrases: {total_unique} ({total_unique/total_q*100:.1f}%)")
    print(f"  Acceptable phrases: {total_acceptable} ({total_acceptable/total_q*100:.1f}%)")
    print(f"  Problematic: {total_problematic} ({total_problematic/total_q*100:.1f}%)")

    # Export results to JSON for R script generation
    output_file = 'validation_phrases_all_waves.json'
    with open(output_file, 'w') as f:
        json.dump(all_results, f, indent=2)
    print(f"\n💾 Full results exported to: {output_file}")

    print(f"\n{'='*80}")
    print("CONCLUSION")
    print('='*80)

    if total_problematic == 0:
        print("\n✅ All questions have unique/distinctive validation phrases!")
    else:
        print(f"\n⚠️  {total_problematic} questions have non-unique phrases")
        print("   These phrases appear in multiple questions.")
        print("   Options:")
        print("   1. Use longer, more specific phrases")
        print("   2. Include question numbers in validation")
        print("   3. Manual review and selection of alternative phrases")

if __name__ == '__main__':
    main()