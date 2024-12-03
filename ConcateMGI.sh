#!/bin/bash

# Set the directory containing the FASTQ files and the output directory
FASTQ_DIR="input"  # Update this to your folder path
OUTPUT_DIR="output"  # Directory where concatenated files will be saved

# Create the output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Find all unique sample names from the filenames
samples=$(find "$FASTQ_DIR" -name "*.fq.gz" | sed -E 's/.*_(UDB-[^_]+)_[12]\.fq\.gz/\1/' | sort | uniq)

# Iterate over each unique sample
for sample in $samples; do
    # Find all forward read files (_1.fq.gz) for this sample across lanes
    forward_files=$(find "$FASTQ_DIR" -name "*_${sample}_1.fq.gz" 2> /dev/null)

    # Find all reverse read files (_2.fq.gz) for this sample across lanes
    reverse_files=$(find "$FASTQ_DIR" -name "*_${sample}_2.fq.gz" 2> /dev/null)

    # Define output file paths for concatenated files
    forward_output="$OUTPUT_DIR/${sample}_concatenated_1.fq.gz"
    reverse_output="$OUTPUT_DIR/${sample}_concatenated_2.fq.gz"

    # Concatenate all forward read files, if any
    if [ -n "$forward_files" ]; then
        echo "Concatenating forward reads for $sample..."
        cat $forward_files > "$forward_output"
    else
        echo "No forward reads found for $sample."
    fi

    # Concatenate all reverse read files, if any
    if [ -n "$reverse_files" ]; then
        echo "Concatenating reverse reads for $sample..."
        cat $reverse_files > "$reverse_output"
    else
        echo "No reverse reads found for $sample."
    fi
done

echo "Concatenation completed for all samples."
