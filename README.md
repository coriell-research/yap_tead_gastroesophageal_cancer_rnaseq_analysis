# Targeting YAP/TEAD signaling RNA-seq Analysis

This repository contains the RNA-seq analysis pipeline and results for the RNA-seq profiling of GA0518 cells without (Untreated_1 and Untreated_2) and with 200nM VT00278 treatment for 24h (VT_200_1 and VT_200_2), and the YAP knockout cells derived from GA0518 (YAP KO_D1 and YAP KO_D2 ) after 48h cell culture.

## Project Overview

This project analyzes gene expression changes in response to treatment with VT-00278 and YAP knockout in GA0518 cell line. The analysis includes quality control, quantification, and comprehensive differential expression analysis.

## Pipeline Scripts

### 01_fastp.sh

**Purpose**: Quality control and adapter trimming of paired-end RNA-seq reads (fastp v1.0.1)

**Function**: - Performs quality control assessment using fastp - Trims low-quality bases and adapter sequences - Generates QC metrics and HTML reports for each sample - Produces trimmed FASTQ files for downstream analysis

**Usage**:

``` bash
bash scripts/01_fastp.sh data/00_fastq data/01_fastp
```

**Input**:

-   Raw paired-end FASTQ files: `data/00_fastq/{SAMPLE}_R1.fq.gz`, `data/00_fastq/{SAMPLE}_R2.fq.gz`

-   Sample list: `data/00_fastq/sample-names.txt`

**Output**:

-   Trimmed FASTQ files: `data/01_fastp/{SAMPLE}.trimmed.1.fq.gz`, `data/01_fastp/{SAMPLE}.trimmed.2.fq.gz`

-   QC reports: `data/01_fastp/{SAMPLE}.fastp.html`, `data/01_fastp/{SAMPLE}.fastp.json`

------------------------------------------------------------------------

### 02_quant.sh

**Purpose**: Quantify transcript abundance using Salmon pseudo-alignment (salmon v1.10.0)

**Function**:

-   Maps reads to a reference transcriptome using Salmon in quasi-mapping mode

-   Estimates transcript abundance - Incorporates GC-bias and sequence-bias corrections

-   Performs validation of mappings for quality control

-   Conducts Gibbs sampling for uncertainty quantification

**Usage**:

``` bash
bash scripts/02_quant.sh data/01_fastp data/02_quant /path/to/salmon_index
```

**Input**:

-   Trimmed FASTQ files: `data/01_fastp/{SAMPLE}.trimmed.1.fq.gz`, `data/01_fastp/{SAMPLE}.trimmed.2.fq.gz`

-   Salmon index: pre-built index for human transcriptome - Sample list: reads from `data/01_fastp/sample-names.txt`

**Output**:

-   Salmon quantification directory: `data/02_quant/{SAMPLE}_quants/`

-   Quantification file: `data/02_quant/{SAMPLE}_quants/quant.sf`

------------------------------------------------------------------------

### 03_analysis.qmd

**Purpose**: Comprehensive differential expression analysis and visualization

**Function**:

-   Imports quantification data using tximeta for accurate gene-level abundance estimation

-   Performs quality control (RLE plots, library distributions, PCA, heatmaps)

-   Filters out non-protein-coding genes and lowly expressed genes

-   Tests for distribution normalization violations using quantro

-   Conducts differential gene expression (DGE) analysis using edgeR (v4.6.2)

-   Creates volcano and ma plots for DGE results

-   Creates heatmaps for specific sets of genes (hippo/yap/tead signaling, cell cycle, Pol2 initiation, elongation, and termination genes)

-   Performs gene ontology (GO) enrichment analysis using clusterProfiler (v4.16.0)

-   Creates dotplots for GO results

-   Executes gene set enrichment analysis (GSEA) on Hallmark gene sets using fgsea (v1.34.0)

-   Creates dotplots for GSEA results and enrichment plots for specific gene sets (Interferon alpha and gamma response)

**Parameters**:

-   FDR cutoff: 0.05

-   Log-fold-change threshold: log2(1.5) ≈ 0.585

**Dependencies**:

-   R packages: coriell, edgeR, tximeta, PCAtools, ComplexHeatmap, clusterProfiler, fgsea, msigdbr, quantro, qsmooth, and visualization packages (ggplot2, patchwork, EnrichedHeatmap)

------------------------------------------------------------------------

## Sample Information

Sample metadata is stored in `data/sample-metadata.csv` with the following columns:

-   `sample`: Sample name

-   `group`: Experimental group/condition

-   `treatment`: Treatment type

## Key Results

-   **Raw counts**: `data/raw_counts_all_samples.txt`
-   **Differential Expression**: Results stored in `data/dge_results.csv`

## Contact

**Bioinformatics Analysis**: Ayna Mammedova (amammedova\@coriell.org)

**Experimental design**: Yanting Zhang (yzhang\@coriell.org)