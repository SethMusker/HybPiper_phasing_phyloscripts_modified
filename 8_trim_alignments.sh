#!/bin/sh
#SBATCH --account=biosci
#SBATCH --partition=ada
#SBATCH --time=10:00:00
#SBATCH --nodes=1 --ntasks=40
#SBATCH --job-name="HybPiper_trimal"
#SBATCH --mail-user=sethmusker@gmail.com
#SBATCH --mail-type=FAIL

source activate alignment

MYBASE=/scratch/mskset001/Mike_files_imbricata/trimmed/alleles_workflow/renamed_genes

namelist=$MYBASE/sample_names_underscore.txt
genelist=$MYBASE/genelist.txt

cd $MYBASE/Combined

#mkdir -p introns_trimmed
##rm introns_trimmed/*

#parallel "trimal -strict -in introns_aligned/combined.intron.alleles.{}.aln.fasta -out introns_trimmed/combined.intron.alleles.{}.aln.trimmed.strict.fasta" :::: $genelist

parallel "trimal -strictplus -in introns_aligned/combined.intron.alleles.{}.aln.fasta -out introns_trimmed/combined.intron.alleles.{}.aln.trimmed.strictplus.fasta" :::: $genelist


#parallel "trimal -strict -in introns_aligned/combined.intron.alleles.{}.aln.genafpair.fasta -out introns_trimmed/combined.intron.alleles.{}.aln.genafpair.trimmed.strict.fasta" :::: $genelist

parallel "trimal -strictplus -in introns_aligned/combined.intron.alleles.{}.aln.genafpair.fasta -out introns_trimmed/combined.intron.alleles.{}.aln.genafpair.trimmed.strictplus.fasta" :::: $genelist



