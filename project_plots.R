library(dplyr)
library(magrittr)
library(readr)
library(ggplot2)
library(reshape2)
library(UpSetR)
library(stringr)

orth<-read_tsv("Orthogroups.GeneCount.tsv")


#################################################
#           histogram orthogroup size           #
#################################################


orth<-rename(orth, athaliana=Athaliana_167_cds_primaryTranscriptOnly,
       datisca=Datisca_glomerata_v1_b2_corect_format_transcript_only,
       dorcoceras=GCA_001598015.1_Boea_hygrometrica.v1_genomic_transcript_only,
       hillebrandia=Hsand_mRNA,
       conchifolia=con_Trinity_rename.longest,
       plebeja=ple_Trinity_rename.longest,
       total=Total)

c("Athaliana_167_cds_primaryTranscriptOnly",                 
"Datisca_glomerata_v1_b2_corect_format_transcript_only",       
"GCA_001598015.1_Boea_hygrometrica.v1_genomic_transcript_only",
"Hsand_mRNA",                                                  
"PG_Sr_cds_nuc",                                               
"con_Trinity_rename.longest",                                  
"ple_Trinity_rename.longest",                                  
"trinity_Sample_PRO1937_S11.Trinity_rename.longest",           
"trinity_Sample_PRO1937_S12.Trinity_rename.longest") 


colnames(orth)
# get index for rows where at least 4 of the species has more than 0 size orthogroup
indices<-rowSums(orth[,c("athaliana", 
                "datisca", 
                "dorcoceras", 
                "hillebrandia", 
                "conchifolia", 
                "plebeja")] != 0) > 5

# use those indices to select out those rows from the object
orth_subset<-orth[indices,c("athaliana", 
                            "datisca", 
                            "dorcoceras", 
                            "hillebrandia", 
                            "conchifolia", 
                            "plebeja", 
                            "total")]

melted_orth<-melt(orth_subset)

# make a histogram of all the gene family sizes
#  not amazingly informative
ggplot(melted_orth, aes((value), fill=variable)) + geom_histogram(position = 'dodge', bins=10)


orth_subset %>% log() %>% boxplot()


##########################################################
#     comparative all vs separate orthogroup plots       #
##########################################################

#orthofinder_fastas_begonia/OrthoFinder/Results_Jul12/Comparative_Genomics_Statistics/Statistics_Overall.tsv:Number of orthogroups with all species present	5359
#orthofinder_fastas_cyrtandra/OrthoFinder/Results_Jul12/Comparative_Genomics_Statistics/Statistics_Overall.tsv:Number of orthogroups with all species present	8591
#orthofinder_fastas/OrthoFinder/Results_Jul11/Comparative_Genomics_Statistics/Statistics_Overall.tsv:Number of orthogroups with all species present	392

rows<-c("Number of genes",
        "Number of genes in orthogroups",
        "Number of unassigned genes",
        "Percentage of genes in orthogroups",
        "Percentage of unassigned genes",
        "Number of orthogroups containing species",
        "Percentage of orthogroups containing species",
        "Number of species-specific orthogroups",
        "Number of genes in species-specific orthogroups",
        "Percentage of genes in species-specific orthogroups")

# reformatted from orthofinder_fastas_begonia/OrthoFinder/Results_Jul12/Comparative_Genomics_Statistics/Statistics_PerSpecies.tsv 
begonia_stats<-data.frame(conchifolia=c(17012, 15275, 1737 , 89.8 , 10.2 , 11711, 73.8 , 34   , 77   , 0.5  ),
datisca=c(37042, 29144, 7898 , 78.7 , 21.3 , 8500 , 53.6 , 1731 , 16190, 43.7 ),
hillebrandia=c(26925, 22010, 4915 , 81.7 , 18.3 , 11534, 72.7 , 1241 , 3681 , 13.7 ),
plebeja=c(19969, 18067, 1902, 90.5, 9.5, 11957, 75.4, 174, 456, 2.3), 
statistic = rows) %>% melt() %>% mutate(analysis="independent")


# reformatted from less orthofinder_fastas_cyrtandra/OrthoFinder/*/Comparative_Genomics_Statistics/Statistics_PerSpecies.tsv 
cyrtandra_stats<-data.frame(crockerella=c(18712, 17339, 1373 , 92.7 , 7.3  , 12947, 65.7 , 106  , 275  , 1.5),
dorcoceras=c(47778, 45075, 2703 , 94.3 , 5.7  , 14037, 71.2 , 889  , 11603, 24.3),   
serratifolia=c(18206, 16950, 1256 , 93.1 , 6.9  , 13104, 66.5 , 87   , 216  ,1.2),
streptocarpus=c(44947, 38487, 6460 , 85.6 , 14.4, 17351, 88.0, 2068, 6298, 14.0),
statistic = rows) %>% melt() %>% mutate(analysis="independent")
        
