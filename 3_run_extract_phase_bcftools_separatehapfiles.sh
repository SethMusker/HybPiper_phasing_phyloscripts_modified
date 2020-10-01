#!/bin/sh
#SBATCH --account=biosci
#SBATCH --partition=ada
#SBATCH --time=1-10:00:00
#SBATCH --nodes=1 --ntasks=40
#SBATCH --job-name="HybPiper_extract_phase"
#SBATCH --mail-user=sethmusker@gmail.com
#SBATCH --mail-type=FAIL

### NOTE KEEP ntasks at 40 (script uses parallel)

source activate HybPiper_phasing
# samtools: Version: 1.9 (using htslib 1.9)
# bcftools: Version: 1.9 (using htslib 1.9)

dir=/scratch/mskset001/Mike_files_imbricata/trimmed/alleles_workflow/renamed_genes
cd $dir
# extract_phase_bcftools.sh usage: prefix, supercontigs directory

while read i;do
$HOME/HybPiper/phyloscripts/alleles_workflow/extract_phase_bcftools_separatehapfiles.sh $i $dir
done < sample_names_underscore.txt











