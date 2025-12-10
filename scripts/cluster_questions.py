#!/usr/bin/env python3
"""
Transform pairwise matches into question clusters.

Groups related questions across waves and presents them as single rows
sorted by confidence for easier manual review.
"""

import json
import csv
from pathlib import Path
from collections import defaultdict
from typing import Dict, List, Set, Tuple

class QuestionClusterer:
    """Build question groups from pairwise matches using graph clustering."""

    def __init__(self):
        self.adjacency = defaultdict(set)  # Graph of matched questions
        self.similarities = {}  # Edge weights (similarity scores)
        self.question_data = {}  # Metadata for each question

    def load_matches_from_json(self, detailed_json_path):
        """Load matches from JSON export (we'll create this first)."""
        print(f"Loading matches from {detailed_json_path}")

        with open(detailed_json_path, 'r') as f:
            data = json.load(f)

        for match in data['matches']:
            q1_id = f"{match['wave1']}.{match['var1']}"
            q2_id = f"{match['wave2']}.{match['var2']}"
            sim = match['similarity']

            # Build graph
            self.adjacency[q1_id].add(q2_id)
            self.adjacency[q2_id].add(q1_id)

            # Store similarity (use max if multiple edges)
            edge = tuple(sorted([q1_id, q2_id]))
            self.similarities[edge] = max(self.similarities.get(edge, 0), sim)

            # Store metadata
            if q1_id not in self.question_data:
                self.question_data[q1_id] = {
                    'wave': match['wave1'],
                    'var': match['var1'],
                    'question': match['question1'],
                    'concepts': match['concepts1'],
                    'domain': match['domain1']
                }
            if q2_id not in self.question_data:
                self.question_data[q2_id] = {
                    'wave': match['wave2'],
                    'var': match['var2'],
                    'question': match['question2'],
                    'concepts': match['concepts2'],
                    'domain': match['domain2']
                }

        print(f"  ✓ Loaded {len(data['matches'])} matches")
        print(f"  ✓ Found {len(self.question_data)} unique questions")

    def _check_target_compatibility(self, q1_id, q2_id) -> bool:
        """Check if two questions have compatible targets (for strict clustering)."""
        q1_text = self.question_data[q1_id]['question'].lower()
        q2_text = self.question_data[q2_id]['question'].lower()

        # Define mutually exclusive targets
        target_keywords = {
            'relatives': ['relative', 'relatives', 'family member', 'family members'],
            'neighbors': ['neighbor', 'neighbours', 'neighbors', 'neighbour'],
            'acquaintances': ['acquaintance', 'acquaintances', 'people you know', 'people you interact'],
            'strangers': ['stranger', 'strangers', 'people you meet', 'unfamiliar'],
            'colleagues': ['colleague', 'colleagues', 'coworker', 'coworkers'],
        }

        # Find targets in each question
        targets1 = set()
        targets2 = set()

        for target_group, keywords in target_keywords.items():
            for keyword in keywords:
                if keyword in q1_text:
                    targets1.add(target_group)
                if keyword in q2_text:
                    targets2.add(target_group)

        # If both have targets identified and they're completely different, incompatible
        if targets1 and targets2 and len(targets1 & targets2) == 0:
            return False

        return True

    def find_connected_components(self) -> List[Set[str]]:
        """Find connected components with strict target compatibility.

        Unlike simple DFS, this ensures ALL pairs in a component are target-compatible.
        This prevents transitive connections between incompatible targets.
        """
        visited = set()
        components = []

        for start_node in self.question_data.keys():
            if start_node in visited:
                continue

            # Build component with strict compatibility check
            component = {start_node}
            visited.add(start_node)

            # Iteratively expand component
            changed = True
            while changed:
                changed = False
                candidates = set()

                # Find all neighbors of current component
                for node in component:
                    candidates.update(self.adjacency[node])

                # Try to add compatible candidates
                for candidate in candidates:
                    if candidate in visited:
                        continue

                    # Check if candidate is compatible with ALL nodes in component
                    compatible = True
                    for existing in component:
                        if candidate not in self.adjacency[existing]:
                            # Not directly connected
                            if not self._check_target_compatibility(candidate, existing):
                                compatible = False
                                break

                    if compatible:
                        component.add(candidate)
                        visited.add(candidate)
                        changed = True

            components.append(component)

        return components

    def calculate_group_confidence(self, group: Set[str]) -> Tuple[float, float, int]:
        """Calculate average, min, and count of similarities within group."""
        similarities = []

        # Get all pairwise similarities within group
        group_list = list(group)
        for i in range(len(group_list)):
            for j in range(i + 1, len(group_list)):
                edge = tuple(sorted([group_list[i], group_list[j]]))
                if edge in self.similarities:
                    similarities.append(self.similarities[edge])

        if similarities:
            return (
                sum(similarities) / len(similarities),  # average
                min(similarities),  # minimum
                len(similarities)  # pair count
            )
        return (0.0, 0.0, 0)

    def build_clusters(self) -> List[Dict]:
        """Build final cluster list with metadata."""
        print("\nBuilding question clusters...")

        components = self.find_connected_components()
        clusters = []

        for idx, component in enumerate(components, 1):
            # Calculate confidence metrics
            avg_conf, min_conf, pair_count = self.calculate_group_confidence(component)

            # Group by wave
            waves_dict = defaultdict(list)
            for q_id in component:
                data = self.question_data[q_id]
                waves_dict[data['wave']].append(data['var'])

            # Sort waves
            waves_sorted = sorted(waves_dict.items(), key=lambda x: (
                0 if x[0].startswith('W') and x[0][1:2].isdigit() else 1,
                int(x[0][1]) if x[0].startswith('W') and len(x[0]) > 1 and x[0][1:2].isdigit() else 99,
                x[0]
            ))

            # Get representative question text (from first wave)
            rep_q_id = list(component)[0]
            rep_data = self.question_data[rep_q_id]

            # Get all unique concepts
            all_concepts = set()
            domains = set()
            for q_id in component:
                data = self.question_data[q_id]
                all_concepts.update(data['concepts'])
                domains.add(data['domain'])

            clusters.append({
                'cluster_id': idx,
                'wave_count': len(waves_dict),
                'question_count': len(component),
                'avg_confidence': avg_conf,
                'min_confidence': min_conf,
                'pair_count': pair_count,
                'waves': waves_sorted,
                'question_text': rep_data['question'],
                'concepts': sorted(all_concepts),
                'domains': sorted(domains)
            })

        print(f"  ✓ Built {len(clusters)} question clusters")
        return clusters

    def export_to_csv(self, clusters: List[Dict], output_path: str):
        """Export clusters to CSV for easy Excel/spreadsheet review."""
        print(f"\nExporting to {output_path}")

        with open(output_path, 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)

            # Header
            writer.writerow([
                'Cluster_ID',
                'Wave_Count',
                'Avg_Confidence',
                'Min_Confidence',
                'W1_Vars',
                'W2_Vars',
                'W3_Vars',
                'W4_Vars',
                'W5_Vars',
                'W6_Vars',
                'Question_Text',
                'Concepts',
                'Domains'
            ])

            # Data rows
            for cluster in clusters:
                waves_dict = dict(cluster['waves'])

                row = [
                    cluster['cluster_id'],
                    cluster['wave_count'],
                    f"{cluster['avg_confidence']:.4f}",
                    f"{cluster['min_confidence']:.4f}",
                    ', '.join(waves_dict.get('W1', [])),
                    ', '.join(waves_dict.get('W2', [])),
                    ', '.join(waves_dict.get('W3', [])),
                    ', '.join(waves_dict.get('W4', [])),
                    ', '.join(waves_dict.get('W5', [])),
                    ', '.join(waves_dict.get('W6_Cambodia', [])),
                    cluster['question_text'][:200],  # Truncate long questions
                    '; '.join(cluster['concepts'][:5]),  # Top 5 concepts
                    '; '.join(cluster['domains'])
                ]

                writer.writerow(row)

        print(f"  ✓ Exported {len(clusters)} clusters")

    def export_to_markdown(self, clusters: List[Dict], output_path: str):
        """Export clusters to readable markdown format."""
        print(f"Exporting to {output_path}")

        with open(output_path, 'w', encoding='utf-8') as f:
            f.write("# Asian Barometer Question Clusters\n\n")
            f.write("**Grouped by semantic similarity across waves**\n\n")
            f.write("---\n\n")

            for cluster in clusters:
                f.write(f"## Cluster {cluster['cluster_id']}\n\n")
                f.write(f"**Waves**: {cluster['wave_count']} | ")
                f.write(f"**Avg Confidence**: {cluster['avg_confidence']:.3f} | ")
                f.write(f"**Min Confidence**: {cluster['min_confidence']:.3f}\n\n")

                # Wave coverage
                f.write("**Coverage**:\n")
                for wave, vars in cluster['waves']:
                    f.write(f"- {wave}: {', '.join(vars)}\n")
                f.write("\n")

                # Question text
                f.write(f"**Question**: {cluster['question_text']}\n\n")

                # Concepts
                if cluster['concepts']:
                    f.write(f"**Concepts**: {', '.join(cluster['concepts'][:8])}\n\n")

                f.write("---\n\n")

        print(f"  ✓ Exported markdown")