#reformatted from orthofinder_fastas/OrthoFinder/*/Comparative_Genomics_Statistics/Statistics_PerSpecies.tsv 
all_stats<-data.frame(
  #athaliana=c(27416, 12426, 14990, 45.3 , 54.7 , 6315 , 17.4 , 2780 , 7429 , 27.1),
  conchifolia=c(17012, 15441, 1571 , 90.8 , 9.2  , 11628, 32.1 , 26   , 57   , 0.3  ),
  crockerella=c(18712 , 17591 , 1121  , 94.0  , 6.0   , 12686 , 35.0  , 83    , 221   , 1.2   )      ,
  datisca=c(37042 , 29815 , 7227  , 80.5  , 19.5  , 9268  , 25.6  , 1577  , 12160 , 32.8  ),
  dorcoceras=c(47778, 45136, 2642 , 94.5 , 5.5  , 13899, 38.4 , 859  , 11899, 24.9 ),
  hillebrandia=c(26925 , 22195 , 4730  , 82.4  , 17.6  , 11643 , 32.1  , 1191  , 3544  , 13.2  ),
  plebeja=c(19969 , 18349 , 1620  , 91.9  , 8.1   , 11904 , 32.9  , 134   , 330   , 1.7   ),
  serratifolia=c( 18206 ,  17235 ,  971   ,  94.7  ,  5.3   ,  12856 ,  35.5  ,  70    ,  177   ,  1.0   ),
  streptocarpus=c(44947  , 39269  , 5678   , 87.4 , 12.6, 16983  , 46.9, 1905, 5870, 13.1), 
  statistic = rows) %>% melt() %>% mutate(analysis="all")
                    
everything<-rbind(begonia_stats, cyrtandra_stats, all_stats)
                                 
to_barplot<-everything %>% filter(statistic == "Percentage of genes in orthogroups")
to_barplot<-everything %>% filter(statistic == "Percentage of unassigned genes")
to_barplot<-everything %>% filter(statistic == "Percentage of orthogroups containing species")
to_barplot<-everything %>% filter(statistic == "Percentage of genes in species-specific orthogroups")

ggplot(data=to_barplot, aes(x=variable, y=value, fill = analysis)) +
  geom_bar(stat="identity", position=position_dodge())         


##########################################################
#     all vs separate orthogroup size       #
##########################################################

bp_begonia<-read_tsv("~/Desktop/Cyrtandra/orthogroup_comp_boxplots/orthofinder_fastas_begonia_Orthogroups.GeneCount.tsv") %>% 
  melt() %>% 
  mutate(analysis="independent")

bp_cyrtandra<-read_tsv("~/Desktop/Cyrtandra/orthogroup_comp_boxplots/orthofinder_fastas_cyrtandra_Orthogroups.GeneCount.tsv") %>% 
  melt() %>% 
  mutate(analysis="independent")

bp_all<-read_tsv("~/Desktop/Cyrtandra/orthogroup_comp_boxplots/orthofinder_fastas_Orthogroups.GeneCount.tsv") %>% 
  melt() %>% 
  mutate(analysis="all")

bp_everything<-rbind(bp_begonia, bp_cyrtandra, bp_all)

bp_everything<-bp_everything %>% filter(value < 5 & variable != "Total" & variable != "athaliana")

ggplot(bp_everything, aes(x=variable, y=(value), fill=analysis)) + 
  geom_violin()
  
#################################################
#        cumulative orthogrop proportion        #
#################################################


# get the proportion of each species in each gene family
# then get the cumulative sum
# this should inform us of how the gene family size overall is accounted for by the different species
cumsums<-orth_subset %>% mutate(athaliana_proportion=athaliana/total,
                       datisca_proportion=datisca/total,
                       hilledrandia_proportion=hillebrandia/total,
                       conchifolia_propoertion=conchifolia/total,
                       plebeja_proportion=plebeja/total) %>%
  mutate(athaliana_cumsum = athaliana_proportion %>% cumsum(),
         datisca_cumsum = datisca_proportion %>% cumsum(),
         hilledrandia_cumsum=hilledrandia_proportion %>% cumsum(),
         conchifolia_cumsum=conchifolia_propoertion %>% cumsum(),
         plebeja_cumsum=plebeja_proportion %>% cumsum()) %>%
  dplyr::select(matches("cumsum"))

# melt the cumsums and then make another column which is the orthogroup count, which we will use for plotting
cumsum_melt<-melt(cumsums)
cumsum_melt$number<-rep(1:nrow(cumsums), ncol(cumsums))


