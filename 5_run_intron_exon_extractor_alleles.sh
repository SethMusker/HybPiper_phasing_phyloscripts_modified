#!/bin/sh
#SBATCH --account=biosci
#SBATCH --partition=ada
#SBATCH --time=1-10:00:00
#SBATCH --nodes=1 --ntasks=4
#SBATCH --job-name="HybPiper_IEex"
#SBATCH --mail-user=sethmusker@gmail.com
#SBATCH --mail-type=FAIL

source activate HybPiper_phasing

cd /scratch/mskset001/Mike_files_imbricata/trimmed/alleles_workflow/renamed_genes
exec=/home/mskset001/HybPiper/phyloscripts/alleles_workflow

while read i; do
cd $i
#mkdir "$i"_archive
#mv * "$i"_archive
#cp "$i"_archive/"$i".supercontigs.alleles.fasta .
#cd ..
#cp "$i".intronerate.gff $i
python $exec/intron_exon_extractor_alleles.py $i
done < Rhododendron_test_name.txt