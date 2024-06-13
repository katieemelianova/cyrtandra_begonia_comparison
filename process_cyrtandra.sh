

###################################################################
#             extract log likelihoods for each model              #
#          get names for each corresponding orthogroup            #
#     paste log likelihoods alongside corresponding orthogroups   #
###################################################################

for i in `ls single_copy_cyrtandra/OG*fa | xargs -n 1 basename`; do OG=`echo $i | cut -d"." -f 1`; grep "lnL" single_copy_cyrtandra/paml_cyrtandra_allequal/$OG*; done > paml_cyrtandra_allequal.lnL.txt
for i in `ls single_copy_cyrtandra/OG*fa | xargs -n 1 basename`; do OG=`echo $i | cut -d"." -f 1`; grep "lnL" single_copy_cyrtandra/paml_cyrtandra_foreground/$OG*; done > paml_cyrtandra_foreground.lnL.txt
for i in `ls single_copy_cyrtandra/OG*fa | xargs -n 1 basename`; do OG=`echo $i | cut -d"." -f 1`; echo $OG; done > paml_cyrtandra_og.txt


paste paml_cyrtandra_og.txt paml_cyrtandra_foreground.lnL.txt > paml_cyrtandra_foreground.lnL.og.txt
paste paml_cyrtandra_og.txt paml_cyrtandra_allequal.lnL.txt > paml_cyrtandra_allequal.lnL.og.txt


#########################################################################################################
#   run R script to find orthogroups with significynt difference between allequal and foreground model  #
#########################################################################################################

module load R
Rscript get_significant_orthogroups_cyrtandra.R


###############################################################################
#       get the forground and background values of dN/dS for plotting later   #
###############################################################################

while read i; do grep "w (dN/dS) for branches:" single_copy_cyrtandra/paml_cyrtandra_foreground/$i.codeml.out; done < paml_cyrtandra_significant_orthogroups > cyrtandra_significant_dnds.txt 


########################################################################################################################################
#       go through significant orthogroups, pull out seqnames for each foreground species, use that to grep out the sequence IDs       #
########################################################################################################################################

while read i;
do OG=`echo $i`;
transcript=`grep "crockerella" transdecoder_cyrtandra_fastas/OrthoFinder/Results_Jun05/Single_Copy_Orthologue_Sequences/$OG.fa | cut -d"_" -f 2,3,4,5,6,7 | cut -d"." -f 1`;
echo $transcript;  done < paml_cyrtandra_significant_orthogroups > crockerella_significant_transcripts

while read i;
do OG=`echo $i`;
transcript=`grep "serratifolia" transdecoder_cyrtandra_fastas/OrthoFinder/Results_Jun05/Single_Copy_Orthologue_Sequences/$OG.fa | cut -d"_" -f 2,3,4,5,6,7 | cut -d"." -f 1`;
echo $transcript;  done < paml_cyrtandra_significant_orthogroups > serratifolia_significant_transcripts



#############################################################
#       Run R script to perform the GO term enrichment      #
#############################################################

Rscript perform_enrichment_cyrtandra.R




