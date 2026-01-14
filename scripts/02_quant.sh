#!/usr/bin/env bash
#
# Quantify transcripts using Salmon for paired-end RNA-seq data
#
# Usage: bash 03_salmon_quant.sh <fastq_dir> <output_dir> <salmon_index>
# Example: bash 03_salmon_quant.sh data/01_fastp data/02_quant /path/to/salmon_index
#
# Author: Ayna Mammedova
# ----------------------------------------------------------------------------
set -Eeou pipefail

FQ=$1
OUT=$2
IDX=$3
SAMPLES=$FQ/sample-names.txt
THREADS=18
GIBBS=30

mkdir -p $OUT

for SAMPLE in $(cat $SAMPLES)
do
  echo "Processing $SAMPLE..."
  salmon quant \
    -i $IDX \
    -l A \
    -1 $FQ/${SAMPLE}.trimmed.1.fq.gz \
    -2 $FQ/${SAMPLE}.trimmed.2.fq.gz \
    --numGibbsSamples $GIBBS \
    --validateMappings \
    --gcBias \
    --seqBias \
    --threads $THREADS \
    --output $OUT/${SAMPLE}_quants
done

echo "Salmon complete!"