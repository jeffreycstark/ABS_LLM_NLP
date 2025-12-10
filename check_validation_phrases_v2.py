#!/usr/bin/env python3
"""
Find distinctive consecutive phrases from question text for R validation.
IMPROVED: Looks for longer phrases that include distinctive objects/subjects.
"""

import json
import re
from collections import defaultdict
from typing import Dict, List, Tuple

def normalize_text(text: str) -> str:
    """Normalize text for comparison."""
    text = text.lower()
    text = re.sub(r'\s+', ' ', text)
    text = text.strip()
    return text

def extract_ngrams(text: str, min_n: int = 2, max_n: int = 6) -> List[Tuple[str, int]]:
    """
    Extract all n-grams from text with their lengths.
    Returns list of (ngram, length) tuples.
    """
    words = text.split()
    ngrams = []

    for n in range(min_n, min(max_n + 1, len(words) + 1)):
        for i in range(len(words) - n + 1):
            ngram = ' '.join(words[i:i+n])
            ngrams.append((ngram, n))

    return ngrams

def is_too_generic(phrase: str) -> bool:
    """Check if a phrase is too generic to be useful."""
    generic_words = {
        'the', 'is', 'are', 'was', 'were', 'be', 'been', 'being',
        'do', 'does', 'did', 'doing', 'done',
        'have', 'has', 'had', 'having',
        'you', 'your', 'yours',
        'this', 'that', 'these', 'those',
        'of', 'to', 'in', 'for', 'on', 'at', 'by', 'with', 'from',
        'a', 'an', 'and', 'or', 'but', 'if', 'so',
        'would', 'could', 'should', 'may', 'might', 'will', 'can'
    }

    words = phrase.split()

    # Must have at least one non-generic word
    has_content = any(word not in generic_words for word in words)

    return not has_content

def score_phrase(phrase: str, occurrences: int, phrase_length: int) -> float:
    """
    Score a phrase for its suitability as a validation phrase.
    Higher score = better validation phrase.

    Factors:
    - Uniqueness (fewer occurrences = better)
    - Length (longer = more specific = better, but not too long)
    - Content (not too generic)
    """
    if occurrences == 0:
        return 0.0

    # Uniqueness score (exponential penalty for multiple occurrences)
    uniqueness_score = 100.0 / (occurrences ** 1.5)

    # Length score (optimal around 3-4 words)
    if phrase_length == 1:
        length_score = 0.5
    elif phrase_length == 2:
        length_score = 0.8
    elif phrase_length == 3:
        length_score = 1.0
    elif phrase_length == 4:
        length_score = 1.0
    elif phrase_length == 5:
        length_score = 0.9
    else:
        length_score = 0.7

    # Generic penalty
    generic_penalty = 0.5 if is_too_generic(phrase) else 1.0

    return uniqueness_score * length_score * generic_penalty

def find_best_validation_phrase(question_text: str, all_questions: List[str]) -> Tuple[str, int, float]:
    """
    Find the best validation phrase for a question.
    Returns (phrase, occurrences, score).
    """
    question_text = normalize_text(question_text)
    normalized_questions = [normalize_text(q) for q in all_questions]

    # Extract all possible n-grams
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
            'phrase': ngram,
            'occurrences': occurrences,
            'length': length,
            'score': score
        })

    # Sort by score (highest first)
    candidates.sort(key=lambda x: x['score'], reverse=True)

    if candidates:
        best = candidates[0]
        return (best['phrase'], best['occurrences'], best['score'])

    # Fallback: try to find any unique word
    words = question_text.split()
    for word in words:
        if len(word) >= 6 and not is_too_generic(word):
            occurrences = sum(1 for q in normalized_questions if word in q)
            if occurrences <= 2:
                return (word, occurrences, 50.0)

    # Last resort
    if words:
        fallback = ' '.join(words[:3])
        occurrences = sum(1 for q in normalized_questions if fallback in q)
        return (fallback, occurrences, 10.0)

    return ("", 0, 0.0)

