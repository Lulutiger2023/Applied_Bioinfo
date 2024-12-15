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