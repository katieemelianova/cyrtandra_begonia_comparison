

#######################################
#    link fastas to orthofinder dir   #
#######################################

mkdir orthofinder_fastas

ln -s ~/references/Arabidopsis/Athaliana_167_cds_primaryTranscriptOnly.fa orthofinder_fastas/athaliana.fasta
ln -s ~/references/Begonia/con_Trinity_rename.longest.fasta orthofinder_fastas/conchifolia.fasta
ln -s ~/references/Begonia/ple_Trinity_rename.longest.fasta orthofinder_fastas/plebeja.fasta
ln -s ~/references/Cyrtandra/trinity_Sample_PRO1937_S11.Trinity_rename.longest.fasta orthofinder_fastas/crockerella.fasta
ln -s ~/references/Cyrtandra/trinity_Sample_PRO1937_S12.Trinity_rename.longest.fasta orthofinder_fastas/serratifolia.fasta
ln -s ~/references/Datisca/Datisca_glomerata_v1_b2_corect_format_transcript_only.fasta orthofinder_fastas/datisca.fasta
ln -s ~/references/Dorcoceras/Dorcoceras_assembly/GCA_001598015.1_Boea_hygrometrica.v1_genomic_transcript_only.fasta orthofinder_fastas/dorcoceras.fasta
ln -s ~/references/Hillebrandia/Hsand_mRNA.fasta orthofinder_fastas/hillebrandia.fasta
ln -s ~/references/Streptocarpus/PG_Sr_cds_nuc.fa orthofinder_fastas/streptocarpus.fasta

#######################################
#        kick off orthofinder run     #
#######################################

#sbatch run_orthofinder.sh


#############################################################################
#     filter orthofinder counts by orthogroups with all non-zero values     #
#############################################################################

Rscript subset_orthogroup.R

#############################################################################
#       use colnames of subset orthofinder to get orthogoup fastas          #
#############################################################################


mkdir orthogroup_subset_fastas
orths=`cut -f 1 Orthogroups.GeneCount.subset.tsv`
for o in $orths; do cp orthofinder_fastas/OrthoFinder/Results_Jul08/Orthogroup_Sequences/$o.fa orthogroup_subset_fastas; done

###########################################################
#       run codon alignment on subset orthogroups         #
###########################################################

sbatch run_snakemake.sh


