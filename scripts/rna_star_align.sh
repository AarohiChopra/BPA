#!/bin/bash
#SBATCH --job-name=rna_align
#SBATCH --output="/home/achopra/BPA_Alt_Human/BPA/scratch/rna_align_%j.out"
#SBATCH --error="/home/achopra/BPA_Alt_Human/BPA/scratch/rna_align_%j.err"
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem 72G
#SBATCH --time=012:00:00
#SBATCH --mail-user=aarohi.chopra@sjsu.edu

# README sbatch rna_star_align.sh

source activate /home/achopra/miniconda3/envs/bpaenv

BASE_DIR="/home/achopra/BPA_Alt_Human/BPA/"
INPUT_FILE="/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/input/test.txt"
INPUT_DIR="/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/"
GENOME_DIR="/home/achopra/BPA_Alt_Human/BPA/Mapping"

if [[ ! -f $INPUT_FILE ]]; then
   echo "Please provide a valid input file."
   exit 1
fi

cat "$INPUT_FILE" | while read -r line; do
        if [[ -z "${line}" ]]; then
                continue
        fi
        SRA_ID=$(echo "$line" | xargs)

	mkdir "${BASE_DIR}STAR_output/${SRA_ID}"

	STAR --runMode alignReads \
     	     --genomeDir $GENOME_DIR \
     	     --runThreadN 4 \
     	     --readFilesIn "${INPUT_DIR}${SRA_ID}/${SRA_ID}.fastq" \
     	     --outFileNamePrefix "${BASE_DIR}STAR_output/${SRA_ID}/${SRA_ID}" \
     	     --outTmpDir "${BASE_DIR}RNAscratch" \
     	     --outSAMtype BAM Unsorted

done

echo "STAR alignment is complete." 
