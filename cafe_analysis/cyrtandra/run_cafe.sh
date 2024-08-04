




# get the counts without total, renaming column names to something tidier
cat Orthogroups.GeneCount.tsv| awk '{print $1,$2,$3,$4}' | sed 's/ /\t/g' | sed 's/crockerella.fasta.transdecoder/ccrockerella/g' | sed 's/dorcoceras.fasta.transdecoder/dhygrometrica/g' | sed 's/serratifolia.fasta.transdecoder/cserratifolia/g' > cyrtandra_counts

cat cyrtandra_species_timetree.newick | sed 's/crockerella.fasta.transdecoder/ccrockerella/g' | sed 's/dorcoceras.fasta.transdecoder/dhygrometrica/g' | sed 's/serratifolia.fasta.transdecoder/cserratifolia/g' > cyrtandra_species_timetree.renamed.newick

# get the orthogroup names and add then in as another column in front
# this makes two identical orthogroup columns but cafe requires this format
cut -f 1 cyrtandra_counts > OG_column
paste OG_column cyrtandra_counts > cyrtandra_counts_formatted

# remove intermediate files
rm cyrtandra_counts OG_column

# filter out too high or too low counts
Rscript filter_cyrtandra_counts.R

# run cafe first to generate error model
cafe5 --infile cyrtandra_counts_filtered --tree cyrtandra_species_timetree.renamed.newick --error_model

# then run cafe again provifing error model
cafe5 --infile cyrtandra_counts_filtered --tree cyrtandra_species_timetree.renamed.newick -eresults/Base_error_model.txt
