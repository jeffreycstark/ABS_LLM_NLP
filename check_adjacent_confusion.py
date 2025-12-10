#!/usr/bin/env python3
"""
Check if validation phrases are distinctive enough to catch
adjacent question confusion (q83 vs q84, etc.)
"""

import json
import re
from typing import Dict, List, Tuple

def extract_question_number(var_id: str) -> int:
    """Extract numeric part from question ID."""
    match = re.search(r'(\d+)', var_id)
    if match:
        return int(match.group(1))
    return -1

def check_adjacent_confusion(wave_data: Dict) -> List[Dict]:
    """
    Check if adjacent questions have phrases that could be confused.
    Returns list of problematic pairs.
    """
    questions = wave_data.get('questions', {})

    # Group questions by number
    numbered_questions = {}
    for var_id, info in questions.items():
        num = extract_question_number(var_id)
        if num > 0:
            if num not in numbered_questions:
                numbered_questions[num] = []
            numbered_questions[num].append({
                'var_id': var_id,
                'phrase': info.get('validation_phrase', ''),
                'question_text': info.get('question_text', '')
            })

    # Check adjacent pairs
    problematic_pairs = []
    sorted_nums = sorted(numbered_questions.keys())

    for i, num in enumerate(sorted_nums[:-1]):
        next_num = sorted_nums[i + 1]

        # Only check truly adjacent numbers (e.g., 83 and 84, not 83 and 90)
        if next_num - num != 1:
            continue

        current_questions = numbered_questions[num]
        next_questions = numbered_questions[next_num]

        # Check all pairs between current and next
        for curr_q in current_questions:
            for next_q in next_questions:
                curr_phrase = curr_q['phrase'].lower()
                next_phrase = next_q['phrase'].lower()

                # Check if phrases are too similar
                # 1. Empty phrases
                if not curr_phrase or not next_phrase:
                    problematic_pairs.append({
                        'q1': curr_q['var_id'],
                        'q2': next_q['var_id'],
                        'q1_phrase': curr_phrase,
                        'q2_phrase': next_phrase,
                        'q1_text': curr_q['question_text'][:80],
                        'q2_text': next_q['question_text'][:80],
                        'issue': 'empty_phrase'
                    })
                    continue

                # 2. Identical phrases
                if curr_phrase == next_phrase:
                    problematic_pairs.append({
                        'q1': curr_q['var_id'],
                        'q2': next_q['var_id'],
                        'q1_phrase': curr_phrase,
                        'q2_phrase': next_phrase,
                        'q1_text': curr_q['question_text'][:80],
                        'q2_text': next_q['question_text'][:80],
                        'issue': 'identical_phrases'
                    })
                    continue

                # 3. One phrase is substring of another
                if curr_phrase in next_phrase or next_phrase in curr_phrase:
                    problematic_pairs.append({
                        'q1': curr_q['var_id'],
                        'q2': next_q['var_id'],
                        'q1_phrase': curr_phrase,
                        'q2_phrase': next_phrase,
                        'q1_text': curr_q['question_text'][:80],
                        'q2_text': next_q['question_text'][:80],
                        'issue': 'overlapping_phrases'
                    })
                    continue

                # 4. Very high similarity (many shared words)
                curr_words = set(curr_phrase.split())
                next_words = set(next_phrase.split())

                if curr_words and next_words:
                    overlap = len(curr_words & next_words)
                    min_words = min(len(curr_words), len(next_words))
                    similarity = overlap / min_words if min_words > 0 else 0

                    if similarity > 0.8:  # 80% word overlap
                        problematic_pairs.append({
                            'q1': curr_q['var_id'],
                            'q2': next_q['var_id'],
                            'q1_phrase': curr_phrase,
                            'q2_phrase': next_phrase,
                            'q1_text': curr_q['question_text'][:80],
                            'q2_text': next_q['question_text'][:80],
                            'issue': f'high_similarity_{similarity:.0%}'
                        })

    return problematic_pairs

def main():
    """Main analysis."""

    print("="*80)
    print("ADJACENT QUESTION CONFUSION CHECK")
    print("="*80)
    print("\nChecking if q83 vs q84 type mix-ups would be caught...")
    print()

    # Load improved validation phrases
    with open('validation_phrases_improved.json', 'r') as f:
        all_results = json.load(f)

    total_problematic_pairs = 0
    all_issues = []

    for wave, result in all_results.items():
        if 'error' in result:
            continue

        print(f"\n{'='*80}")
        print(f"Analyzing {wave}")
        print('='*80)

        problematic = check_adjacent_confusion(result)
        total_problematic_pairs += len(problematic)

        if problematic:
            print(f"\n⚠️  Found {len(problematic)} adjacent pairs with confusable phrases:\n")

            for issue in problematic[:10]:  # Show first 10
                print(f"  🚨 {issue['q1']} vs {issue['q2']}")
                print(f"     {issue['q1']}: \"{issue['q1_phrase']}\"")
                print(f"     {issue['q2']}: \"{issue['q2_phrase']}\"")
                print(f"     Issue: {issue['issue']}")
                print(f"     Q1: {issue['q1_text']}...")
                print(f"     Q2: {issue['q2_text']}...")
                print()

                all_issues.append(issue)

            if len(problematic) > 10:
                print(f"  ... and {len(problematic) - 10} more pairs")
        else:
            print(f"\n✅ No problematic adjacent pairs found!")

    # Summary
    print(f"\n\n{'='*80}")
    print("SUMMARY")
    print('='*80)

    print(f"\nTotal problematic adjacent pairs across all waves: {total_problematic_pairs}")

    if total_problematic_pairs == 0:
        print("\n✅ EXCELLENT! All adjacent questions have distinctive phrases.")
        print("   Mix-ups like q83 vs q84 would be caught by validation.")
    else:
        print(f"\n⚠️  {total_problematic_pairs} adjacent pairs need better phrases")
        print("   These pairs could be confused if swapped in code.")
        print("\n   RECOMMENDED ACTIONS:")
        print("   1. Find more distinctive phrases for these specific questions")
        print("   2. Use longer phrases that include unique content")
        print("   3. Include actual question content, not just generic patterns")

        # Export issues
        output_file = 'adjacent_confusion_issues.json'
        with open(output_file, 'w') as f:
            json.dump(all_issues, f, indent=2)
        print(f"\n   💾 Full issue list exported to: {output_file}")

if __name__ == '__main__':
    main()
