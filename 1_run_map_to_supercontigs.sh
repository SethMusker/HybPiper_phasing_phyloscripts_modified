#!/bin/sh
#SBATCH --account=biosci
#SBATCH --partition=ada
#SBATCH --time=2-10:00:00
#SBATCH --nodes=1 --ntasks=40
#SBATCH --job-name="HybPiper_m2c"
#SBATCH --mail-user=sethmusker@gmail.com
#SBATCH --mail-type=FAIL

source activate HybPiper_phasing

## VERSIONS
# bwa (mem) Version: 0.7.17-r1188
# The Genome Analysis Toolkit (GATK) v4.1.7.0 (for HaplotypeCaller)
# gatk3 v. 3.8-1-0-gf15c1c3ef (for SelectVariants (only SNPs) and FastaAlternateReferenceMaker (make iupac supercontig))
# picard v. 2.22.9 (CreateSequenceDictionary, FastqToSam (for unmapped reads), MergeBamAlignment (fixes artefacts from bwa), MarkDuplicates (marks reads starting at same 5' pos)

cd /scratch/mskset001/Mike_files_imbricata/trimmed/alleles_workflow/renamed_genes

## rename genes to "-Erica<ID>" (takes a while)
#mkdir renamed_genes
#cd renamed_genes
#cp ../*.fasta .
#cp ../genelist.txt .
#while read gene;do
#sed -i 's/-'"$gene"'/-Erica'"$gene"'/g' *.fasta
#done < ../genelist.txt

#awk '{print "Erica" $1}' genelist.txt > genelist_renamed.txt
#mv genelist.txt old_genelist.txt
#mv genelist_renamed.txt genelist.txt

JAVAMEM=$(( $SLURM_NTASKS*8 ))

while read i;do
i2=$(echo $i | sed 's/_//g')
READS_DIR=/scratch/mskset001/Mike_files_imbricata/fastp_trimmed_paired/"$i2"
/home/mskset001/HybPiper/phyloscripts/alleles_workflow/map_to_supercontigs_gatk4.sh $JAVAMEM \
	"$i" \
	$READS_DIR/"$i2"_R1.fastq \
	$READS_DIR/"$i2"_R2.fastq
done < sample_names_underscore.txt


