#!/bin/bash

#SBATCH --job-name=my_job
#SBATCH --output="/home/achopra/BPA_Alt_Human/BPA/scratch/download_sra_%j.out"
#SBATCH --error="/home/achopra/BPA_Alt_Human/BPA/scratch/download_sra_%j.err"
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=12:00:00

# README sbatch fastq_dump.sh /home/achopra/BPA_Alt_Human/BPA/Fastq_dump/input/test.txt

module load sratoolkit-3.0.2

ACCESSION_FILE=$1

if [[ ! -f $ACCESSION_FILE ]]; then
   echo "Please provide a valid accession file."
   exit 1
fi

while read -r SRA_ID; do
   if [[ -z "${SRA_ID}" ]]; then 
       continue
   fi
  
# Output Directory
   OUT_DIR="/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/${SRA_ID}"

# Create output directory if it does not exist
   mkdir -p $OUT_DIR

# Prefetch the data 
   prefetch ${SRA_ID}

# Run fasterq-dump
   fasterq-dump $SRA_ID -O $OUT_DIR -e ${SLURM_CPUS_PER_TASK} --skip-technical

# Check if the current directory contains a copy of the directory 
   if [ -d ${SRA_ID} ]; then
   	rm -r ${SRA_ID}
   fi
 
# Output
   echo "Download of $SRA_ID completed. Output is in $OUT_DIR"
done < "$ACCESSION_FILE"
