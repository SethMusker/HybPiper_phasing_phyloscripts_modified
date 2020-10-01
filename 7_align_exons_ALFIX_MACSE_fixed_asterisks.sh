#!/bin/sh
#SBATCH --account=biosci
#SBATCH --partition=ada
#SBATCH --time=1-10:00:00
#SBATCH --nodes=1 --ntasks=40
#SBATCH --job-name="HybPiper_ALFIX"
#SBATCH --mail-user=sethmusker@gmail.com
#SBATCH --mail-type=FAIL

MYBASE=/scratch/mskset001/Mike_files_imbricata/trimmed/alleles_workflow/renamed_genes
genelist=$MYBASE/Combined/genelist_with_asterisks.txt
omm=/home/mskset001/MACSE_V2_PIPELINES

cd $MYBASE/Combined
mkdir exons_aligned_ALFIX_macse
cd exons_aligned_ALFIX_macse
while read i;do
cp ../combined.alleles."$i".fixed.FNA .
$omm/MACSE_ALFIX_v01.sif --in_seq_file combined.alleles."$i".fixed.FNA --out_dir "$i"_asterisk --out_file_prefix "$i"_ALFIX --min_percent_NT_at_ends 0.2 --java_mem 5000m
done < $genelist

cd $MYBASE/Combined
cp exons_aligned_ALFIX_macse/*_asterisk/*_ALFIX_final_align_NT.aln exons_aligned















