#!/bin/bash

#SBATCH --job-name=multiqc_job
#SBATCH --output="/home/achopra/BPA_Alt_Human/BPA/scratch/multiqc_%j.out"
#SBATCH --error="/home/achopra/BPA_Alt_Human/BPA/scratch/multiqc_%j.err"
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=02:00:00

# README sbatch multiqc.sh

# Activate the environment where MultiQC is installed
source activate /home/achopra/miniconda3/envs/multiqc  

INPUT_FILE="/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/input/test.txt"
FASTP_REPORT_DIR="/home/achopra/BPA_Alt_Human/BPA/Fast_p/"
MULTIQC_OUTPUT_DIR="/home/achopra/BPA_Alt_Human/BPA/Multi_qc/"

if [[ ! -f $INPUT_FILE ]]; then
   echo "Please provide a valid input file."
   exit 1
fi

> ${FASTP_REPORT_DIR}directories.txt

# Loop through each line in the input file
while read -r line; do
    if [[ -z "${line}" ]]; then
        continue
    fi
    SRA_ID=$(echo "$line" | xargs)

    # Append the directory path to directories.txt
    echo "${FASTP_REPORT_DIR}${SRA_ID}" >> "${FASTP_REPORT_DIR}directories.txt"

done < "$INPUT_FILE"

multiqc --file-list "${FASTP_REPORT_DIR}directories.txt" -o "$MULTIQC_OUTPUT_DIR"
