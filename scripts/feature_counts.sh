#!/bin/bash
#SBATCH --job-name=feature_counts
#SBATCH --output="/home/achopra/BPA_Alt_Human/BPA/scratch/feature_counts_%j.out"
#SBATCH --error="/home/achopra/BPA_Alt_Human/BPA/scratch/feature_counts_%j.err"
#SBATCH --ntasks=4
#SBATCH --mem=32G 
#SBATCH --time=06:00:00

# The purpose of this script is to use mapped, query sorted, deduplicated, and coordinate sorted reads to get gene counts.

# README sbatch feature_counts.sh

# Load env
source activate /home/achopra/miniconda3/envs/featurecounts

# Specify the input file and output directories
INPUT_FILE="/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/input/test.txt"
ANNOTATION_PATH="/home/achopra/BPA_Alt_Human/BPA/Human_ref_files/hg38.ncbiRefSeq.gtf"
OUTPUT_DIR="/home/achopra/BPA_Alt_Human/BPA/Feature_counts/"
INPUT_BAM="/home/achopra/BPA_Alt_Human/BPA/Picard_coordinate/"

if [[ ! -f $INPUT_FILE ]]; then
   echo "Please provide a valid input file."
   exit 1
fi

cat "$INPUT_FILE" | while read -r line; do
        if [[ -z "${line}" ]]; then
                continue
        fi
	SRA_ID=$(echo "$line" | xargs)

	mkdir ${OUTPUT_DIR}${SRA_ID}

	# Run feaure counts
	featureCounts -T 5 \
        	      -t exon \
        	      -g gene_id \
        	      -a "${ANNOTATION_PATH}" \
       	              -o "${OUTPUT_DIR}${SRA_ID}/${SRA_ID}.txt" \
                      "${INPUT_BAM}${SRA_ID}/${SRA_ID}.bam"
    	if [[ $? -ne 0 ]]; then
        	echo "featureCounts encountered an error for ${SRA_ID}."
        continue  # or 'exit 1' if you want to stop the entire process
    	fi

done 

echo "Feature counts processing complete."
