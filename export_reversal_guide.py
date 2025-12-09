"""
Export reversal guide with distinctive keywords for manual R coding

Creates a CSV that shows:
- Which variables need reversal
- Their scale type
- Distinctive keyword for validation
- Question text
"""

import json
import csv
import re
from collections import Counter


def build_word_frequency(all_questions, min_length=5):
    """Build word frequency across all questions in wave"""
    stop_words = {
        'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
        'of', 'with', 'by', 'from', 'is', 'are', 'was', 'were', 'be', 'been',
        'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'should',
        'could', 'may', 'might', 'must', 'can', 'your', 'you', 'how', 'what',
        'which', 'when', 'where', 'who', 'why', 'that', 'this', 'these', 'those',
        'question', 'please', 'following'
    }

    word_freq = Counter()

    for question in all_questions:
        text = question.lower()
        text = re.sub(r'[^\w\s]', ' ', text)
        words = [w for w in text.split() if len(w) >= min_length and w not in stop_words]
        word_freq.update(words)

    return word_freq, stop_words


def extract_distinctive_keyword(question_text, word_freq, stop_words, min_length=5):
    """Extract most distinctive word from question using wave-wide frequency"""

    # Clean and split
    text = question_text.lower()
    text = re.sub(r'[^\w\s]', ' ', text)
    words = [w for w in text.split() if len(w) >= min_length and w not in stop_words]

    if not words:
        return question_text[:15]

    # Find word with lowest frequency (most distinctive)
    word_scores = {word: word_freq[word] for word in words}
    if word_scores:
        distinctive_word = min(word_scores.items(), key=lambda x: x[1])[0]
        return distinctive_word

    # Fallback
    return words[0] if words else question_text[:15]


def generate_reversal_guide(wave_file, wave_name, output_csv):
    """Generate CSV guide for reversal with keywords"""

    with open(wave_file, 'r', encoding='utf-8') as f:
        variables = json.load(f)

    # Build word frequency across entire wave
    all_questions = [v['question_text'] for v in variables]
    word_freq, stop_words = build_word_frequency(all_questions)

    # Filter to variables needing reversal
    reversal_vars = [v for v in variables if v['scale_analysis']['needs_reversal']]

    with open(output_csv, 'w', encoding='utf-8', newline='') as f:
        writer = csv.writer(f)
        writer.writerow([
            'wave', 'variable_id', 'question_type', 'scale_type', 'scale_points',
            'max_value', 'missing_codes', 'distinctive_keyword', 'question_text'
        ])

        for var in reversal_vars:
            sa = var['scale_analysis']
            var_id = var['variable_id']

            # Determine question type
            if var_id.lower().startswith('q'):
                q_type = 'core_questionnaire'
            elif var_id.lower().startswith('ir'):
                q_type = 'interviewer'
            elif var_id.lower().startswith('se'):
                q_type = 'socioeconomic'
            else:
                q_type = 'other'

            # Get missing codes
            if sa['first_na_value'] is not None:
                missing_codes = sorted(set([
                    vl['value'] for vl in var['value_labels']
                    if vl['value'] < 0 or vl['value'] >= sa['first_na_value']
                ]))
            else:
                missing_codes = sorted(set([
                    vl['value'] for vl in var['value_labels']
                    if vl['value'] < 0
                ]))

            if not missing_codes:
                missing_codes = [-1, 7, 8, 9]  # Default

            keyword = extract_distinctive_keyword(var['question_text'], word_freq, stop_words)

            writer.writerow([
                wave_name,
                var_id,
                q_type,
                sa['scale_type'],
                sa['scale_points'],
                sa['max_substantive_value'],
                '; '.join(map(str, missing_codes)),
                keyword,
                var['question_text'][:100] + '...' if len(var['question_text']) > 100 else var['question_text']
            ])

    print(f"✅ {wave_name}: {len(reversal_vars)} variables exported to {output_csv}")


def main():
    waves = [
        ('W1_analyzed.json', 'W1', 'W1_reversal_guide.csv'),
        ('W2_analyzed.json', 'W2', 'W2_reversal_guide.csv'),
        ('W3_analyzed.json', 'W3', 'W3_reversal_guide.csv'),
        ('W4_analyzed.json', 'W4', 'W4_reversal_guide.csv'),
        ('W5_analyzed.json', 'W5', 'W5_reversal_guide.csv'),
        ('W6_Cambodia_analyzed.json', 'W6_Cambodia', 'W6_Cambodia_reversal_guide.csv'),
    ]

    # Also create combined guide
    all_reversals = []

    for wave_file, wave_name, output_csv in waves:
        generate_reversal_guide(wave_file, wave_name, output_csv)

        # Add to combined
        with open(output_csv, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            all_reversals.extend(list(reader))

    # Write combined guide
    combined_csv = 'ALL_WAVES_reversal_guide.csv'
    with open(combined_csv, 'w', encoding='utf-8', newline='') as f:
        if all_reversals:
            writer = csv.DictWriter(f, fieldnames=all_reversals[0].keys())
            writer.writeheader()
            writer.writerows(all_reversals)

    print(f"\n✅ Combined guide: {combined_csv} ({len(all_reversals)} total variables)")


if __name__ == "__main__":
    main()