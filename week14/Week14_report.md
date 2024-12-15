# RNA-seq Differential Expression Analysis 

## Setup Statistical Environment

First, set up the required statistical environment:

```
# Clone the repository in bioinfo env
bio code

# Create the stats environment
bash src/setup/init-stats.sh

# Verify installation
micromamba run -n stats Rscript src/setup/doctor.r
```

## Generate Simulated Data

Generate simulated count data using the stats environment:

```
# Generate counts using the simulator
micromamba run -n stats Rscript src/r/simulate_counts.r
```

## Analysis Pipeline

The analysis is automated using a Makefile. Here's the complete file:

```
all: pca heatmap

# Create results directory
results:
	mkdir -p results
	
# Run DESeq2
deseq2.csv: counts.csv design.csv
	Rscript src/r/deseq2.r -c counts.csv -d design.csv

# Generate PCA plot
pca: deseq2.csv src/r/plot_pca.r | results
	Rscript src/r/plot_pca.r -c deseq2.csv -d design.csv -o results/pca_plot.pdf

# Generate heatmap
heatmap: deseq2.csv src/r/plot_heatmap.r | results
	Rscript src/r/plot_heatmap.r -c deseq2.csv -d design.csv -o results/heatmap.pdf

# Clean up
clean:
	rm -rf results deseq2.csv counts.csv design.csv

.PHONY: all clean pca heatmap
```

## Discussion of Results

- **Number of Genes Identified:** The dataset includes 6,411 genes. Among these, significant genes can be identified based on adjusted p-values (`PAdj`). For instance, genes with `PAdj < 0.05` are commonly considered statistically significant.

- **Expression Levels:** Genes like GENE-18801 show a dramatic upregulation in condition B compared to condition A (baseMeanB = 16,360.5 vs. baseMeanA = 613.6). In contrast, genes like GENE-2564 are highly downregulated in condition B (baseMeanB = 191.3 vs. baseMeanA = 6,719.4).

- **Reliability**: Many genes have highly significant p-values (`PValue < 10^-10`), indicating strong evidence for differential expression. 

- **PCA**

  ![](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/week14/pca.jpg)

- **Heatmap**

  ![](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/week14/heatmap.jpg)