def export_matches_to_json():
    """First, export the detailed markdown to JSON for easier processing."""
    print("\nStep 1: Converting detailed report to JSON...")

    # This is a simple parser - we'll read the existing detailed.md
    # and extract structured data

    input_path = Path('matching_results/question_matches_detailed.md')
    output_path = Path('matching_results/question_matches.json')

    matches = []
    current_match = {}

    with open(input_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()

            if line.startswith('### Match'):
                # Save previous match
                if current_match:
                    matches.append(current_match)

                # Start new match
                sim = float(line.split(':')[1].strip())
                current_match = {'similarity': sim}

            elif line.startswith('**Wave 1**:'):
                wave, var = line.split('`')[1].split('.')
                current_match['wave1'] = wave
                current_match['var1'] = var

            elif line.startswith('**Wave 2**:'):
                wave, var = line.split('`')[1].split('.')
                current_match['wave2'] = wave
                current_match['var2'] = var

            elif line.startswith('- **Question**:'):
                question = line.split(':', 1)[1].strip()
                if 'question1' not in current_match:
                    current_match['question1'] = question
                else:
                    current_match['question2'] = question

            elif line.startswith('- **Concepts**:'):
                concepts = line.split(':', 1)[1].strip()
                concepts_list = [c.strip() for c in concepts.split(',')]
                if 'concepts1' not in current_match:
                    current_match['concepts1'] = concepts_list
                else:
                    current_match['concepts2'] = concepts_list

            elif line.startswith('- **Domain**:'):
                domain = line.split(':', 1)[1].strip()
                if 'domain1' not in current_match:
                    current_match['domain1'] = domain
                else:
                    current_match['domain2'] = domain

    # Save last match
    if current_match:
        matches.append(current_match)

    # Write JSON
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump({'matches': matches, 'count': len(matches)}, f, indent=2)

    print(f"  ✓ Converted {len(matches)} matches to JSON")
    return output_path


def main():
    """Main execution."""
    print("="*60)
    print("Asian Barometer Question Clustering")
    print("="*60)

    # Use the all_matches.json file generated by semantic_matcher_full.py
    json_path = Path('matching_results/all_matches.json')

    if not json_path.exists():
        print(f"✗ Error: {json_path} not found")
        print("  Run semantic_matcher_full.py first to generate all matches")
        return

    # Build clusters from all matches (auto + manual)
    clusterer = QuestionClusterer()
    clusterer.load_matches_from_json(json_path)

    clusters = clusterer.build_clusters()

    # Step 3: Sort by confidence (high to low)
    clusters.sort(key=lambda x: x['avg_confidence'], reverse=True)

    # Step 4: Export to both formats
    output_dir = Path('matching_results')

    csv_path = output_dir / 'question_clusters.csv'
    md_path = output_dir / 'question_clusters.md'

    clusterer.export_to_csv(clusters, csv_path)
    clusterer.export_to_markdown(clusters, md_path)

    print("\n" + "="*60)
    print("✓ COMPLETE!")
    print(f"  - CSV (for Excel): {csv_path}")
    print(f"  - Markdown: {md_path}")
    print("="*60)

    # Print summary
    print("\nCluster Summary:")
    print(f"  Total clusters: {len(clusters)}")

    wave_counts = defaultdict(int)
    for cluster in clusters:
        wave_counts[cluster['wave_count']] += 1

    print("\n  Clusters by wave coverage:")
    for wave_count in sorted(wave_counts.keys(), reverse=True):
        print(f"    {wave_count} waves: {wave_counts[wave_count]} clusters")


if __name__ == '__main__':
    main()
