#!/bin/bash
#
#SBATCH --cpus-per-task=8
#SBATCH --mem=10GB
#SBATCH --partition=basic
#SBATCH --job-name=transpredict
#SBATCH --time=1-00:00:00

module load transdecoder

TransDecoder.LongOrfs -t /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/fastas/conchifolia.fasta -m 100
TransDecoder.LongOrfs -t /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/fastas/dorcoceras.fasta -m 100
TransDecoder.LongOrfs -t /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/fastas/hillebrandia.fasta -m 100
TransDecoder.LongOrfs -t /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/fastas/plebeja.fasta -m 100
TransDecoder.LongOrfs -t /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/fastas/crockerella.fasta -m 100
TransDecoder.LongOrfs -t /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/fastas/serratifolia.fasta -m 100


