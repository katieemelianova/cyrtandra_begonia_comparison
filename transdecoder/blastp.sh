#!/bin/bash
#
#SBATCH --cpus-per-task=32
#SBATCH --mem=50GB
#SBATCH --partition=basic
#SBATCH --job-name=blastp
#SBATCH --time=2-00:00:00

module load ncbiblastplus

conchifolia="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/conchifolia.fasta.transdecoder_dir/longest_orfs.pep"
crockerella="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/crockerella.fasta.transdecoder_dir/longest_orfs.pep"
dorcoceras="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/dorcoceras.fasta.transdecoder_dir/longest_orfs.pep"
hillebrandia="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/hillebrandia.fasta.transdecoder_dir/longest_orfs.pep"
plebeja="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/plebeja.fasta.transdecoder_dir/longest_orfs.pep"
serratifolia="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/serratifolia.fasta.transdecoder_dir/longest_orfs.pep"
streptocarpus="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/PG_Sr_cds_nuc.fa.transdecoder_dir/longest_orfs.pep"
datisca="/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/Datisca_glomerata_v1_b2.cds.fasta.transdecoder_dir/longest_orfs.pep"

blastp -query $conchifolia -db uniprot_sprot.fasta -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 32 > conchifolia_blastp
blastp -query $crockerella -db uniprot_sprot.fasta -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 32 > crockerella_blastp
blastp -query $dorcoceras -db uniprot_sprot.fasta -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 32 > dorcoceras_blastp
blastp -query $hillebrandia -db uniprot_sprot.fasta -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 32 > hillebrandia_blastp
blastp -query $plebeja -db uniprot_sprot.fasta -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 32 > plebeja_blastp
blastp -query $serratifolia -db uniprot_sprot.fasta -max_target_seqs 1 -outfmt 6 -evalue 1e-5 -num_threads 32 > serratifolia_blastp

