

# get the counts without total, renaming column names to something tidier
cat Orthogroups.GeneCount.tsv| awk '{print $1,$2,$3,$4}' | sed 's/ /\t/g' | sed 's/conchifolia.fasta.transdecoder/bconchifolia/g' | sed 's/hillebrandia.fasta.transdecoder/hsandwicensis/g' | sed 's/plebeja.fasta.transdecoder/bplebeja/g' > begonia_counts

cat begonia_species_timetree.newick | sed 's/conchifolia.fasta.transdecoder/bconchifolia/g' | sed 's/hillebrandia.fasta.transdecoder/hsandwicensis/g' | sed 's/plebeja.fasta.transdecoder/bplebeja/g' > begonia_species_timetree.renamed.newick

# get the orthogroup names and add then in as another column in front
# this makes two identical orthogroup columns but cafe requires this format
cut -f 1 begonia_counts > OG_column
paste OG_column begonia_counts > begonia_counts_formatted

# remove intermediate files
rm begonia_counts OG_column

# filter out too high or too low counts
Rscript filter_begonia_counts.R

# run cafe first to generate error model
cafe5 --infile begonia_counts_filtered --tree begonia_species_timetree.renamed.newick --error_model

# then run cafe again provifing error model
cafe5 --infile begonia_counts_filtered --tree begonia_species_timetree.renamed.newick -eresults/Base_error_model.txt
