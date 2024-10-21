# Week8_Alignment Using Makefile

Please note that the species used in this week is E. coli, different from week7.

(The reason for this change was that I could not visualize the bam file for Saccharomyces cerevisiae in IGV. I thought it might be too small or of low quality)

## Step-by-Step Workflow

### Variables added

```
# BAM output
ALIGNMENT_DIR=alignments
SIMULATED_BAM=$(ALIGNMENT_DIR)/simulated_sorted.bam
SRA_BAM=$(ALIGNMENT_DIR)/sra_sorted.bam
```



Then, following **Week7_Workflow Using Makefile**

### 6. Index the reference genome

```
index:
	bwa index $(UNZIPPED_GENOME_FILE)
```

The genome data (fa/fna) should serve as the reference here.

### 7. Align the reads and output sorted BAM files

```
align: 
	mkdir -p $(ALIGNMENT_DIR)
	bwa mem $(UNZIPPED_GENOME_FILE) $(SIMULATED_R1) $(SIMULATED_R2) | samtools sort -o $(SIMULATED_BAM)
	samtools index $(SIMULATED_BAM)
	bwa mem $(UNZIPPED_GENOME_FILE) $(TRIMMED_R1) $(TRIMMED_R2) | samtools sort -o $(SRA_BAM)
	samtools index $(SRA_BAM)
```



## Differences between BAM files for simulated and SRA

The simulated data shows more uniform coverage across the genome, and has idealized error rates;

![](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/week8/simulated.jpg)

while the SRA data exhibits more variability and contains real sequencing errors.

![](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/week8/sra.jpg)