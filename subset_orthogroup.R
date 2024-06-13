library(readr)
library(magrittr)

# read in the orthogroup size tsv
o <- file("stdin")
o <- read_tsv(o)
#o<-read_tsv("orthofinder_fastas/OrthoFinder/Results_Aug22/Orthogroups/Orthogroups.GeneCount.tsv")

# the first column is orthogroup and the last is total
# this gets the column names excluding the first and the last to give just orthogroup counts
# if we want to stipulate that some specific species have above 0 orthogroup counts, we can change the colnames to be a vector of column names referring to specific species
start<-2
end<-length(colnames(o))-1
coln<-(colnames(o)[start:end])

# get the indices for rows where at least 5 on the taxa have non-zero representatives in orthogroup
indices1<-which(rowSums(o[,coln] !=0) > 5)

# optionally get the indices for the rows where the total number of genes in a family is less than 40 (eliminates massive families for testing purposes_
indices2<-which(rowSums(o[,coln]) < 40)

# merge the two types of indices to get gene families fitting both criteria
common_indices<-intersect(indices1, indices2)

# use the indices to get relevant rows from the total orthogroup data
o_subset<-o[common_indices,]

# write to file
write_delim(o_subset, "Orthogroups.GeneCount.subset.tsv", delim = "\t", quote="none")
