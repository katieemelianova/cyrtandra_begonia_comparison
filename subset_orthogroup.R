library(readr)
library(magrittr)

# read in the orthogroup size tsv
#o<-read_tsv("begonia_cyrtandra_fastas/OrthoFinder/Results_Jul04/Orthogroups/Orthogroups.GeneCount.tsv")
o<-read_tsv("/home/kemelian/cyrtandra_begonia_comparison/orthofinder_fastas/OrthoFinder/Results_Jul08/Orthogroups/Orthogroups.GeneCount.tsv")

# the first column is orthogroup and the last is total
# this gets the column names excluding the first and the last to give just orthogroup counts
# if we want to stipulate that some specific species have above 0 orthogroup counts, we can change the colnames to be a vector of column names referring to specific species
coln<-colnames(o)[2:length(colnames(o))-1]

# get the indices for rows where at least 5 on the taxa have non-zero representatives in orthogroup
indices<-rowSums(o[,coln] !=0) > 5

# use the indices to get relevant rows from the total orthogroup data
o_subset<-o[indices,]

# write to file
write_delim(o_subset, "Orthogroups.GeneCount.subset.tsv", delim = "\t", quote="none")
