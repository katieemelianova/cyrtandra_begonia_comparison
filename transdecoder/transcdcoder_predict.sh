#!/bin/bash
#
#SBATCH --cpus-per-task=8
#SBATCH --mem=10GB
#SBATCH --partition=basic
#SBATCH --job-name=transpredict
#SBATCH --time=1-00:00:00

module load transdecoder

TransDecoder.Predict -t /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/fastas/conchifolia.fasta --retain_pfam_hits conchifolia_pfam --retain_blastp_hits conchifolia_blastp
TransDecoder.Predict -t /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/fastas/crockerella.fasta --retain_pfam_hits crockerella_pfam --retain_blastp_hits crockerella_blastp
TransDecoder.Predict -t /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/fastas/dorcoceras.fasta --retain_pfam_hits dorcoceras_pfam --retain_blastp_hits dorcoceras_blastp
TransDecoder.Predict -t /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/fastas/hillebrandia.fasta --retain_pfam_hits hillebrandia_pfam --retain_blastp_hits hillebrandia_blastp
TransDecoder.Predict -t /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/fastas/plebeja.fasta --retain_pfam_hits plebeja_pfam --retain_blastp_hits plebeja_blastp
TransDecoder.Predict -t /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/fastas/serratifolia.fasta --retain_pfam_hits serratifolia_pfam --retain_blastp_hits serratifolia_blastp

