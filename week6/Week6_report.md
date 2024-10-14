# Week6 report

The scripts can be found [HERE](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/Week6_scripts.sh)

## Introduction

**Dataset**: SRX253962 (Illumina whole genome shotgun sequencing of genomic DNA paired-end library 'Sage-129330' containing sample HG03788)

**Study:** Whole genome sequencing of (ITU) Indian Telugu in the UK HapMap population. DNA for sequencing was extracted from whole blood.

**Organism:** Homo sapiens

**Submitted by:** Broad Institute (BI)

## Steps

Frist, identify a *bad* sequencing dataset:

```
#SRR number for the dataset
SRR=SRR796787

# Number of reads to sample (can be adjusted or removed for full download)
N=10000
```

To make the scripts reusable, adopt the following:

```
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
```

Then the quality control process comes:

```
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
```

# Comparison

**Before quality control:**

In the original data, the quality of the bases significantly dropped after position 50, with many of the bases at positions 70-95 falling into the red zone (indicating Phred scores below 20, which means less than 99% accuracy).

![](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/week6/before.jpg)

**After quality control:**

Trimming has successfully removed the worst-quality bases. The drop in quality at the end of the reads has been reduced. Although the quality still declines after position 50, the steep drop seen earlier has been mitigated. The trimmed reads now have fewer low-quality bases at the end, and fewer bases fall into the red or yellow zones.

This improves the reliability of the data for downstream analysis, particularly in regions where poor quality would have introduced noise.

![](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/week6/after.jpg)