# plot across the orthogroups, how the cumulative sum increases per species
# interesting because it seems that conchifolia and datisca are similar and plebeja is higher
ggplot(cumsum_melt, aes(x = number, y = value, colour = variable, group = variable)) + 
  geom_line() +
  labs(y= "Proportion of gene family (cumulative)", x = "Orthogroup count") +
  theme(legend.title=element_blank())



#################################################
#      begonia and crockerella orthogroups      #
#################################################

orth_all<-read_tsv("begonia_cyrtandra_fastas_Orthogroups.GeneCount.tsv")

orth_all<-rename(orth_all, athaliana=Athaliana_167_cds_primaryTranscriptOnly,
             datisca=Datisca_glomerata_v1_b2_corect_format_transcript_only,
             dorcoceras=GCA_001598015.1_Boea_hygrometrica.v1_genomic_transcript_only,
             hillebrandia=Hsand_mRNA,
             streptocarpus=PG_Sr_cds_nuc,
             conchifolia=con_Trinity_rename.longest,
             plebeja=ple_Trinity_rename.longest,
             crockerella=trinity_Sample_PRO1937_S11.Trinity_rename.longest,
             serratifolia=trinity_Sample_PRO1937_S12.Trinity_rename.longest,
             total=Total)

# get index for rows where at least 4 of the species has more than 0 size orthogroup
indices<-rowSums(orth_all[,c("athaliana", 
                         "datisca", 
                         "dorcoceras", 
                         "hillebrandia", 
                         "conchifolia", 
                         "plebeja",
                         "streptocarpus",
                         "crockerella",
                         "serratifolia")] != 0) > 5




indices2<-rowSums(orth_all[,c(
  "datisca", 
  "conchifolia", 
  "plebeja",
  "streptocarpus",
  "crockerella",
  "serratifolia")] >= 2) == 6


orth_all_subset<-orth_all[indices2,]

indices3<-rowSums(orth_all[,c(
  "conchifolia", 
  "plebeja",
  "crockerella",
  "serratifolia")] >= 2) == 4
orth_all_subset<-orth_all[indices3,]


# use those indices to select out those rows from the object
orth_all_subset<-orth_all[indices,c("athaliana", 
                                "datisca", 
                                "dorcoceras", 
                                "hillebrandia", 
                                "conchifolia", 
                                "plebeja",
                                "streptocarpus",
                                "crockerella",
                                "serratifolia",
                                "total")]

bc<-orth_all_subset %>% dplyr::select("conchifolia", "plebeja", "crockerella", "serratifolia")

orth_all_subset %>% select(-total)

bc$conchifolia


plot(bc$conchifolia, bc$plebeja)
plot(bc$serratifolia, bc$crockerella)
plot(bc$conchifolia, bc$serratifolia)
plot(bc$conchifolia, bc$crockerella)

boxplot(orth_all_subset %>% select(-total) %>% log())



#################################################
#                    Upset plots                #
#################################################

# take the orthogroups and set them as a vector for colnames later
orthogroups<-orth_all %>% dplyr::select(c("Orthogroup")) %>% pull()

# take out orthogroup column
counts<-orth_all %>% 
  dplyr::select(-c("Orthogroup", "total"))

# code species as 1 if they have at least one gene in an orthogroup, 0 if none
counts<-ifelse(counts > 0, 1, 0) %>% 
  data.frame() %>% 
  set_rownames(orthogroups)

species_names<-counts %>% colnames()

x<-species_names[1] 

# take the orthogroup by index of which orthogroups have a represetative from this species
rep_orthogroups<-function(species_name, orthogroups, counts_table){
  rep_orths<-orthogroups[which(counts_table[species_name] == 1)]
  return(rep_orths)
}



athaliana_rep_orthogroups<-rep_orthogroups("athaliana", orthogroups, counts)
datisca_rep_orthogroups<-rep_orthogroups("datisca", orthogroups, counts)
dorcoceras_rep_orthogroups<-rep_orthogroups("dorcoceras", orthogroups, counts)
hillebrandia_rep_orthogroups<-rep_orthogroups("hillebrandia", orthogroups, counts)
streptocarpus_rep_orthogroups<-rep_orthogroups("streptocarpus", orthogroups, counts)
conchifolia_rep_orthogroups<-rep_orthogroups("conchifolia", orthogroups, counts)
plebeja_rep_orthogroups<-rep_orthogroups("plebeja", orthogroups, counts)
crockerella_rep_orthogroups<-rep_orthogroups("crockerella", orthogroups, counts)
serratifolia_rep_orthogroups<-rep_orthogroups("serratifolia", orthogroups, counts)

