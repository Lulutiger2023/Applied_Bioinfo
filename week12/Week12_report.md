# Automate a VCF calling pipeline

This project analyzes genomic variants in E. coli K-12 strains using whole-genome sequencing data from the SRA database.

**NOTE:**

We chose E. coli for this assignment because of its smaller genome size compared to human. But **single-end** sequencing data requires specific processing steps: fastq-dump without the `--split-files` parameter (since there's only one read file per sample), single input file processing in fastp (just one read file to trim), and bwa mem alignment with a single input fastq file. 

**Single-end Data Processing:**

```
# Download single-end reads (one file per sample)
fastq-dump --readids --skip-technical $(SRR)

# Quality trim single-end reads
fastp -i $(SRR).fastq -o $(SAMPLE).trim.fq

# Align single-end reads
bwa mem $(GENOME) $(SAMPLE).trim.fq
```

**Paired-end Data Processing:**

```
# Download paired-end reads (two files per sample)
fastq-dump --split-files --readids --skip-technical $(SRR)

# Quality trim paired-end reads
fastp -i $(SRR)_1.fastq -I $(SRR)_2.fastq \
      -o $(SAMPLE)_1.trim.fq -O $(SAMPLE)_2.trim.fq

# Align paired-end reads
bwa mem $(GENOME) $(SAMPLE)_1.trim.fq $(SAMPLE)_2.trim.fq
```

## 1. Environment Setup

```
conda activate bioinfo
```

## 2. Reference Genome Preparation

```
make refs
```

## 3. Sample Processing

```
cat design.csv | head -25 | \
parallel --lb -j 4 --colsep ',' --header : \
make sample_vcf SRR={Run} SAMPLE={Sample}
```

## 4. Merge VCF Files

```
make merge_vcfs
```

## 5. Discussion

Analysis of the merged VCF file revealed a total of 195 variants across the E. coli K-12 samples, comprising 194 SNPs and 1 indel. The transition/transversion ratio (Ts/Tv) of 0.32 suggests potential sequencing artifacts or false positives that may require additional filtering. The majority of variants showed relatively low sequencing depth (60% with 2x coverage), though some regions reached up to 120x coverage. The most frequent substitution types were G>T (67 occurrences) and C>A (53 occurrences), while quality scores varied considerably, with most variants having quality scores between 3.1 and 10.7, and only a few high-quality variants exceeding QUAL 100. These findings suggest that while variants were successfully identified, the relatively low coverage and quality scores indicate that stricter filtering criteria might be necessary for downstream analyses. Future studies would benefit from increased sequencing depth to improve variant calling confidence.
