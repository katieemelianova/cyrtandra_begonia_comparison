
library(dplyr)
library(magrittr)

cafe<-read.table("cyrtandra_counts_formatted", header=TRUE)


cafe %<>% filter(ccrockerella/(ccrockerella + dhygrometrica + cserratifolia) > 0.1 &
                   dhygrometrica/(ccrockerella + dhygrometrica + cserratifolia) > 0.1 &
                   cserratifolia/(ccrockerella + dhygrometrica + cserratifolia) > 0.1)

write.table(cafe, file="cyrtandra_counts_filtered", row.names = FALSE, col.names = TRUE, quote = FALSE, sep = "\t")


