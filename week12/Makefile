# Variables
GENOME_URL = https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
GENOME = ecoli.fna
N = 5000000  # increased read limit for bacterial genome
THREADS = 4

# Custom Makefile settings
SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Default target
all: sample_vcf

# Reference genome preparation
refs:
	@echo "Downloading E. coli reference genome..."
	wget -c --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 5 $(GENOME_URL) -O $(GENOME).gz || \
	(echo "Download failed. Please check your internet connection and try again." && exit 1)
	@echo "Unzipping genome file..."
	gunzip -c $(GENOME).gz > $(GENOME)
	@echo "Creating genome index..."
	samtools faidx $(GENOME)
	@echo "Creating BWA index..."
	bwa index $(GENOME)
	@echo "Reference genome preparation completed successfully!"

# Process a single sample
sample_vcf:
	# Download SRA reads (single-end)
	fastq-dump --readids \
		--skip-technical -X $(N) $(SRR)
	
	# Trim reads
	fastp -i $(SRR).fastq \
		-o $(SAMPLE).trim.fq \
		--json $(SAMPLE).json --html $(SAMPLE).html
	
	# Align and sort
	bwa mem -t $(THREADS) $(GENOME) \
		$(SAMPLE).trim.fq | \
		samtools view -bS - | \
		samtools sort -@ $(THREADS) -o $(SAMPLE).bam
	samtools index $(SAMPLE).bam
	
	# Call variants
	bcftools mpileup -d 1000 -Ou -f $(GENOME) $(SAMPLE).bam | \
		bcftools call -mv -Oz -o $(SAMPLE).vcf.gz
	bcftools index $(SAMPLE).vcf.gz

# Merge all VCF files
merge_vcfs:
	bcftools merge -Oz -o merged.vcf.gz *.vcf.gz
	bcftools index merged.vcf.gz

# Clean up
clean:
	rm -f *.fastq *.fq *.bam *.bai *.vcf.gz *.vcf.gz.tbi *.json *.html
	rm -f $(GENOME) $(GENOME).gz $(GENOME).*