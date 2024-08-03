if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("topGO")

library(topGO)
library(magrittr)
library(dplyr)

# for the GO term enrichment tests
mp_cro<-readMappings("/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/2024_cyrtandra/crockerella.trinotate.GO")
mp_ser<-readMappings("/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/2024_cyrtandra/serratifolia.trinotate.GO")


get_enriched_terms<-function(gene_list, mappings){
  # use the gene 2 GOterms mapping provided for D. incarnata
  geneID2GO<-mappings
  # the input genes form the input, use these to annotate all genes, 1 is present in input list, 0 is absent
  geneSel<-gene_list
  geneSel<-factor(as.integer(names(geneID2GO) %in% geneSel))
  names(geneSel)<-names(geneID2GO)
  
  # set up the topGO object
  sampleGOdata <- new("topGOdata",
                      ontology = "BP",
                      allGenes = geneSel, 
                      nodeSize = 10,
                      annot = annFUN.gene2GO,
                      gene2GO = geneID2GO)
  
  # run three tests, fisher, Kol-Smirn, and Kol-Smirn with elimination
  resultFisher <- runTest(sampleGOdata, algorithm = "weight01", statistic = "fisher")
  resultKS <- runTest(sampleGOdata, algorithm = "weight01", statistic = "ks")
  resultKS.elim <- runTest(sampleGOdata, algorithm = "weight01", statistic = "ks")
  
  # generate summary tane and return it
  allRes <- GenTable(sampleGOdata, classicFisher = resultFisher,
                     classicKS = resultKS, elimKS = resultKS.elim,
                     orderBy = "classicFisher", ranksOf = "classicFisher", topNodes = 100,
                     numChar=1000 )
  #allRes<-GenTable(sampleGOdata, Fis = resultFisher, topNodes = 20)
  return(allRes)
}



crockerella_significant_transcripts<-read.table("crockerella_significant_transcripts") %>% dplyr::select(V1) %>% pull()
serratifolia_significant_transcripts<-read.table("serratifolia_significant_transcripts") %>% dplyr::select(V1) %>% pull()

cro_enrich<-get_enriched_terms(crockerella_significant_transcripts, mp_cro)
ser_enrich<-get_enriched_terms(serratifolia_significant_transcripts, mp_ser)

cro_enrich %<>% filter(as.numeric(classicFisher) < 0.05)
ser_enrich %<>% filter(as.numeric(classicFisher) < 0.05)

both_enrich<-inner_join(cro_enrich, ser_enrich, by="GO.ID")
cols_to_select<-c("GO.ID", "Term.x", "Annotated.x", "Significant.x", "Expected.x", "classicFisher.x", "Term.y", "Annotated.y", "Significant.y", "Expected.y", "classicFisher.y")
both_enrich %<>% dplyr::select(cols_to_select)
write.table(both_enrich, file="cyrtandra_enriched_terms", quote=FALSE, col.names=FALSE, sep="\t")
