#!/bin/bash
#
#SBATCH --cpus-per-task=32
#SBATCH --mem=50GB
#SBATCH --partition=basic
#SBATCH --job-name=hmmer
#SBATCH --time=2-00:00:00

module load hmmer

conchifolia="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/conchifolia.fasta.transdecoder_dir/longest_orfs.pep"
crockerella="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/crockerella.fasta.transdecoder_dir/longest_orfs.pep"
dorcoceras="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/dorcoceras.fasta.transdecoder_dir/longest_orfs.pep"
hillebrandia="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/hillebrandia.fasta.transdecoder_dir/longest_orfs.pep"
plebeja="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/plebeja.fasta.transdecoder_dir/longest_orfs.pep"
serratifolia="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/serratifolia.fasta.transdecoder_dir/longest_orfs.pep"

hmmsearch --cpu 32 -E 1e-10 --domtblout conchifolia_pfam Pfam-A.hmm $conchifolia
hmmsearch --cpu 32 -E 1e-10 --domtblout crockerella_pfam Pfam-A.hmm $crockerella
hmmsearch --cpu 32 -E 1e-10 --domtblout dorcoceras_pfam Pfam-A.hmm $dorcoceras
hmmsearch --cpu 32 -E 1e-10 --domtblout hillebrandia_pfam Pfam-A.hmm $hillebrandia
hmmsearch --cpu 32 -E 1e-10 --domtblout plebeja_pfam Pfam-A.hmm $plebeja
hmmsearch --cpu 32 -E 1e-10 --domtblout serratifolia_pfam Pfam-A.hmm $serratifolia

