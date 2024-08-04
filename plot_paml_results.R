library(ggplot2)
library(magrittr)
library(dplyr)
library(readr)
library(reshape2)
library(ggtree)
library(cowplot)
library(pheatmap)
library(GOSemSim)

#################################################################################################
#     plot boxplot of dN/dS in significant orthogroups in foreground and background branches    #
#################################################################################################

cyrtandra_dnds<-read_delim("single_copy_cyrtandra/cyrtandra_significant_dnds.txt", col_names = FALSE) %>% dplyr::select("X6", "X7") %>% set_colnames(c("background", "foreground")) %>% filter(background < 2 & foreground < 2) %>% mutate(Genus="Cyrtandra")
begonia_dnds<-read_delim("single_copy_begonia/begonia_significant_dnds.txt", col_names = FALSE) %>% dplyr::select("X6", "X7") %>% set_colnames(c("background", "foreground")) %>% filter(background < 2 & foreground < 2) %>% mutate(Genus="Begonia")
dnds<-rbind(cyrtandra_dnds, begonia_dnds) %>% melt()

boxplot_dnds<-ggplot(data = dnds, aes(x=variable, y=value, fill=variable)) + 
  geom_boxplot(linewidth = 3) +
  ylab("dN/dS") + 
  xlab("Branch") +
  theme(text = element_text(size =80),
        strip.text.x = element_text(size = 55),
        legend.position="none") +
  facet_wrap(~Genus, scales="free", ncol = 1) +
  scale_fill_manual(values = c("royalblue1", "violetred")) +
  scale_colour_manual(values = c("royalblue1", "violetred"))


###########################################################
#     plot schematic of speciose and non speciose taxa    #
###########################################################

nwk<-ape::read.tree("significant_nonsignificant_orthogroups.newick")
groupInfo<-split(nwk$tip.label, nwk$tip.label)
nwk <- groupOTU(nwk, groupInfo)
nwk$tip.label<-c("non-speciose", "speciose", "speciose")

tree_plot<-ggtree(nwk, aes(colour=group), size=7) + geom_tiplab(size=25, offset=2.1, hjust=1.2, show_guide  = FALSE, show.legend = FALSE) +
  theme(legend.position = c(0.05, 1.02),
        legend.justification = c(0,1),
        legend.title=element_blank(), legend.text=element_text(size=60), legend.key.size = unit(5,"line")) +
  scale_fill_manual(values = c("royalblue1", "violetred")) +
  scale_colour_manual(values = c("royalblue1", "violetred"))


###############################################################################
#     plot proportion of significant and non-significant dN/dS orthogroups    #
###############################################################################


begonia_sig_nonsig_count <- read.table("single_copy_begonia/begonia_sig_nonsig_count.txt")
cyrtandra_sig_nonsig_count <- read.table("single_copy_cyrtandra/cyrtandra_sig_nonsig_count.txt")
sig_nonsig_count<- rbind(begonia_sig_nonsig_count, cyrtandra_sig_nonsig_count) %>% pull("V1")
sig_nonsig<-data.frame(genus=c(rep("Begonia", 2), rep("Cyrtandra", 2)),
                       number_orthogroups=sig_nonsig_count,
                       status=c("Non-Significant", "Significant", "Non-Significant", "Significant"))


orthogroup_plot<-ggplot(data = sig_nonsig, aes(y = number_orthogroups, x=genus,
                                               colour = status, fill = status)) + 
  geom_bar(stat="identity") +
  ylab("Number of Single Copy Orthogroups") + 
  xlab("Genus") +
  theme(text = element_text(size =47),
        legend.key.size = unit(3, 'cm'), 
        legend.key.height = unit(2, 'cm'), 
        legend.key.width = unit(2, 'cm')) +
  labs(fill='Change in Foreground\nBranch Selection', colour='Change in Foreground\nBranch Selection') +
  scale_fill_manual(values = c("royalblue1", "violetred")) +
  scale_colour_manual(values = c("royalblue1", "violetred"))

#png("significant_nonsignificant_orthogroups.png", width=2700, height=2000)
pdf("Figure1_significant_nonsignificant_orthogroups.pdf", width=35, height=32)
one<-plot_grid(tree_plot, 
          orthogroup_plot, 
          ncol = 1,
          label_size = 80,
          labels=c("A", "B"),
          vjust=c(1.01, 0.2),
          hjust=c(-0.2,-0.3))
two<-plot_grid(one, boxplot_dnds, ncol=2, 
               rel_widths=c(3,2.5), 
               labels=c("", "C"), 
               label_size = 80, 
               hjust=c(1,1), 
               vjust=c(2, 1.1))
two
dev.off()


#################################
#.     go semantic clustering.  #
#################################

# get Arabidopsis annotation
atGO <- godata('org.At.tair.db', ont="BP")

# read in begonia and cyrtandra analysis GO terms
begonia_enriched_terms_semSim<-read_delim("single_copy_begonia/begonia_enriched_terms", col_names = TRUE) %>% filter(as.numeric(classicFisher.x) < 0.05 & as.numeric(classicFisher.y) < 0.05 & Significant.x/Annotated.x > 0.1) %>% pull(GO.ID, Term.x)
cyrtandra_enriched_terms_semSim<-read_delim("single_copy_cyrtandra/cyrtandra_enriched_terms", col_names = TRUE) %>% filter(as.numeric(classicFisher.x) < 0.05 & as.numeric(classicFisher.y) < 0.05 & Significant.x/Annotated.x > 0.1) %>% pull(GO.ID, Term.x)

