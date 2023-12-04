#!/bin/bash
#SBATCH --job-name=my_job
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G 
#SBATCH --time=06:00:00
#SBATCH --mail-user=aarohi.chopra@sjsu.edu
# Authored by: Aarohi Chopra
# Reference Material:
# STAR manual 2.7.10b by Alexander Dobin October 20, 2022
####### LOAD PACKAGES ########
source activate /home/achopra/miniconda3/envs/bpaenv
#conda init bash
#conda activate bpaenv

genomeDir="/home/achopra/BPA/Mapping"

genomeFasta="/home/wlee/genomes/human/hg38/dna/hg38.fa"

STAR --runThreadN 4 \
     --runMode genomeGenerate \
     --genomeDir $genomeDir \
     --genomeFastaFiles $genomeFasta \
     --sjdbGTFfile /home/achopra/BPA/human_ref_files/hg38.ncbiRefSeq.gtf \
     --sjdbOverhang 51 \
     --outFileNamePrefix /home/achopra/BPA/STAR_output/STAR_output 

echo "STAR genome generation is complete."
