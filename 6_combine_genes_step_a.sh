#!/bin/sh
#SBATCH --account=biosci
#SBATCH --partition=ada
#SBATCH --time=1-10:00:00
#SBATCH --nodes=1 --ntasks=4
#SBATCH --job-name="HybPiper_CoAl"
#SBATCH --mail-user=sethmusker@gmail.com
#SBATCH --mail-type=FAIL

source activate HybPiper_phasing

MYBASE=/scratch/mskset001/Mike_files_imbricata/trimmed/alleles_workflow/renamed_genes
cd $MYBASE

namelist=$MYBASE/sample_names_underscore.txt
genelist=$MYBASE/genelist_2244.txt

	while read sample; do
cd $MYBASE/"$sample"
cd supercontig
mkdir phased
mv *_h1.supercontig.alleles.fasta phased
mv *_h2.supercontig.alleles.fasta phased
mkdir unphased
mv *.fasta unphased
for i in phased/*_h1.supercontig.alleles.fasta;do
awk '/^>/ {print $1 "_h1";next}1' $i > $i.reheadered.fasta
done
for i in phased/*_h2.supercontig.alleles.fasta;do
awk '/^>/ {print $1 "_h2";next}1' $i > $i.reheadered.fasta
done
mv phased/*.reheadered.fasta .
for i in unphased/*.supercontig.alleles.fasta;do
awk '/^>/ {print $1 "_h1";next}1' $i > $i.reheadered.fasta
done
mv unphased/*.reheadered.fasta .

cd $MYBASE/"$sample"
cd intron
mkdir phased
mv *_h1.intron.alleles.fasta phased
mv *_h2.intron.alleles.fasta phased
mkdir unphased
mv *.fasta unphased
for i in phased/*_h1.intron.alleles.fasta;do
awk '/^>/ {print $1 "_h1";next}1' $i > $i.reheadered.fasta
done
for i in phased/*_h2.intron.alleles.fasta;do
awk '/^>/ {print $1 "_h2";next}1' $i > $i.reheadered.fasta
done
mv phased/*.reheadered.fasta .
for i in unphased/*.intron.alleles.fasta;do
awk '/^>/ {print $1 "_h1";next}1' $i > $i.reheadered.fasta
done
mv unphased/*.reheadered.fasta .

cd $MYBASE/"$sample"
cd exon
mkdir phased
mv *_h1.alleles.FNA phased
mv *_h2.alleles.FNA phased
mkdir unphased
mv *.FNA unphased
for i in phased/*_h1.alleles.FNA;do
awk '/^>/ {print $1 "_h1";next}1' $i > $i.reheadered.FNA
done
for i in phased/*_h2.alleles.FNA;do
awk '/^>/ {print $1 "_h2";next}1' $i > $i.reheadered.FNA
done
mv phased/*.reheadered.FNA .
for i in unphased/*.alleles.FNA;do
awk '/^>/ {print $1 "_h1";next}1' $i > $i.reheadered.FNA
done
mv unphased/*.reheadered.FNA .
cd $MYBASE/"$sample"

  ## cat within sample, by gene
while read gene; do
  cat supercontig/"$gene"[._]*.fasta > "$sample".supercontig.alleles."$gene".fasta
  cat intron/"$gene"[._]*.fasta > "$sample".intron.alleles."$gene".fasta
  cat exon/"$gene"[._]*.FNA > "$sample".alleles."$gene".FNA
done < $genelist
cd $MYBASE
echo "finished" $sample
	
	done < $namelist











