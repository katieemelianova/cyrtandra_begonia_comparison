library(paleotree)


###############################################################################
#  this script uses the interactive function of the chronos timetree module   #
#   It automatically dates tree nodes according to user definition            #
#   The node dates which IUn input are indicated below for each species pair  # 
###############################################################################


# I ran into issues when my min and max values were the same. Make sure that they differ.

nwk_begonia<-ape::read.tree("~Desktop/BegoniaCyrtandra/2024_cafe/begonia/begonia_species_tree.newick")
nwk_cyrtandra<-ape::read.tree("~/Desktop/BegoniaCyrtandra/2024_cafe/cyrtandra/cyrtandra_species_tree.newick")

#nwk_chronos<-chronos(nwk)
#nwk_chronos_control<-chronos.control(nwk)
#attr(nwk_chronos, "rates")

# Hil <> Beg 39.9 40.1
# Con <> Ple 4.9 5.1
cal_begonia<-makeChronosCalib(nwk_begonia, interactive = TRUE)

# Dor <> Cyr 25.9 26.1
# Cro <> Ser 14.9 15.1
cal_cyrtandra<-makeChronosCalib(nwk_cyrtandra, interactive = TRUE)

mytimetree_begonia <- chronos(nwk_begonia, lambda = 1, model = "correlated", calibration = cal_begonia, control = chronos.control())
mytimetree_cyrtandra<- chronos(nwk_cyrtandra, lambda = 1, model = "correlated", calibration = cal_cyrtandra, control = chronos.control())

write.tree(mytimetree_begonia, 
           file = "/Users/katieemelianova/Desktop/BegoniaCyrtandra/2024_cafe/begonia/begonia_species_timetree.newick", 
           append = FALSE,
           digits = 10, 
           tree.names = FALSE)

write.tree(mytimetree_cyrtandra, 
           file = "/Users/katieemelianova/Desktop/BegoniaCyrtandra/2024_cafe/cyrtandra/cyrtandra_species_timetree.newick", 
           append = FALSE,
           digits = 10, 
           tree.names = FALSE)

