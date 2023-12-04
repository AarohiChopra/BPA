#!/bin/bash

#SBATCH --job-name=my_job
#SBATCH --output="/home/achopra/BPA_Alt_Human/BPA/scratch/quality_check_%j.out"
#SBATCH --error="/home/achopra/BPA_Alt_Human/BPA/scratch/quality_check_%j.err"
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=12:00:00

# README sbatch fast_qc.sh

module load fastqc

# Specify the input file and output directory
INPUT_FILE="/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/input/test.txt"
INPUT_DIR="/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/"

if [[ ! -f $INPUT_FILE ]]; then
   echo "Please provide a valid input file."
   exit 1
fi

OUTPUT_DIR="/home/achopra/BPA_Alt_Human/BPA/Fast_qc/"

cat "$INPUT_FILE" | while read -r line; do
	if [[ -z "${line}" ]]; then
       		continue
	fi
	SRA_ID=$(echo "$line" | xargs)
	# Run FastQC on the input file and specify the output directory
	mkdir "${OUTPUT_DIR}${SRA_ID}"
	fastqc "${INPUT_DIR}${SRA_ID}/${SRA_ID}.fastq" --outdir "${OUTPUT_DIR}${SRA_ID}"
done 
