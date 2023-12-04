#!/bin/bash
#SBATCH --job-name=sort_query
#SBATCH --output="/home/achopra/BPA_Alt_Human/BPA/scratch/sort_q_%j.out"
#SBATCH --error="/home/achopra/BPA_Alt_Human/BPA/scratch/sort_q_%j.err"
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G 
#SBATCH --time=06:00:00

# README sbatch sort_by_queryName.sh

# Load the Picard module

module load java
module load picard

# Path to the Picard jar file
PICARD_JAR_PATH="/opt/picard/picard.jar"

# Input BAM file
INPUT_FILE="/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/input/test.txt"
INPUT_BAM="/home/achopra/BPA_Alt_Human/BPA/STAR_output/"
OUTPUT_BAM="/home/achopra/BPA_Alt_Human/BPA/Picard_queryName/"

# Sort order (e.g., coordinate, queryname)
SORT_ORDER="queryname"

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
	java -jar $PICARD_JAR_PATH SortSam \
       			INPUT="${INPUT_BAM}${SRA_ID}/${SRA_ID}Aligned.out.bam" \
       			OUTPUT="${OUTPUT_BAM}${SRA_ID}/${SRA_ID}.bam" \
       			SORT_ORDER=$SORT_ORDER 
done
#echo "Sorting by queryname is complete."
