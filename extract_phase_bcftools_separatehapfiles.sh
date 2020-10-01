#!/bin/bash
set -eo pipefail
#Script to prepare phased haplotype sequences for each for one sample. 

if [[ $# -eq 0 ]] ; then
    echo 'usage: extract_phase_bcftools.sh prefix[.supercontigs.fasta] alleles_workflow_working_directory'
    exit 1
fi


prefix=$1
iupac_dir=$2
genelist=$iupac_dir/genelist.txt
cd $prefix

#Run bcftools to extract sequences

bgzip -c $prefix.supercontigs.fasta.snps.whatshap.vcf > $prefix.supercontigs.fasta.snps.whatshap.vcf.gz
tabix $prefix.supercontigs.fasta.snps.whatshap.vcf.gz
mkdir -p phased_bcftools
## rm phased_bcftools/*

parallel -j $SLURM_NTASKS "samtools faidx $iupac_dir/$prefix.supercontigs.fasta $prefix-{1} | bcftools consensus -H 1 $prefix.supercontigs.fasta.snps.whatshap.vcf.gz > phased_bcftools/$prefix-{1}_1.phased.fasta" :::: $genelist 
parallel -j $SLURM_NTASKS "samtools faidx $iupac_dir/$prefix.supercontigs.fasta $prefix-{1} | bcftools consensus -H 2 $prefix.supercontigs.fasta.snps.whatshap.vcf.gz > phased_bcftools/$prefix-{1}_2.phased.fasta" :::: $genelist 

cd ..


