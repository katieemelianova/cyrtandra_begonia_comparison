#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=20GB
#SBATCH --partition=basic
#SBATCH --job-name=orthofinder
#SBATCH --time=1-00:00:00


module load orthofinder
module load iqtree
module load mafft

orthofinder.py -f transdecoder_cyrtandra_fastas -M msa -T iqtree
