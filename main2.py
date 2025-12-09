import pandas as pd
import json

# Read the raw output file from the LLM provider
output_lines = []
with open('batch_output.jsonl', 'r', encoding='utf-8') as f:
    for line in f:
        # Each line is a JSON object containing the request and the response
        json_obj = json.loads(line)

        # Extract the model's raw JSON output (this path is typical for chat completions)
        # Note: The exact key path may vary slightly between providers
        raw_content = json_obj['response']['choices'][0]['message']['content']

        # The content should be the clean JSON object we requested:
        # {"id": "Q_65", "summary": "...", "keywords": ["...", "..."]}
        try:
            processed_data = json.loads(raw_content)
            output_lines.append(processed_data)
        except json.JSONDecodeError:
            # Handle cases where the model failed to output perfect JSON
            print(f"Failed to decode: {raw_content}")

        # Convert the list of structured JSON objects into a DataFrame
results_df = pd.DataFrame(output_lines)

# Save the final, clean, structured data
results_df.to_csv('final_processed_data.csv', index=False)
# Or save to Parquet (which is often more space and cost-efficient for cloud storage)
# results_df.to_parquet('final_processed_data.parquet', index=False)