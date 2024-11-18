# Week 11 report

I should say I have taken many tries to finish this assignment.

## 1. VEP

At first I used VEP using the codes from course website:

```
# VEP needs a sorted and compressed GFF file.
${GFF}.gz:
    # Sort and compress the GFF file
    # Needs the double $ to pass the $ from make to bash
    cat ${GFF} | sort -k1,1 -k4,4n -k5,5n -t$$'\t' | bgzip -c > ${GFF}.gz

    # Index the GFF file
    tabix -p gff ${GFF}.gz

# VEP is installed in the environment called vep
vep: ${GFF}.gz
    mkdir -p results
    micromamba run -n vep \
        ~/src/ensembl-vep/vep \
        -i ${VCF} \
        -o results/vep.txt \
        --gff ${GFF}.gz \
        --fasta ${REF} \
        --force_overwrite 

    # Show the resulting files
    ls -lh results/*
```

And the results turned out "no data", as follows:

![](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/week11/1_VEPresult.jpg)

![](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/week11/2_VEPresult.jpg)

Then ChatGPT told me "**When annotating variants in bacterial genomes (like E. coli), VEP may not be the best choice as it is primarily designed for eukaryotic genomes.**"

So I just chose to use SnpEff.

## 2. SnpEff

We can use either prebuilt databases or generate our own databases to generate the predictions here. 

### custom databases

In this assignment I mainly use the GFF file to generate custom database, adding these to my makefile:

```
# Variables for GFF file
GFF_URL=https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.gff.gz
GFF=annotations.gff

# Establish the effects of variants
# Download and prepare GFF file
gffdownload:
	wget $(GFF_URL) -O $(GFF).gz
	gunzip -c $(GFF).gz > $(GFF)
	# Also keep the compressed version for other uses
	zcat $(GFF).gz | sort -k1,1 -k4,4n -k5,5n -t$$'\t' | bgzip -c > $(GFF).gz.tmp
	mv $(GFF).gz.tmp $(GFF).gz
	tabix -p gff $(GFF).gz

# snpEff variables
SNPEFF_DATA=~/snpEff/data
SNPEFF_CONFIG=~/.snpEff/snpEff.config

# prepare vcf
prepare_vcf:
	mkdir -p tmp
	cp vcf/$(SRR).vcf.gz tmp/prepared.vcf.gz
	bcftools index tmp/prepared.vcf.gz

# run snpEff
snpeff: prepare_vcf gffdownload
	# Build the custom database
	mkdir -p idx/snpEff/genome
	# Copy files
	cp -f $(UNZIPPED_GENOME_FILE) idx/snpEff/genome/sequences.fa
	cp -f $(GFF) idx/snpEff/genome/genes.gff
	# Create configuration file  
	echo "# SnpEff configuration file" > snpeff.config
	echo "genome.genome : E. coli K12" >> snpeff.config
	echo "genome.chromosomes : NC_000913.3" >> snpeff.config
	# Build database
	snpEff build -dataDir idx/snpEff -v genome
	# run
	mkdir -p results/
	snpEff ann \
		-dataDir idx/snpEff \
		-v \
		-csvStats results/snpeff.csv \
		-stats results/snpeff.html \
		genome \
		tmp/prepared.vcf.gz | \
		bcftools view -O z -o results/snpeff.vcf.gz
	bcftools index results/snpeff.vcf.gz

```

And the results are:

![](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/week11/3_Snpgff.jpg)

![](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/week11/4_Snpgff.jpg)

❓**But why so many warnings?**

### prebuilt databases

To use prebuilt databases online, the preparations steps are as follows:

```
SNPEFF_DATA=~/snpEff/data
SNPEFF_CONFIG=~/.snpEff/snpEff.config
SNPEFF_DB=Escherichia_coli_str_k_12_substr_mg1655

setup_snpeff:
	mkdir -p results
	mkdir -p ~/.snpEff
	echo "data.dir = ~/.snpEff/data/" > $(SNPEFF_CONFIG)
	echo "Downloading snpEff database..."
	snpEff download -v $(SNPEFF_DB)
```

Then SnpEff can be conducted.