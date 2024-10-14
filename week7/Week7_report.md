# Week7_Workflow Using Makefile

This document explains how to use the `Makefile` to execute various bioinformatics tasks, including genome download, simulation of reads, downloading reads from SRA, trimming reads, and generating quality control reports using FastQC and MultiQC.

### Targets in the Makefile

- **usage**: Guides users for this Makefile.
- **genome**: Downloads the reference genome and prepares it for simulations.
- **simulate**: Simulates paired-end reads from the downloaded genome using `wgsim`.
- **download**: Downloads reads from SRA using `fastq-dump`.
- **trim**: Trims the reads using `fastp`.
- **fastqc**: Runs `FastQC` on both the raw and trimmed reads.

## Step-by-Step Workflow

### 1. Download the Genome

The `genome` target downloads the reference genome from a specified URL and prepares it for use in simulations.

```bash
make genome -n
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.fna.gz -O genome.fna.gz
gunzip genome.fna.gz
samtools faidx genome.fna
```

This will download the genome, uncompress it, and index it using `samtools`. The genome will be saved as `genome.fna`.

### 2. Simulate Reads

After downloading the genome, you can simulate paired-end reads from the genome using the `simulate` target.

```bash
make simulate -n
# Create the simulate_reads directory if it doesn't exist
mkdir -p simulate_reads
# Simulate reads from the genome
wgsim -N 10000 -1 100 -2 100 -r 0 -R 0 -X 0 genome.fna simulate_reads/wgsim_read1.fq simulate_reads/wgsim_read2.fq
# Compress the simulated reads
gzip simulate_reads/wgsim_read1.fq simulate_reads/wgsim_read2.fq
# Run read statistics using seqkit
seqkit stats simulate_reads/wgsim_read1.fq.gz simulate_reads/wgsim_read2.fq.gz
```

This step uses `wgsim` to simulate reads from the genome, compresses the output, and runs read statistics using `seqkit`.

### 3. Download Reads from SRA

The `download` target downloads real sequencing data from the SRA database using `fastq-dump`.

```bash
make download -n
mkdir -p sra_reads
fastq-dump -X 10000 --split-files -O sra_reads SRR796787
```

This will download the first 10,000 reads from the specified SRA accession (`SRR796787`) and save them in the `sra_reads/` directory.

### 4. Trim Reads

The `trim` target trims the downloaded reads using `fastp`. It will remove adapters and filter out low-quality reads.

```bash
make trim -n
# Create the trimmed_reads directory if it doesn't exist
mkdir -p trimmed_reads
# Trim the downloaded reads
fastp --adapter_sequence=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA --cut_tail \
	-i sra_reads/SRR796787_1.fastq -I sra_reads/SRR796787_2.fastq -o trimmed_reads/SRR796787_1.trimmed.fastq -O trimmed_reads/SRR796787_2.trimmed.fastq
```

The trimmed reads are saved in the `trimmed_reads/` directory.

### 5. Run Quality Control (FastQC)

The `fastqc` target runs `FastQC` on both raw and trimmed reads to assess the quality.

```bash
make fastqc -n
mkdir -p reports
fastqc -q -o reports sra_reads/SRR796787_1.fastq sra_reads/SRR796787_2.fastq
fastqc -q -o reports trimmed_reads/SRR796787_1.trimmed.fastq trimmed_reads/SRR796787_2.trimmed.fastq
```

The quality control reports are saved in the `reports/` directory.

### Additional: Run Complete Workflow

To run the entire workflow from start to finish, you can use the `all` target. This will execute all the steps in the correct order.

```bash
make all
```

## Conclusion

This `Makefile` automates a full bioinformatics workflow, starting from downloading a genome and simulating reads, to performing quality control on real sequencing data from SRA. It simplifies running the necessary tools by organizing the workflow into clearly defined steps.

