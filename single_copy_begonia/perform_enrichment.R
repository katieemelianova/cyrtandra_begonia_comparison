if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("topGO")

library(topGO)
library(magrittr)
library(dplyr)

# for the GO term enrichment tests
mp_con<-readMappings("/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/2024_begonia/supplementary_file_3_con_trinotate_annotation_GO")
mp_ple<-readMappings("/lisc/scratch/botany/katie/cyrtandra_begonia_comparison/2024_begonia/supplementary_file_4_ple_trinotate_annotation_GO")

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

conchifolia_significant_transcripts<-read.table("conchifolia_significant_transcripts") %>% dplyr::select(V1) %>% pull()
plebeja_significant_transcripts<-read.table("plebeja_significant_transcripts") %>% dplyr::select(V1) %>% pull()

con_enrich<-get_enriched_terms(conchifolia_significant_transcripts, mp_con)
ple_enrich<-get_enriched_terms(plebeja_significant_transcripts, mp_ple)

con_enrich %<>% filter(as.numeric(classicFisher) < 0.05)
ple_enrich %<>% filter(as.numeric(classicFisher) < 0.05)

both_enrich<-inner_join(con_enrich, ple_enrich, by="GO.ID")
cols_to_select<-c("GO.ID", "Term.x", "Annotated.x", "Significant.x", "Expected.x", "classicFisher.x", "Term.y", "Annotated.y", "Significant.y", "Expected.y", "classicFisher.y")
both_enrich %<>% dplyr::select(cols_to_select)
write.table(both_enrich, file="begonia_enriched_terms", quote=FALSE, col.names=FALSE, sep="\t")
