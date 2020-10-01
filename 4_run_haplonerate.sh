#!/bin/sh
#SBATCH --account=biosci
#SBATCH --partition=ada
#SBATCH --time=1-10:00:00
#SBATCH --nodes=1 --ntasks=4
#SBATCH --job-name="HybPiper_haplonerate"
#SBATCH --mail-user=sethmusker@gmail.com
#SBATCH --mail-type=FAIL

source activate biopython_2.7

dir=/scratch/mskset001/Mike_files_imbricata/trimmed/alleles_workflow/renamed_genes
cd $dir
hap=$HOME/HybPiper/phyloscripts/haplonerate

while read i;do
cd $i

### OR run haplonerate on all genes at once (as intended) ###
## combine haplotypes into h1 and h2 files, same order
while read gene; do cat phased_bcftools/$i-"$gene"_1.phased.fasta;done < ../genelist.txt > "$i"_all_h1.fasta
while read gene; do cat phased_bcftools/$i-"$gene"_2.phased.fasta;done < ../genelist.txt > "$i"_all_h2.fasta

cp "$i".supercontigs.fasta.iupac "$i".supercontigs.fasta.iupac.fasta
awk -F'[: ]' '/^>/{print ">" $2; next}{print}' "$i".supercontigs.fasta.iupac.fasta > "$i".supercontigs.fasta.iupac.reh.fasta

python $hap/my_haplonerate.py --gtf "$i".whatshap.gtf --haplotype_files "$i"_all_h1.fasta "$i"_all_h2.fasta \
	--reference "$i".supercontigs.fasta.iupac.reh.fasta \
	--output "$i".supercontigs.alleles.fasta --block "$i".supercontigs.alleles.block --edit ref

cd ..
done < sample_names_underscore_NOGRANDI.txt






