cat Orthogroups.GeneCount.tsv| awk '{print $1,$2,$3,$4,$5}' | sed 's/ /\t/g' |  sed 's/Datisca_glomerata_v1_b2.cds.fasta.transdecoder/datisca/g' | sed 's/conchifolia.fasta.transdecoder/bconchifolia/g' | sed 's/hillebrandia.fasta.transdecoder/hsandwicensis/g' | sed 's/plebeja.fasta.transdecoder/bplebeja/g' > begonia_counts

cut -f 1 begonia_counts > OG_column
paste OG_column begonia_counts > begonia_counts_formatted

