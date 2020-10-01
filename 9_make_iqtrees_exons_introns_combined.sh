#!/bin/sh
#SBATCH --account=biosci
#SBATCH --partition=ada
#SBATCH --time=2-10:00:00
#SBATCH --nodes=1 --ntasks=40
#SBATCH --job-name="iqtree2_ex_in"
#SBATCH --mail-user=sethmusker@gmail.com
#SBATCH --mail-type=FAIL

## fit separate models to each partition. Extended model search.
## keep searching likelihood space for longer (-nstop 500; default 100) (http://www.iqtree.org/doc/Command-Reference#tree-search-parameters)
## 1000 ultrafast boots (for collapsing nodes later)

cd /scratch/mskset001/Mike_files_imbricata/trimmed/alleles_workflow/renamed_genes/Combined/exons_introns_to_combine/combined_exons_introns
parallel -j 10 "~/iqtree-2.0.6-Linux/bin/iqtree2 -T AUTO -ntmax 4 -s {}.combined.fasta -p {}.combined.partition -m MFP -nstop 500 -B 1000" :::: exons_with_introns_iqtree


