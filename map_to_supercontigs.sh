#!/bin/bash

# This workflow will take the supercontig output of HybPiper and return a supercontig that 
# contains heterozygous positions as ambiguity bases. Uses paired reads.

#The script should be run on a FASTA file containing all the supercontigs of interest.


if [[ $# -eq 0 ]] ; then
    echo 'usage: map_to_supercontigs.sh [-Xmx]mem[G] prefix[.supercontigs.fasta] readfile1.fq readfile2.fq'
    exit 1
fi

#########CHANGE THESE PATHS AS NEEDED###########

gatkpath=/home/mskset001/gatk3/GenomeAnalysisTK/GenomeAnalysisTK.jar
picardpath=/home/mskset001/picard/picard.jar

#############COMMAND LINE ARGUMENTS############

mem=$1
prefix=$2
read1fq=$3
read2fq=$4

supercontig=$prefix.supercontigs.fasta

mkdir $prefix
cd $prefix

ln -s ../$supercontig


#####STEP ZERO: Make Reference Databases

java -Xmx"$mem"G -jar $picardpath CreateSequenceDictionary \
R=$supercontig 
bwa index $supercontig
samtools faidx $supercontig

#####STEP ONE: Map reads

echo "Mapping Reads"

bwa mem -t $SLURM_NTASKS $supercontig $read1fq $read2fq | samtools view -bS - | samtools sort - -o $supercontig.sorted.bam

java -Xmx"$mem"G -jar $picardpath FastqToSam  \
F1=$read1fq \
F2=$read2fq \
O=$supercontig.unmapped.bam \
SM=$supercontig

java -Xmx"$mem"G -jar $picardpath MergeBamAlignment \
ALIGNED=$supercontig.sorted.bam \
UNMAPPED=$supercontig.unmapped.bam \
O=$supercontig.merged.bam \
R=$supercontig

#####STEP TWO: Mark duplicates

echo "Marking Duplicates"
java -Xmx"$mem"G -jar $picardpath MarkDuplicates \
I=$supercontig.merged.bam \
O=$supercontig.marked.bam \
M=$supercontig.metrics.txt

#######STEP THREE: Identify variants, select only SNPs

echo "Identifying variants"

samtools index $supercontig.marked.bam
#samtools mpileup -B -f $supercontig $supercontig.marked.bam -v -u > $supercontig.vcf

java -Xmx"$mem"G -jar $gatkpath \
-R $supercontig \
-T HaplotypeCaller \
-I $supercontig.marked.bam \
-o $supercontig.vcf


time java -Xmx"$mem"G -jar $gatkpath \
-T SelectVariants \
-R $supercontig \
-V $supercontig.vcf \
-selectType SNP \
-o $supercontig.snps.vcf 


######STEP FOUR: Output new supercontig FASTA with ambiguity codes

echo "Generating IUPAC FASTA file"

java -Xmx"$mem"G -jar $gatkpath \
-T FastaAlternateReferenceMaker \
-R $supercontig \
-o $supercontig.iupac \
-V $supercontig.snps.vcf \
-IUPAC $supercontig

cd ..




