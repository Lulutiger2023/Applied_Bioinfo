# RNA-Seq Analysis Pipeline for Drosophila melanogaster

## Run the Makefile 

```
make genome
make annotation
cat design.csv | tail -n +2 | parallel --colsep ',' 'make download_reads Run={1} Sample={2}'
cat design.csv | tail -n +2 | parallel --colsep ',' 'make qc_reads Run={1} Sample={2}'
cat design.csv | tail -n +2 | parallel --colsep ',' 'make align_reads Run={1} Sample={2}'
cat design.csv | tail -n +2 | parallel --colsep ',' 'make index_bam Run={1} Sample={2}'
cat design.csv | tail -n +2 | parallel --colsep ',' 'make quantify_reads Run={1} Sample={2}'
cat design.csv | tail -n +2 | parallel --colsep ',' 'make simplify_counts Run={1} Sample={2}'
make count_matrix
```

## NOTE: Simplify counts

Original code from Biostar Handbook:

This command processes a consolidated featureCounts output containing multiple samples:

- Column 1: Gene IDs
- Columns 7-14: Count values for 8 samples
- Format example:

```
# Simplify the counts.
cat counts.txt | cut -f 1,7-14 > simple_counts.txt
```

Edited version for the makefile in this project:

We used a modular process with separate simplification and matrix generation steps. Therefore, this command processes one sample at a time:

- Column 1: Gene IDs (FBgn format for Drosophila)
- Column 7: Count value for the current sample
- Format example:

```
simplify_counts:
	awk 'NR>2 && $$1 ~ /^FBgn/ {print $$1"\t"$$7}' $(OUTPUT_DIR)/$(Sample).counts.txt > $(OUTPUT_DIR)/$(Sample).simple_counts.txt
```

## Single-End Sequencing

To reduce run time, I chose data from single-end sequencing for Drosophila melanogaster.

- **Data Structure**: Single reads
- Advantages
  - Lower sequencing cost per sample
  - Simpler data processing workflow
  - Sufficient for gene-level expression analysis
- Limitations
  - Less accurate in transcript isoform detection
  - More challenging in identifying structural variants

## Problems with Alignment

Initial gene counts were zero for most genes.

To solve this, adopte optimization Steps in featureCounts:

```
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
```

But still, the alignment results are not very satisfactory.

- Low alignment quality (61.09% overall alignment rate)
- High multi-mapping rate (53.62%)

## RNA-Seq Visualization in IGV

![](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/week13/IGV_forRNA.jpg)

Why this can prove that my data is indeed RNA-Seq data?

1. Coverage Pattern

   Distinct exon peaks; Clear intron-exon boundaries; Variable expression levels across gene regions

2. Junction Reads

   Reads spanning splice junctions; Evidence of RNA splicing events; Validation of transcript structure

3. Gene Structure Correlation

   Coverage aligns with annotated exons; Clear distinction between exons and introns; Confirmation of transcription boundaries

## 
