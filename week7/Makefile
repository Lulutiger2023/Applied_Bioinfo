# Genome variables for simulation
GENOME_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64/GCF_000146045.2_R64_genomic.fna.gz
GENOME_FILE=genome.fna.gz
UNZIPPED_GENOME_FILE=genome.fna

# Variables for simulation
SIMULATED_RDIR=simulate_reads
SIMULATED_R1=$(SIMULATED_RDIR)/wgsim_read1.fq.gz
SIMULATED_R2=$(SIMULATED_RDIR)/wgsim_read2.fq.gz
N=10000  # Number of reads to download or simulate

# Variables for SRA data
SRR=SRR796787
SRA_RDIR=sra_reads
TRIMMED_RDIR=trimmed_reads
R1=$(SRA_RDIR)/${SRR}_1.fastq
R2=$(SRA_RDIR)/${SRR}_2.fastq
TRIMMED_R1=$(TRIMMED_RDIR)/${SRR}_1.trimmed.fastq
TRIMMED_R2=$(TRIMMED_RDIR)/${SRR}_2.trimmed.fastq

# Adapter for trimming
ADAPTER=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA

# Output directory for reports
PDIR=reports

# Default target
all: genome simulate download trim fastqc

# Help message
usage:
	@echo "  usage      - Show this help message"
	@echo "  genome     - Download the genome from URL"
	@echo "  simulate   - Simulate reads for the genome"
	@echo "  download   - Download reads from SRA"
	@echo "  trim       - Trim reads"
	@echo "  fastqc     - Run FastQC on the reads"

# Download the genome for simulation (using a variable for the URL)
genome:
	wget $(GENOME_URL) -O $(GENOME_FILE)
	gunzip $(GENOME_FILE)
	samtools faidx $(UNZIPPED_GENOME_FILE)

# Simulate reads for the genome
simulate:
	@# Create the simulate_reads directory if it doesn't exist
	mkdir -p $(SIMULATED_RDIR)

	@# Simulate reads from the genome
	wgsim -N $(N) -1 100 -2 100 -r 0 -R 0 -X 0 $(UNZIPPED_GENOME_FILE) $(SIMULATED_RDIR)/wgsim_read1.fq $(SIMULATED_RDIR)/wgsim_read2.fq

	@# Compress the simulated reads
	gzip $(SIMULATED_RDIR)/wgsim_read1.fq $(SIMULATED_RDIR)/wgsim_read2.fq

	@# Run read statistics using seqkit
	seqkit stats $(SIMULATED_R1) $(SIMULATED_R2)


# Download reads from SRA
download:
	mkdir -p $(SRA_RDIR)
	fastq-dump -X $(N) --split-files -O $(SRA_RDIR) $(SRR)

# Trim reads
trim: 
	@# Create the trimmed_reads directory if it doesn't exist
	mkdir -p $(TRIMMED_RDIR)

	@# Trim the downloaded reads
	fastp --adapter_sequence=$(ADAPTER) --cut_tail \
		-i $(R1) -I $(R2) -o $(TRIMMED_R1) -O $(TRIMMED_R2)

# Run FastQC on raw and trimmed reads
fastqc:
	mkdir -p $(PDIR)
	fastqc -q -o $(PDIR) $(R1) $(R2)
	fastqc -q -o $(PDIR) $(TRIMMED_R1) $(TRIMMED_R2)

