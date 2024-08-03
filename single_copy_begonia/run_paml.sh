

########################################
#       load required software         #
########################################

module load mafft
module load R
module load conda
conda activate ~/my-conda-envs/paml/



#######################################################################################################
#                      begonia translational alignment and test for selection                         #
#    run test for foreground branches having significantly different dN/dS than background branches   #
#######################################################################################################

for i in `ls *fa`;
do orthogroup=`basename $i | cut -d"." -f 1`;
seqname_file=$orthogroup"_seqnames";
cds_file=$orthogroup".cds.fa";
grep ">" $orthogroup.fa | cut -d">" -f 2 > $seqname_file;
seqkit grep -f $seqname_file /lisc/scratch/botany/katie/cyrtandra_begonia_comparison/transdecoder/all_species.transdecoder.cds > $cds_file;
mafft_file=$orthogroup".aln";
mafft $orthogroup.fa > $mafft_file;
paml_input=$orthogroup".codeml.fa";
paml_output=$orthogroup".codeml.out";
pal2nal.pl $mafft_file $cds_file -output paml > $paml_input;
sed 's/Dat/datisca_Dat/g' $paml_input | cut -d"_" -f 1 > $paml_input"_formatted"
python3 biopaml_begonia_foreground.py $paml_input"_formatted" $paml_output;
done

rm paml_begonia_foreground/*
mv *.codeml.out  paml_begonia_foreground

#######################################################################################################
#                      begonia translational alignment and test for selection                         #
#                            specify a single dN/dS across the whole tree                             #
#######################################################################################################

# use the same alignments we generated above

for i in `ls *.codeml.fa`; 
do orthogroup=`basename $i | cut -d"." -f 1`; 
paml_input=$orthogroup".codeml.fa";
paml_output=$orthogroup".codeml.out";
python3 biopaml_begonia_oneratio.py $paml_input"_formatted" $paml_output;
done

rm paml_begonia_allequal/*
mv *.codeml.out paml_begonia_allequal

#######################################################
#       clean up not needed intermediate files        #
#######################################################

rm *_seqnames *.aln *.cds.fa *.codeml.fa_formatted rst rst1 rub lnf 2NG.dN 2NG.dS 2NG.t 4fold.nuc 

###################################################################
#             extract log likelihoods for each model              #
#          get names for each corresponding orthogroup            #
#     paste log likelihoods alongside corresponding orthogroups   #
###################################################################

for i in `ls OG*fa | xargs -n 1 basename`; do OG=`echo $i | cut -d"." -f 1`; grep "lnL" paml_begonia_allequal/$OG*; done > paml_begonia_allequal.lnL.txt
for i in `ls OG*fa | xargs -n 1 basename`; do OG=`echo $i | cut -d"." -f 1`; grep "lnL" paml_begonia_foreground/$OG*; done > paml_begonia_foreground.lnL.txt
for i in `ls OG*fa | xargs -n 1 basename`; do OG=`echo $i | cut -d"." -f 1`; echo $OG; done > paml_begonia_og.txt


paste paml_begonia_og.txt paml_begonia_foreground.lnL.txt > paml_begonia_foreground.lnL.og.txt
paste paml_begonia_og.txt paml_begonia_allequal.lnL.txt > paml_begonia_allequal.lnL.og.txt

# reove not needed intermediate files
rm paml_begonia_og.txt paml_begonia_foreground.lnL.txt paml_begonia_allequal.lnL.txt


#########################################################################################################
#   run R script to find orthogroups with significynt difference between allequal and foreground model  #
#########################################################################################################

module load R
Rscript get_significant_orthogroups_begonia.R


###############################################################################
#       get the forground and background values of dN/dS for plotting later   #
###############################################################################

while read i; do grep "w (dN/dS) for branches:" paml_begonia_foreground/$i.codeml.out; done < paml_begonia_significant_orthogroups > begonia_significant_dnds.txt 


########################################################################################################################################
#       go through significant orthogroups, pull out seqnames for each foreground species, use that to grep out the sequence IDs       #
########################################################################################################################################


while read i;
do OG=`echo $i`;
transcript=`grep "conchifolia" ../transdecoder_begonia_fastas/OrthoFinder/Results_*/Single_Copy_Orthologue_Sequences/$OG.fa | cut -d"_" -f 3,4,5,6,7 | cut -d"." -f 1`;
echo $transcript;  done < paml_begonia_significant_orthogroups > conchifolia_significant_transcripts

while read i;
do OG=`echo $i`;
transcript=`grep "plebeja" ../transdecoder_begonia_fastas/OrthoFinder/Results_*/Single_Copy_Orthologue_Sequences/$OG.fa | cut -d"_" -f 3,4,5,6,7 | cut -d"." -f 1`;
echo $transcript;  done < paml_begonia_significant_orthogroups > plebeja_significant_transcripts


###########################################
#       perform functional enrichment     #
###########################################

Rscript perform_enrichment.R