# set rows as begonia, cols as cyrtandra
begonia_cyrtandra_semSim_result<-mgoSim(begonia_enriched_terms_semSim, cyrtandra_enriched_terms_semSim, semData=atGO, measure="Wang", combine=NULL)
colnames(begonia_cyrtandra_semSim_result) <- names(cyrtandra_enriched_terms_semSim)
rownames(begonia_cyrtandra_semSim_result) <- names(begonia_enriched_terms_semSim)

# edit names of GO terms so they fit better
rownames(begonia_cyrtandra_semSim_result)[rownames(begonia_cyrtandra_semSim_result) == "negative regulation of plant-type hypersensitive response"] <- "-ve reg. of plant-type hypersensitive response"
rownames(begonia_cyrtandra_semSim_result)[rownames(begonia_cyrtandra_semSim_result) == "'de novo' pyrimidine nucleobase biosynthetic process"] <- "'de novo' pyrimidine nucleobase bioynth. process" 
colnames(begonia_cyrtandra_semSim_result)[colnames(begonia_cyrtandra_semSim_result) == "negative regulation of post-translational protein modification"] <- "-ve regulation of post-transltnl. prot. modification"
rownames(begonia_cyrtandra_semSim_result)[rownames(begonia_cyrtandra_semSim_result) == "isopentenyl diphosphate biosynthetic process, methylerythritol 4-phosphate pathway"] <- "isopentenyl diphosphate biosynth. proc."
colnames(begonia_cyrtandra_semSim_result)[colnames(begonia_cyrtandra_semSim_result) == "isopentenyl diphosphate biosynthetic process, methylerythritol 4-phosphate pathway"] <- "isopentenyl diphosphate biosynth. proc."
colnames(begonia_cyrtandra_semSim_result)[colnames(begonia_cyrtandra_semSim_result) == "SRP-dependent cotranslational protein targeting to membrane"] <- "SRP-depndt cotrans. prot. targeting to membrane"
colnames(begonia_cyrtandra_semSim_result)[colnames(begonia_cyrtandra_semSim_result) == "isopentenyl diphosphate biosynthetic process, methylerythritol 4-phosphate pathway"] <- "isopentenyl diphosphate biosynth. proc."
colnames(begonia_cyrtandra_semSim_result)[colnames(begonia_cyrtandra_semSim_result) == "regulatory ncRNA-mediated post-transcriptional gene silencing"] <- "reg. ncRNA-mediated post-transcptnl gene silencing"
rownames(begonia_cyrtandra_semSim_result)[rownames(begonia_cyrtandra_semSim_result) == "protein quality control for misfolded or incompletely synthesized proteins"] <- "prot QC for misfolded or incompletely synth. proteins"
rownames(begonia_cyrtandra_semSim_result)[rownames(begonia_cyrtandra_semSim_result) == "regulation of post-transcriptional gene silencing by regulatory ncRNA"] <- "reg of post-transcptnl gene silencing by reg ncRNA"





annotation_row <- data.frame(Begonia = rep("Begonia", nrow(begonia_cyrtandra_semSim_result))) %>% set_rownames(rownames(begonia_cyrtandra_semSim_result))
annotation_col <- data.frame(Cyrtandra = rep("Cyrtandra", ncol(begonia_cyrtandra_semSim_result))) %>% set_rownames(colnames(begonia_cyrtandra_semSim_result))
ann_colors = list(
  Begonia = c("Begonia"="firebrick"),
  Cyrtandra = c("Cyrtandra"="#1B9E77"))

pdf("Figure2_GO_terms_relaxed_selection_heatmap.pdf", width=22, height=20)
pheatmap((begonia_cyrtandra_semSim_result), 
         treeheight_row=0, 
         treeheight_col=0, 
         fontsize = 25, 
         legend=F, 
         angle_col=315,
         annotation_col = annotation_col,
         annotation_row = annotation_row,
         annotation_legend=FALSE,
         clustering_method="ward",
         annotation_colors = ann_colors)
dev.off()




#############################################################################################################################
#      test to see if there is a significant difference between cyrtandra and begonia background and foreground branches    #
#############################################################################################################################


# begonia
t.test(begonia_dnds$foreground, begonia_dnds$background, paired = TRUE, alternative = "greater")

# cyrtandra
t.test(cyrtandra_dnds$foreground, cyrtandra_dnds$background, paired = TRUE, alternative = "greater")



####################################################################
#     get summary statistics of dnds in significant orthogroups    #
####################################################################

dnds %>% filter(Genus == "Cyrtandra", variable == "foreground") %>% dplyr::select(value) %>% summary()
dnds %>% filter(Genus == "Cyrtandra", variable == "background") %>% dplyr::select(value) %>% summary()

dnds %>% filter(Genus == "Begonia", variable == "foreground") %>% dplyr::select(value) %>% summary()
dnds %>% filter(Genus == "Begonia", variable == "background") %>% dplyr::select(value) %>% summary()


