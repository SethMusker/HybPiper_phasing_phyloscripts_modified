
#Script to combine exon and intron alignments for a gene and generate a RAxML partition file.
# Seth's edit: specify all three codon positions as separate partitions (as recommended by PartitionFinder)
# also: write to 'exons_only.fasta/partition' if no intron file exists

import sys,os
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord

if len(sys.argv) < 4:
    print("Usage: python combine_alignments.py exon.fasta intron.fasta[or any value if no intron] geneName")
    sys.exit(1)
    
exon_fn = sys.argv[1]
intron_fn = sys.argv[2]
geneName = sys.argv[3]

exon_dict = SeqIO.to_dict(SeqIO.parse(exon_fn,'fasta'))
exonLength = len(next(exon_dict.itervalues()))
    
if os.path.isfile(intron_fn):
    with open("{}.combined.fasta".format(geneName),'w') as outfile:
        for seq in SeqIO.parse(intron_fn,'fasta'):
            intronLength = len(seq)
            sampleID = seq.id.split("-")[0]
            newseq = exon_dict[sampleID].seq + seq.seq
            outfile.write(">{}\n{}\n".format(sampleID,newseq))
        partition = """DNA, codon1 = 1-{}\\3
DNA, codon2 = 2-{}\\3
DNA, codon3 = 3-{}\\3
DNA, intron = {}-{}
""".format(exonLength, exonLength, exonLength, exonLength+1,exonLength+intronLength)
    with open("{}.combined.partition".format(geneName),'w') as partitionfile:
        partitionfile.write(partition)         
            
            
          
            
else:
    with open("{}.exon_only.fasta".format(geneName),'w') as outfile:
        for sampleID in exon_dict:
            newseq = exon_dict[sampleID].seq
            outfile.write(">{}\n{}\n".format(sampleID,newseq))
        partition = """DNA, codon1 = 1-{}\\3
DNA, codon2 = 2-{}\\3
DNA, codon3 = 3-{}\\3 
""".format(exonLength, exonLength, exonLength)
    with open("{}.exon_only.partition".format(geneName),'w') as partitionfile:
        partitionfile.write(partition) 
