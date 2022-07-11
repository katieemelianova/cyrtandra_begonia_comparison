from Bio.Phylo.PAML import codeml
import pprint
import sys

alignment_file=sys.argv[1]
orthogroup=alignment_file.split(".")[0]

cml=codeml.Codeml(alignment=alignment_file, tree="no_tree", out_file="bio_results", working_dir="./")

cml.set_options(runmode =-2)
cml.set_options(NSsites=0)
cml.set_options(NSsites=[0])
cml.set_options(seqtype=1)
cml.set_options(CodonFreq=0)
cml.set_options(fix_kappa=1)
cml.set_options(kappa=1)
cml.set_options(fix_omega=0)
cml.set_options(omega=0.5)
cml.set_options(verbose=True)
cml.set_options(model=0)

try:
    cml.run()
    results = codeml.read(results_file="bio_results")
    seqs=list(results.get("pairwise").keys())
    for s in seqs:
        other_seqs=[i for i in seqs if not i == s]
        entry=results.get("pairwise")[s]
        for comparison in entry:
            dN=str(entry[comparison].get("dN"))
            dS=str(entry[comparison].get("dS"))
            omega=str(entry[comparison].get("omega"))
            to_print="\t".join([orthogroup, s, comparison, omega, dN, dS])
            print(to_print)
except:
    exit()




cml.run()
results = codeml.read(results_file="bio_results")
seqs=list(results.get("pairwise").keys())
for s in seqs:
    other_seqs=[i for i in seqs if not i == s]
    entry=results.get("pairwise")[s]
    for comparison in entry:
        dN=str(entry[comparison].get("dN"))
        dS=str(entry[comparison].get("dS"))
        omega=str(entry[comparison].get("omega"))
        to_print="\t".join([orthogroup, s, comparison, omega, dN, dS])
        print(to_print)




# example of how to select out different species from dn/ds file
# awk '$2 ~ /con/' at_containing_test_orths/*.dnds | awk '$3 ~ /ple/'

