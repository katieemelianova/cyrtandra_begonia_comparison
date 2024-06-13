#!/bin/bash
#
#SBATCH --cpus-per-task=8
#SBATCH --mem=10GB
#SBATCH --partition=basic
#SBATCH --job-name=boilerplate
#SBATCH --time=1-00:00:00

module load orthofinder
module load iqtree
module load mafft

orthofinder.py -f transdecoder_begonia_fastas -M msa -T iqtree