def analyze_wave(wave_name: str) -> Dict:
    """Analyze a wave to find best validation phrases for all questions."""

    try:
        with open(f'{wave_name}_crosswalk.json', 'r') as f:
            data = json.load(f)

        # Extract all questions
        questions = []
        if 'domains' in data and isinstance(data['domains'], list):
            for domain in data['domains']:
                if 'variables' in domain:
                    questions.extend(domain['variables'])

        # Get all question texts
        all_question_texts = [q.get('question_text', '') for q in questions]

        # Find best validation phrase for each question
        results = {}
        for q in questions:
            var_id = q.get('variable_id', '')
            q_text = q.get('question_text', '')

            if not q_text or not var_id:
                continue

            phrase, occurrences, score = find_best_validation_phrase(q_text, all_question_texts)

            results[var_id] = {
                'question_text': q_text,
                'validation_phrase': phrase,
                'phrase_occurrences': occurrences,
                'phrase_length': len(phrase.split()),
                'quality_score': score,
                'is_unique': occurrences == 1,
                'is_acceptable': occurrences <= 2,
                'is_good': occurrences <= 3 and len(phrase.split()) >= 2
            }

        # Calculate statistics
        total = len(results)
        unique = sum(1 for r in results.values() if r['is_unique'])
        acceptable = sum(1 for r in results.values() if r['is_acceptable'])
        good = sum(1 for r in results.values() if r['is_good'])
        problematic = total - acceptable

        return {
            'wave': wave_name,
            'total_questions': total,
            'unique_phrases': unique,
            'acceptable_phrases': acceptable,
            'good_phrases': good,
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
    print("IMPROVED VALIDATION PHRASE ANALYSIS")
    print("="*80)
    print("\nFinding best consecutive phrases including distinctive objects/subjects...")
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
        print(f"  Unique phrases (1 question): {result['unique_phrases']}")
        print(f"  Acceptable (≤2 questions): {result['acceptable_phrases']}")
        print(f"  Good quality (≤3 + multi-word): {result['good_phrases']}")
        print(f"  Problematic (>2 questions): {result['problematic']}")

        coverage = (result['acceptable_phrases'] / result['total_questions'] * 100) if result['total_questions'] > 0 else 0
        print(f"  Coverage: {coverage:.1f}%")

        # Show examples of best validation phrases
        print(f"\n✅ Best validation phrases (high quality scores):")
        sorted_questions = sorted(
            result['questions'].items(),
            key=lambda x: x[1]['quality_score'],
            reverse=True
        )

        count = 0
        for var_id, info in sorted_questions:
            if info['validation_phrase'] and count < 5:
                q_text_short = info['question_text'][:70] + '...' if len(info['question_text']) > 70 else info['question_text']
                phrase = info['validation_phrase']
                occ = info['phrase_occurrences']
                length = info['phrase_length']
                print(f"  • {var_id}: \"{phrase}\" (occurs {occ}x, {length} words)")
                print(f"    Q: {q_text_short}")
                count += 1

        # Show problematic cases
        if result['problematic'] > 0:
            print(f"\n⚠️  Questions still needing attention:")
            count = 0
            for var_id, info in result['questions'].items():
                if not info['is_acceptable']:
                    q_text_short = info['question_text'][:70] + '...' if len(info['question_text']) > 70 else info['question_text']
                    phrase = info['validation_phrase']
                    occurrences = info['phrase_occurrences']
                    print(f"  • {var_id}: \"{phrase}\" (occurs {occurrences}x)")
                    print(f"    Q: {q_text_short}")
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
    total_good = sum(r.get('good_phrases', 0) for r in all_results.values())
    total_problematic = sum(r.get('problematic', 0) for r in all_results.values())

    print(f"\nAcross all waves:")
    print(f"  Total questions: {total_q}")
    print(f"  Unique phrases: {total_unique} ({total_unique/total_q*100:.1f}%)")
    print(f"  Acceptable: {total_acceptable} ({total_acceptable/total_q*100:.1f}%)")
    print(f"  Good quality: {total_good} ({total_good/total_q*100:.1f}%)")
    print(f"  Problematic: {total_problematic} ({total_problematic/total_q*100:.1f}%)")

    # Export results
    output_file = 'validation_phrases_improved.json'
    with open(output_file, 'w') as f:
        json.dump(all_results, f, indent=2)
    print(f"\n💾 Full results exported to: {output_file}")

    print(f"\n{'='*80}")
    print("CONCLUSION")
    print('='*80)

    if total_problematic == 0:
        print("\n✅ All questions have unique/distinctive validation phrases!")
    elif total_problematic <= 10:
        print(f"\n✅ Excellent! Only {total_problematic} questions need manual attention")
    else:
        print(f"\n⚠️  {total_problematic} questions still have non-unique phrases")

    print("\nFor remaining problematic cases:")
    print("  • Include question number: grepl('q18.*trust', ...)")
    print("  • Use value labels as backup validation")
    print("  • Manual review for alternative unique phrases")

if __name__ == '__main__':
    main()