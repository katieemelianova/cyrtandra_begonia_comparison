

######################################################
#             change into correct directory          #
######################################################
#cd single_copy_begonia


###################################################################
#             extract log likelihoods for each model              #
#          get names for each corresponding orthogroup            #
#     paste log likelihoods alongside corresponding orthogroups   #
###################################################################

for i in `ls single_copy_begonia/OG*fa | xargs -n 1 basename`; do OG=`echo $i | cut -d"." -f 1`; grep "lnL" single_copy_begonia/paml_begonia_allequal/$OG*; done > paml_begonia_allequal.lnL.txt
for i in `ls single_copy_begonia/OG*fa | xargs -n 1 basename`; do OG=`echo $i | cut -d"." -f 1`; grep "lnL" single_copy_begonia/paml_begonia_foreground/$OG*; done > paml_begonia_foreground.lnL.txt
for i in `ls single_copy_begonia/OG*fa | xargs -n 1 basename`; do OG=`echo $i | cut -d"." -f 1`; echo $OG; done > paml_begonia_og.txt


paste paml_begonia_og.txt paml_begonia_foreground.lnL.txt > paml_begonia_foreground.lnL.og.txt
paste paml_begonia_og.txt paml_begonia_allequal.lnL.txt > paml_begonia_allequal.lnL.og.txt


#########################################################################################################
#   run R script to find orthogroups with significynt difference between allequal and foreground model  #
#########################################################################################################

module load R
Rscript get_significant_orthogroups_begonia.R


###############################################################################
#       get the forground and background values of dN/dS for plotting later   #
###############################################################################

while read i; do grep "w (dN/dS) for branches:" single_copy_begonia/paml_begonia_foreground/$i.codeml.out; done < paml_begonia_significant_orthogroups > begonia_significant_dnds.txt 


########################################################################################################################################
#       go through significant orthogroups, pull out seqnames for each foreground species, use that to grep out the sequence IDs       #
########################################################################################################################################


while read i;
do OG=`echo $i`;
transcript=`grep "conchifolia" transdecoder_begonia_fastas/OrthoFinder/Results_Jun05/Single_Copy_Orthologue_Sequences/$OG.fa | cut -d"_" -f 3,4,5,6,7 | cut -d"." -f 1`;
echo $transcript;  done < paml_begonia_significant_orthogroups > conchifolia_significant_transcripts

while read i;
do OG=`echo $i`;
transcript=`grep "plebeja" transdecoder_begonia_fastas/OrthoFinder/Results_Jun05/Single_Copy_Orthologue_Sequences/$OG.fa | cut -d"_" -f 3,4,5,6,7 | cut -d"." -f 1`;
echo $transcript;  done < paml_begonia_significant_orthogroups > plebeja_significant_transcripts



#############################################################
#       Run R script to perform the GO term enrichment      #
#############################################################

Rscript perform_enrichment_begonia.R


#############################################################
#       Move relevant output files back up to this dir      #
#############################################################


mv begonia_enriched_terms .
mv begonia_significant_dnds.txt .