listInput<-list(athaliana = athaliana_rep_orthogroups,
datisca = datisca_rep_orthogroups,
dorcoceras = dorcoceras_rep_orthogroups,
hillebrandia = hillebrandia_rep_orthogroups,
streptocarpus = streptocarpus_rep_orthogroups,
conchifolia = conchifolia_rep_orthogroups,
plebeja = plebeja_rep_orthogroups,
crockerella = crockerella_rep_orthogroups,
serratifolia = serratifolia_rep_orthogroups)

upset(fromList(listInput), order.by = "freq", nsets = 9)



#################################################
#                    dnds plots                 #
#################################################

# this dnds table is the output from the pipeline, I ran cat on all files ending with *dnds
dnds<-read_tsv("all_dnds", col_names = c("orthogroup", 
                                         "first",
                                         "second",
                                         "dnds"))
# shorted the orthogroup column
dnds$orthogroup<-str_remove(dnds$orthogroup, "orthogroup_subset_fastas/")

# take out any dN/dS measurements above 2, which are likely to be due to misalignment
dnds<-dnds %>% filter(dnds < 2)

dnds$first_species<-case_when(grepl("con", dnds$first) == TRUE ~ "con",
          grepl("ple", dnds$first) == TRUE ~ "ple",
          grepl("crock", dnds$first) == TRUE ~ "crock",
          grepl("serra", dnds$first) == TRUE ~ "serra",
          grepl("transcript__scaffold", dnds$first) == TRUE ~ "dat",
          grepl("Sr", dnds$first) == TRUE ~ "strep",
          grepl("AT", dnds$first) == TRUE ~ "arath")

dnds$second_species<-case_when(grepl("con", dnds$second) == TRUE ~ "con",
          grepl("ple", dnds$second) == TRUE ~ "ple",
          grepl("crock", dnds$second) == TRUE ~ "crock",
          grepl("serra", dnds$second) == TRUE ~ "serra",
          grepl("transcript__scaffold", dnds$second) == TRUE ~ "dat",
          grepl("Sr", dnds$second) == TRUE ~ "strep",
          grepl("AT", dnds$second) == TRUE ~ "arath")

# get the mean dnds per species per orthogrouo
per_orthogroup_mean_dnds<-aggregate(dnds ~ orthogroup + first_species, intraspecific_dnds, mean)

# get the orthogroups which have at least n repetitions in the data (i.e. have at least N species)
test<-per_orthogroup_mean_dnds %>% group_by(orthogroup) %>% filter(n() == 3)




test$orthogroup %>% table()












test$orthogroup %>% table()
test %>% filter(orthogroup == "OG0006684")

intraspecific_dnds<-dnds %>% filter(first_species == second_species)

begonia_intra_dnds<-intraspecific_dnds %>% filter(first_species %in% c("con", "ple"))
cyrtandra_intra_dnds<-intraspecific_dnds %>% filter(first_species %in% c("crock", "serra"))

strep_dnds<-intraspecific_dnds %>% filter(first_species %in% c("strep"))
dat_dnds<-intraspecific_dnds %>% filter(first_species %in% c("dat"))



cyrtandra_intra_dnds$dnds %>% summary()

begonia_intra_dnds$dnds %>% summary()
dat_dnds$dnds %>% summary()

cyrtandra_intra_dnds$dnds %>% points(col="red")





dnds %>% data.frame()


con_con<-read_tsv("species_dnds_tables/con_con", col_names = c("orthogroup",
                                                               "first",
                                                               "second",
                                                               "dnds"))
ple_ple<-read_tsv("species_dnds_tables/ple_ple", col_names = c("orthogroup",
                                                               "first",
                                                               "second",
                                                               "dnds"))

crock_crock<-read_tsv("species_dnds_tables/crock_crock", col_names = c("orthogroup",
                                                               "first",
                                                               "second",
                                                               "dnds"))
serra_serra<-read_tsv("species_dnds_tables/serra_serra", col_names = c("orthogroup",
                                                               "first",
                                                               "second",
                                                               "dnds"))




co<-con_con %>% filter(dnds < 2) %>% dplyr::select(dnds) %>% pull()
pl<-ple_ple %>% filter(dnds < 2) %>% dplyr::select(dnds) %>% pull()

cr<-crock_crock %>% filter(dnds < 2) %>% dplyr::select(dnds) %>% pull()
se<-serra_serra %>% filter(dnds < 2) %>% dplyr::select(dnds) %>% pull()
se<-c(se, rep(NA, 8))

length(se)

co<-c(co, rep(NA, 4))

d<-data.frame(conch=co, pleb=pl)
d2<-data.frame(crock=cr, serra=se)
boxplot(d2)




