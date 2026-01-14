#!/usr/bin/env bash
#
# Quality control and trimming of paired-end Illumina reads using fastp
# 
# Usage: bash 01_fastp.sh <fastq_dir> <output_dir>
# Example: bash 01_fastp.sh data/00_fastq data/01_fastp
#
# Author: Ayna Mammedova
# ---
set -Eeou pipefail

FQ=$1
OUT=$2
SAMPLES=$FQ/sample-names.txt
THREADS=12

mkdir -p $OUT

for SAMPLE in $(cat $SAMPLES)
do
    echo "Processing $SAMPLE..."
    fastp -i $FQ/${SAMPLE}_R1.fq.gz \
          -I $FQ/${SAMPLE}_R2.fq.gz \
          -o $OUT/${SAMPLE}.trimmed.1.fq.gz \
          -O $OUT/${SAMPLE}.trimmed.2.fq.gz \
          -h $OUT/${SAMPLE}.fastp.html \
          -j $OUT/${SAMPLE}.fastp.json \
          -w $THREADS
done

echo "Fastp complete!"