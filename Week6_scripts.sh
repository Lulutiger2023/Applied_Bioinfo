#!/bin/bash
# Set the trace
set -uex

# SRR number for the dataset
SRR=SRR796787

# Number of reads to sample (can be adjusted or removed for full download)
N=10000

# Define read names
R1=reads/${SRR}_1.fastq
R2=reads/${SRR}_2.fastq

# Define trimmed read names
T1=reads/${SRR}_1.trimmed.fastq
T2=reads/${SRR}_2.trimmed.fastq

# Adapter sequence to remove
ADAPTER=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA

# Directories for reads and reports
RDIR=reads
PDIR=reports

# ----- Script actions below -----

# Create the necessary directories for reads and reports
mkdir -p ${RDIR} ${PDIR}

# Download a subset of reads using fastq-dump from the SRA database
fastq-dump -X ${N} --split-files -O ${RDIR} ${SRR} # Download a subset of reads
# fastq-dump --split-files -O ${RDIR} ${SRR} # Download all reads

# Run FastQC
fastqc -q -o ${PDIR} ${R1} ${R2}

# Trim adapters and low-quality regions using fastp
fastp --adapter_sequence=${ADAPTER} --cut_tail \
      -i ${R1} -I ${R2} -o ${T1} -O ${T2}

# Run FastQC again on the trimmed reads to assess improvements
fastqc -q -o ${PDIR} ${T1} ${T2}

# Use MultiQC to compile all FastQC reports into a single report
multiqc -o ${PDIR} ${PDIR}