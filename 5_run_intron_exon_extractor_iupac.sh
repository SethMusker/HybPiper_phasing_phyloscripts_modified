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
cp "$i".intronerate.gff $i
python $exec/intron_exon_extractor.py $i
done < grandiflora_test_name.txt