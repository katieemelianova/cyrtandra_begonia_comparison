library(dplyr)
library(magrittr)

# read in allequal and foeground model lnL output files
begonia_allequal<-read.table("paml_begonia_allequal.lnL.og.txt") %>% mutate(comparison="all_equal") %>% dplyr::select("V1", "V6", "comparison")
begonia_foreground<-read.table("paml_begonia_foreground.lnL.og.txt") %>% mutate(comparison="foreground") %>% dplyr::select("V1", "V6", "comparison")

# join lnLs from both models by the orthogroup name, caöculate chi-square p-value, filter signifivcaynt orthogroups
begonia_significant<-inner_join(begonia_allequal, begonia_foreground, by="V1") %>% mutate(pvalue=pchisq(-2*(V6.x - V6.y), df=1, lower.tail = FALSE)) %>% filter(pvalue < 0.05)
begonia_not_significant<-inner_join(begonia_allequal, begonia_foreground, by="V1") %>% mutate(pvalue=pchisq(-2*(V6.x - V6.y), df=1, lower.tail = FALSE)) %>% filter(pvalue > 0.05)

# write to output
begonia_significant %>% dplyr::select(V1) %>% write.table(file="paml_begonia_significant_orthogroups", quote = FALSE, col.names = FALSE, row.names = FALSE)
begonia_not_significant %>% dplyr::select(V1) %>% write.table(file="paml_begonia_not_significant_orthogroups", quote = FALSE, col.names = FALSE, row.names = FALSE)


