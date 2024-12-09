# Variables
GENOME_URL = https://ftp.ensembl.org/pub/release-110/fasta/drosophila_melanogaster/dna/Drosophila_melanogaster.BDGP6.46.dna.toplevel.fa.gz
GTF_URL = https://ftp.ensembl.org/pub/release-110/gtf/drosophila_melanogaster/Drosophila_melanogaster.BDGP6.46.110.gtf.gz
GENOME = genome.fa
ANNOTATION = annotation.gtf
THREADS = 8
OUTPUT_DIR = results
DESIGN_FILE = design.csv

# Default target
.PHONY: all
all: count_matrix

# Step 1: Download genome
.PHONY: genome
genome:
	mkdir -p $(OUTPUT_DIR)
	wget -O - $(GENOME_URL) | gunzip > $(OUTPUT_DIR)/$(GENOME)

# Step 2: Download annotation
.PHONY: annotation
annotation:
	wget -O - $(GTF_URL) | gunzip > $(OUTPUT_DIR)/$(ANNOTATION)

# Step 3.1: Download RNA-Seq data
.PHONY: download_reads
download_reads:
	wget -c -P $(OUTPUT_DIR) https://sra-pub-run-odp.s3.amazonaws.com/sra/$(Run)/$(Run)
	fasterq-dump --split-3 -e $(THREADS) -O $(OUTPUT_DIR) $(OUTPUT_DIR)/$(Run)

# Step 3.2: Quality control
.PHONY: qc_reads
qc_reads:
	fastqc -t $(THREADS) -o $(OUTPUT_DIR) $(OUTPUT_DIR)/$(Run).fastq

# Step 3.3: Generate alignment
.PHONY: align_reads
align_reads:
	hisat2-build $(OUTPUT_DIR)/$(GENOME) $(OUTPUT_DIR)/genome_index
	hisat2 -p $(THREADS) --dta \
		-x $(OUTPUT_DIR)/genome_index \
		-U $(OUTPUT_DIR)/$(Run).fastq \
		-S $(OUTPUT_DIR)/$(Sample).sam 2> $(OUTPUT_DIR)/$(Sample).align.log
	samtools sort -o $(OUTPUT_DIR)/$(Sample).bam $(OUTPUT_DIR)/$(Sample).sam

# Step 3.4: Index BAM file
.PHONY: index_bam
index_bam:
	samtools index $(OUTPUT_DIR)/$(Sample).bam

# Step 3.5: Quantify gene expression
.PHONY: quantify_reads
quantify_reads:
	featureCounts -T $(THREADS) \
		-t exon \
		-g gene_id \
		-M \
		-O \
		--fraction \
		--primary \
		-s 0 \
		--minOverlap 10 \
		-a $(OUTPUT_DIR)/$(ANNOTATION) \
		-o $(OUTPUT_DIR)/$(Sample).counts.txt \
		$(OUTPUT_DIR)/$(Sample).bam 2> $(OUTPUT_DIR)/$(Sample).counts.log

# Step 3.6: Simplify counts - extract gene IDs and counts from featureCounts output
.PHONY: simplify_counts
simplify_counts:
	awk 'NR>2 && $$1 ~ /^FBgn/ {print $$1"\t"$$7}' $(OUTPUT_DIR)/$(Sample).counts.txt > $(OUTPUT_DIR)/$(Sample).simple_counts.txt

# Step 4: Generate count matrix - combine all samples into a single matrix
.PHONY: count_matrix
count_matrix:
	$(eval SAMPLES := $(shell tail -n +2 $(DESIGN_FILE) | cut -d',' -f2))
	# Create matrix header
	echo -e "GeneID\t$(shell echo $(SAMPLES) | tr ' ' '\t')" > $(OUTPUT_DIR)/count_matrix.txt
	# Extract GeneID and counts from the first sample
	cp $(OUTPUT_DIR)/$(firstword $(SAMPLES)).simple_counts.txt $(OUTPUT_DIR)/matrix.tmp
	# Merge count values from other samples one by one
	$(foreach sample,$(wordlist 2,$(words $(SAMPLES)),$(SAMPLES)),\
		join -t $$'\t' $(OUTPUT_DIR)/matrix.tmp $(OUTPUT_DIR)/$(sample).simple_counts.txt > $(OUTPUT_DIR)/matrix.join.tmp;\
		mv $(OUTPUT_DIR)/matrix.join.tmp $(OUTPUT_DIR)/matrix.tmp;)
	# Add the final matrix data to count_matrix.txt
	cat $(OUTPUT_DIR)/matrix.tmp >> $(OUTPUT_DIR)/count_matrix.txt
	# Remove temporary files
	rm $(OUTPUT_DIR)/matrix.tmp
	
# Clean up
.PHONY: clean
clean:
	rm -rf $(OUTPUT_DIR)/*