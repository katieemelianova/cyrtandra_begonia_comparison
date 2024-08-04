library(ggplot2)
library(magrittr)
library(dplyr)
library(readr)
library(reshape2)
library(ggtree)
library(cowplot)


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
pdf("significant_nonsignificant_orthogroups.pdf", width=35, height=32)
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



