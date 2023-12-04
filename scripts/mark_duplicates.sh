#!/bin/bash
#SBATCH --job-name=mark_dup
#SBATCH --output="/home/achopra/BPA_Alt_Human/BPA/scratch/mark_dup_%j.out"
#SBATCH --error="/home/achopra/BPA_Alt_Human/BPA/scratch/mark_dup_%j.err"
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G 
#SBATCH --time=06:00:00

# README sbatch mark_duplicates.sh

# This script runs Picard's SortSam to mark duplicates in a SAM file.

# Load the Picard module
module load java
module load picard

# Input files 
INPUT_FILE="/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/input/test.txt"
INPUT_BAM="/home/achopra/BPA_Alt_Human/BPA/Picard_queryName/"
OUTPUT_BAM="/home/achopra/BPA_Alt_Human/BPA/Mark_duplicates/"
METRIC_FILE="/home/achopra/BPA_Alt_Human/BPA/Mark_duplicates/"

# Path to the Picard jar file
PICARD_JAR_PATH="/opt/picard/picard.jar"

if [[ ! -f $INPUT_FILE ]]; then
   echo "Please provide a valid input file."
   exit 1
fi

cat "$INPUT_FILE" | while read -r line; do
        if [[ -z "${line}" ]]; then
                continue
        fi
        SRA_ID=$(echo "$line" | xargs)
        
	mkdir "${OUTPUT_BAM}${SRA_ID}"

	# Run the SortSam command
	java -jar $PICARD_JAR_PATH MarkDuplicates \
       			INPUT="$INPUT_BAM${SRA_ID}/${SRA_ID}.bam" \
       			OUTPUT="${OUTPUT_BAM}${SRA_ID}/${SRA_ID}.bam" \
       			M="${METRIC_FILE}${SRA_ID}/${SRA_ID}.txt"
done
