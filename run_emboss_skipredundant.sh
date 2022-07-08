#!/bin/bash

#SBATCH --partition=short
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G


skipredundant -sequences Hsand_mRNA.fasta -threshold 90 -outseq emboss_out -gapextend 0.5 -gapopen 10 -mode 1 -redundantoutseq redundant_hsand
