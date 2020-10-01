#!/bin/sh
#SBATCH --account=biosci
#SBATCH --partition=ada
#SBATCH --time=1-10:00:00
#SBATCH --nodes=1 --ntasks=40
#SBATCH --job-name="HybPiper_CoAl"
#SBATCH --mail-user=sethmusker@gmail.com
#SBATCH --mail-type=FAIL

source activate HybPiper_phasing

MYBASE=/scratch/mskset001/Mike_files_imbricata/trimmed/alleles_workflow/renamed_genes
cd $MYBASE

namelist=$MYBASE/sample_names_underscore.txt
genelist=$MYBASE/genelist.txt

## cat between samples
cd $MYBASE
mkdir Combined

#while read sample;do
#  while read gene;do
#  cat $sample/"$sample".supercontig.alleles."$gene".fasta >> Combined/combined.supercontig.alleles."$gene".fasta
 #cat $sample/"$sample".intron.alleles."$gene".fasta >> Combined/combined.intron.alleles."$gene".fasta
 # cat $sample/"$sample".alleles."$gene".FNA >> Combined/combined.alleles."$gene".FNA
#  done < $genelist
#done < $namelist

echo "combining genes across samples"
echo "supercontigs"
#parallel -j $SLURM_NTASKS "cat {1}/{1}.supercontig.alleles.{2}.fasta >> Combined/combined.supercontig.alleles.{2}.fasta" :::: $namelist :::: $genelist
echo "introns"
#parallel -j $SLURM_NTASKS "cat {1}/{1}.intron.alleles.{2}.fasta >> Combined/combined.intron.alleles.{2}.fasta" :::: $namelist :::: $genelist
echo "exons"
#parallel -j $SLURM_NTASKS "cat {1}/{1}.alleles.{2}.FNA >> Combined/combined.alleles.{2}.FNA" :::: $namelist :::: $genelist

## gatk outputs * for deletions. (https://gatk.broadinstitute.org/hc/en-us/articles/360035531912-Spanning-or-overlapping-deletions-allele-)
## This causes alignment problems with MACSE. Replace * with gap.

parallel "sed 's/[*]/-/g' Combined/combined.supercontig.alleles.{}.fasta > Combined/combined.supercontig.alleles.{}.fixed.fasta" :::: $genelist
parallel "sed 's/[*]/-/g' Combined/combined.intron.alleles.{}.fasta > Combined/combined.intron.alleles.{}.fixed.fasta" :::: $genelist
parallel "sed 's/[*]/-/g' Combined/combined.alleles.{}.FNA > Combined/combined.alleles.{}.fixed.FNA" :::: $genelist











