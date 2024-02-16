#!/bin/bash
#SBATCH --job-name=deseq_analysis
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=4:00:00
#SBATCH --mem=4G
#SBATCH --output="/home/achopra/BPA_Alt_Human/BPA/scratch/deseq2_analysis_%j.log"
#SBATCH --error="/home/achopra/BPA_Alt_Human/BPA/scratch/deseq2_analysis_%j.err"

source activate /home/achopra/miniconda3/envs/deseq2

Rscript deseq_analysis.R
