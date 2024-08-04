
library(dplyr)
library(magrittr)

cafe<-read.table("begonia_counts_formatted", header=TRUE)

cafe %<>% filter(bconchifolia/(bconchifolia + hsandwicensis + bplebeja) > 0.1 &
                   hsandwicensis/(bconchifolia + hsandwicensis + bplebeja) > 0.1 &
                   bplebeja/(bconchifolia + hsandwicensis + bplebeja) > 0.1)

write.table(cafe, file="begonia_counts_filtered", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")



