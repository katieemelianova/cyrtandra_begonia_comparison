setwd("~/Desktop/BegoniaCyrtandra/2024_cafe/")
library(ggtree)
library(ggplot2)
library(cowplot)

############################################
#                make the trees            #
############################################

nwk_cyrtandra<-ape::read.tree("cyrtandra/cyrtandra_species_timetree.renamed.newick")
nwk_begonia<-ape::read.tree("begonia/begonia_species_timetree.renamed.newick")

width_height = 0.37
hjust=-0.0000000000009
tipsize=10

nwk_cyrtandra$tip.label<-c("           D. hygrometrica", "C. serratifolia    ", "C. crockerella   ")
nwk_begonia$tip.label<-c("H. sandwicensis  ", "  B. conchifolia       ", "B. plebeja            ")

pb<-ggtree(nwk_begonia, size=2) + geom_tiplab(size=15, hjust=0.8, offset=26)
pc<-ggtree(nwk_cyrtandra, size=2) + geom_tiplab(size=15, hjust=0.9, offset=14)

############################################
#     transcribe cyrtandra cafe output     #
############################################

# IDs of nodes:(dhygrometrica<1>,(ccrockerella<2>,cserratifolia<3>)<5>)<4>
# Output format for: ' Average Expansion', 'Expansions', 'No Change', 'Contractions', and 'Branch-specific P-values' = (node ID, node ID): (1,5) (2,3) 
#Average Expansion:      (-0.0492958,-0.01333)   (0.0885312,0.127138)
#Expansion :     (635,60)        (944,1073)
#Remain :        (6369,7751)     (6594,6528)
#Decrease :      (948,141)       (414,351)

pies_cyrtandra<-data.frame(expansion=c(635, 60, 944, 1073),
                           remain=c(6369, 7751, 6594, 6528),
                           decrease=c(948, 141, 414, 351))
pies_cyrtandra$node<-c(1, 5, 2, 3)
pies_cyrtandra <- nodepie(pies_cyrtandra, cols=1:3)
pies_cyrtandra <- lapply(pies_cyrtandra, function(g) g + scale_fill_manual(values = c("blue2", "firebrick2", "gray83"))) 
p2_cyrtandra <- inset(pc, pies_cyrtandra, width=width_height, height=width_height) + expand_limits(x = 0.17)


############################################
#     transcribe begonia cafe output       #
############################################

# IDs of nodes:(hsandwicensis<1>,(bconchifolia<2>,bplebeja<3>)<5>)<4>
# Output format for: ' Average Expansion', 'Expansions', 'No Change', 'Contractions', and 'Branch-specific P-values' = (node ID, node ID): (1,5) (2,3) 
#Average Expansion:      (-0.0197265,-0.223567)  (0.00223567,0.0524724)
#Expansion :     (515,165)       (530,653)
#Remain :        (6410,5693)     (6551,6533)
#Decrease :      (679,1746)      (523,418)


pies_begonia<-data.frame(expansion=c(515, 165, 530, 653),
                         remain=c(6410, 5693, 6551, 6533),
                         decrease=c(679, 1746, 523, 418))
pies_begonia$node<-c(1, 5, 2, 3)

pies_begonia <- nodepie(pies_begonia, cols=1:3)
pies_begonia <- lapply(pies_begonia, function(g) g + scale_fill_manual(values = c("blue2", "firebrick2", "gray83"))) 
p2_begonia <- inset(pb, pies_begonia, width=width_height, height=width_height) + expand_limits(x = 0.3)


############################################
#        plot cafe results on trees        #
############################################

pdf("Figure3_CAFE_pietree.pdf", width=15, height=17)
plot_grid(p2_cyrtandra, 
          p2_begonia, 
          labels = c('Cyrtandra', 'Begonia'),
          ncol = 1,
          label_size = 40)
dev.off()


# plot the legend separately, this gets put together in CAFE_pie_composite.pptx and exported as PDF
pdf("Figure3_CAFE_legend.pdf", width=3, height=3)
plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
legend("topleft", legend =c('Expansion', 'Remain', 'Decrease'), pch=16, pt.cex=3, cex=1.5, bty='n',
       col = c('firebrick2', 'gray83', 'blue2'))
dev.off()


