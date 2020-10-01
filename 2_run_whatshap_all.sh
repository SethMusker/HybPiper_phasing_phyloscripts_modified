#!/bin/sh
#SBATCH --account=biosci
#SBATCH --partition=ada
#SBATCH --time=1-10:00:00
#SBATCH --nodes=1 --ntasks=10
#SBATCH --job-name="HybPiper_WHap"
#SBATCH --mail-user=sethmusker@gmail.com
#SBATCH --mail-type=FAIL

source activate HybPiper_phasing # conda env with whatshap installed (I used v. whatshap 0.18)

cd /scratch/mskset001/Mike_files_imbricata/trimmed/alleles_workflow/renamed_genes

while read i; do cd $i; whatshap phase -o \
$i.supercontigs.fasta.snps.whatshap.vcf \
$i.supercontigs.fasta.snps.vcf \
$i.supercontigs.fasta.marked.bam; 
whatshap stats \
--gtf $i.whatshap.gtf \
--tsv $i.whatshap.stats.tsv \
$i.supercontigs.fasta.snps.whatshap.vcf; 
cd ..; 
done < sample_names_underscore.txt






