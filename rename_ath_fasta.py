


def fastaDict(i):
	f = open(i)
	L = {}

	for line in f:
		if line.startswith(">"):
			C_seq = ''
			C_split_line = line.split(' ')
			C_name = C_split_line[0]
			C_name = C_name.rstrip()
			C_name = C_name.lstrip('>')
		else:
			C_seq = C_seq + str(line)
			C_seq = C_seq.rstrip()
			C_seq = C_seq.upper()

		L[C_name] = C_seq
	return(L)


fasta_path = "/home/kemelian/alignment_pipeline/TAIR10_pep_20101214" 
ath  = fastaDict(fasta_path)


new_fasta_path = "/home/kemelian/alignment_pipeline/TAIR10_pep_20101214_rename"
outfile = open(new_fasta_path, "a")
for i in ath:
    outfile.write(">" + i + "_reference" + "\n" + ath[i] + "\n")
outfile.close()


