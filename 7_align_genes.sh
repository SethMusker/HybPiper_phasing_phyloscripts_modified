#!/bin/sh
#SBATCH --account=biosci
#SBATCH --partition=ada
#SBATCH --time=1-10:00:00
#SBATCH --nodes=1 --ntasks=40
#SBATCH --job-name="HybPiper_Align"
#SBATCH --mail-user=sethmusker@gmail.com
#SBATCH --mail-type=FAIL

source activate alignment

MYBASE=/scratch/mskset001/Mike_files_imbricata/trimmed/alleles_workflow/renamed_genes

namelist=$MYBASE/sample_names_underscore.txt
genelist=$MYBASE/genelist.txt

## cat between samples
cd $MYBASE/Combined

echo "aligning using mafft L-INS-i"
echo "exons"
#mkdir exons_aligned
#parallel -j $SLURM_NTASKS "mafft --localpair --maxiterate 1000 combined.alleles.{}.FNA > exons_aligned/combined.alleles.{}.aln.FNA" :::: $genelist

echo "introns"
#mkdir introns_aligned
#parallel -j $SLURM_NTASKS "mafft --localpair --maxiterate 1000 combined.intron.alleles.{}.fasta > introns_aligned/combined.intron.alleles.{}.aln.fasta" :::: $genelist

echo "supercontigs"
mkdir supercontigs_aligned
parallel --eta -j $SLURM_NTASKS "mafft --localpair --maxiterate 1000 combined.supercontig.alleles.{}.fasta > supercontigs_aligned/combined.supercontig.alleles.{}.aln.fasta" :::: $genelist

echo "aligning using mafft G-INS-i"
echo "introns"
parallel --eta -j $SLURM_NTASKS "mafft --ep 0 --genafpair --maxiterate 1000 combined.intron.alleles.{}.fasta > introns_aligned/combined.intron.alleles.{}.aln.genafpair.fasta" :::: $genelist
echo "supercontigs"
parallel --eta -j $SLURM_NTASKS "mafft --ep 0 --genafpair --maxiterate 1000 combined.supercontig.alleles.{}.fasta > supercontigs_aligned/combined.supercontig.alleles.{}.aln.genafpair.fasta" :::: $genelist












