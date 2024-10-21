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
ALIGNMENT_DIR=alignments
SIMULATED_BAM=$(ALIGNMENT_DIR)/simulated_sorted.bam
SRA_BAM=$(ALIGNMENT_DIR)/sra_sorted.bam

# Output directory for reports
PDIR=reports

# Default target
all: genome simulate download trim fastqc index align

# Help message
usage:
	@echo "  usage      - Show this help message"
	@echo "  genome     - Download the genome from URL"
	@echo "  simulate   - Simulate reads for the genome"
	@echo "  download   - Download reads from SRA"
	@echo "  trim       - Trim reads"
	@echo "  fastqc     - Run FastQC on the reads"
	@echo "  index      - Index the reference genome"
	@echo "  align      - Align reads and output sorted BAM files"

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

# Align the reads to the reference genome and output sorted BAM files
align: 
	mkdir -p $(ALIGNMENT_DIR)
	bwa mem $(UNZIPPED_GENOME_FILE) $(SIMULATED_R1) $(SIMULATED_R2) | samtools sort -o $(SIMULATED_BAM)
	samtools index $(SIMULATED_BAM)
	bwa mem $(UNZIPPED_GENOME_FILE) $(TRIMMED_R1) $(TRIMMED_R2) | samtools sort -o $(SRA_BAM)
	samtools index $(SRA_BAM)

