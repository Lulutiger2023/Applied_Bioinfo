# Variant Calling Analysis Report

## Introduction
This report describes the variant calling analysis performed on *E. coli* genome using SRA dataset SRR10527350. We used bcftools for variant calling on the aligned BAM file and performed quality analysis of the variants.

## Methods
1. **Data Processing Pipeline**:
   - Reference genome: E. coli (GCF_000005845.2_ASM584v2)
   - SRA dataset: SRR10527350
   - Read alignment: BWA MEM
   - Variant calling: bcftools mpileup + bcftools call
   - Quality filtering: QUAL>20 and DP>10

2. **Variant Calling Command**:
```bash
bcftools mpileup -Ou -f ecoli_genome.fna bam/SRR10527350.bam | \
    bcftools call -mv -Oz -o vcf/SRR10527350.vcf.gz
```

## Variant Statistics

Total variants identified: 56,298
- SNPs: 55,878 (99.25%)
- Indels: 420 (0.75%)
- Multiallelic sites: 53

## Discussion

I have tried to find false positives or false negatives, but in vein.

In fact the variant calling seems very accurate:

![](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/week10/IGV_variant.png)
