# Genome variables
GENOME_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
GENOME_FILE=ecoli_genome.fna.gz
UNZIPPED_GENOME_FILE=ecoli_genome.fna

# Variables for simulation
SIMULATED_RDIR=simulate_reads
SIMULATED_R1=$(SIMULATED_RDIR)/wgsim_read1.fq.gz
SIMULATED_R2=$(SIMULATED_RDIR)/wgsim_read2.fq.gz
N=100000  # Number of reads to simulate

# Variables for SRA data
SRR=SRR10527350
SRA_RDIR=sra_reads
TRIMMED_RDIR=trimmed_reads
R1=$(SRA_RDIR)/${SRR}_1.fastq
R2=$(SRA_RDIR)/${SRR}_2.fastq
TRIMMED_R1=$(TRIMMED_RDIR)/${SRR}_1.trimmed.fastq
TRIMMED_R2=$(TRIMMED_RDIR)/${SRR}_2.trimmed.fastq

# Adapter for trimming
ADAPTER=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA

# BAM output
BAM=bam/$(SRR).bam

# VCF output
VCF=vcf/$(SRR).vcf.gz

# Output directory for reports
PDIR=reports

# Default target
all: genome simulate download trim fastqc index bam vcf

# Print usage
usage:
	@echo "# genome   - Download and unzip reference genome"
	@echo "# simulate - Simulate paired-end reads from genome"
	@echo "# download - Download paired-end reads from SRA"
	@echo "# trim     - Trim adapters from reads"
	@echo "# fastqc   - Run quality control on reads"
	@echo "# index    - Index the reference genome"
	@echo "# bam      - Align reads and create sorted BAM"
	@echo "# vcf      - Call variants and create VCF"
	@echo "# clean    - Remove all generated files"
	@echo "# all      - Run complete pipeline"

# Download the genome
genome:
	wget $(GENOME_URL) -O $(GENOME_FILE)
	gunzip -c $(GENOME_FILE) > $(UNZIPPED_GENOME_FILE)
	samtools faidx $(UNZIPPED_GENOME_FILE)

# Simulate reads for the genome
simulate:
	mkdir -p $(SIMULATED_RDIR)
	wgsim -N $(N) -1 100 -2 100 -r 0 -R 0 -X 0 $(UNZIPPED_GENOME_FILE) $(SIMULATED_RDIR)/wgsim_read1.fq $(SIMULATED_RDIR)/wgsim_read2.fq
	gzip $(SIMULATED_RDIR)/wgsim_read1.fq $(SIMULATED_RDIR)/wgsim_read2.fq
	seqkit stats $(SIMULATED_R1) $(SIMULATED_R2)

# Download reads from SRA
download:
	mkdir -p $(SRA_RDIR)
	fastq-dump --split-files -O $(SRA_RDIR) $(SRR)

# Trim reads
trim: 
	mkdir -p $(TRIMMED_RDIR)
	fastp --adapter_sequence=$(ADAPTER) --cut_tail \
		-i $(R1) -I $(R2) -o $(TRIMMED_R1) -O $(TRIMMED_R2)

# Run FastQC on raw and trimmed reads
fastqc:
	mkdir -p $(PDIR)
	fastqc -q -o $(PDIR) $(R1) $(R2)
	fastqc -q -o $(PDIR) $(TRIMMED_R1) $(TRIMMED_R2)

# Index the reference genome
index:
	bwa index $(UNZIPPED_GENOME_FILE)

# Create BAM file
bam: 
	mkdir -p bam
	bwa mem $(UNZIPPED_GENOME_FILE) $(TRIMMED_R1) $(TRIMMED_R2) | \
		samtools view -bS - | \
		samtools sort -o $(BAM)
	samtools index $(BAM)
	samtools flagstat $(BAM) > bam/$(SRR).flagstat

# Call variants
vcf:
	mkdir -p vcf
	bcftools mpileup -Ou -f $(UNZIPPED_GENOME_FILE) $(BAM) | \
		bcftools call -mv -Ov -o vcf/$(SRR).vcf    
	bgzip vcf/$(SRR).vcf                           
	bcftools index vcf/$(SRR).vcf.gz               
	tabix -p vcf vcf/$(SRR).vcf.gz                 
	bcftools stats vcf/$(SRR).vcf.gz > vcf/$(SRR).stats

# Clean all generated files
clean:
	rm -rf $(SIMULATED_RDIR) $(SRA_RDIR) $(TRIMMED_RDIR) $(PDIR) bam vcf
	rm -f $(GENOME_FILE) $(UNZIPPED_GENOME_FILE) $(UNZIPPED_GENOME_FILE).*

# These targets do not correspond to files
.PHONY: all usage genome simulate download trim fastqc index bam vcf clean