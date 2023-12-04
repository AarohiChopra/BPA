#!/bin/bash

#SBATCH --job-name=fastp_job
#SBATCH --output="/home/achopra/BPA_Alt_Human/BPA/scratch/fastp_%j.out"
#SBATCH --error="/home/achopra/BPA_Alt_Human/BPA/scratch/fastp_%j.err"
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=12:00:00

# README sbatch fast_p.sh

source activate /home/achopra/miniconda3/envs/fastp  # Load fastp module, if available

# Specify the input file and output directories
INPUT_FILE="/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/input/test.txt"
INPUT_DIR="/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/"
TRIMMED_DIR="/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/"  # Directory for trimmed files
FASTP_REPORT_DIR="/home/achopra/BPA_Alt_Human/BPA/Fast_p/"  # Directory for fastp reports

# Create the trimmed output directory and fastp report directory if they don't exist


if [[ ! -f $INPUT_FILE ]]; then
   echo "Please provide a valid input file."
   exit 1
fi

cat "$INPUT_FILE" | while read -r line; do
	if [[ -z "${line}" ]]; then
       		continue
	fi
	SRA_ID=$(echo "$line" | xargs)

	# make directory for reports 
	mkdir ${FASTP_REPORT_DIR}${SRA_ID}

	# Run fastp for adapter trimming and quality filtering
	fastp \
		-i "${INPUT_DIR}${SRA_ID}/${SRA_ID}.fastq" \
		-o "${TRIMMED_DIR}${SRA_ID}/${SRA_ID}_trimmed.fastq" \
		-h "${FASTP_REPORT_DIR}${SRA_ID}/${SRA_ID}_fastp.html" \
		-j "${FASTP_REPORT_DIR}${SRA_ID}/${SRA_ID}_fastp.json"
#        rm "${INPUT_DIR}${SRA_ID}/${SRA_ID}.fastq"
done
