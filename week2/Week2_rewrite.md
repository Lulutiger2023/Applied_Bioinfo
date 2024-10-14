# ASSIGNMENT: Week 2

## Introduction

Select an organism and download its corresponding GFF file.

Investigate this file with command line UNIX tools.

## Answers to questions

1. Tell us a bit about the organism.

**Danio rerio**, commonly known as the **zebrafish**, is a small freshwater fish that belongs to the minnow family (Cyprinidae). It is native to South Asia, particularly in countries like India, Bangladesh, Nepal, and Myanmar. 

2. How many features does the file contain?

   ```
   $ cat fish.gff3 | cut -f 3 | sort | uniq | wc -l  
         26
   ```

3. How many sequence regions (chromosomes) does the file contain?

   ```
   $ cut -f 3 fish.gff3 | grep -w 'chromosome' | wc -l
         26
   ```

4. How many genes are listed for this organism?

   ```
   $ cut -f 3 fish.gff3 | grep -w "gene" | wc -l
      25606
   ```

5. What are the top-ten most annotated feature types (column 3) across the genome?

   ```
   $ cut -f 3 fish.gff3 | sort | uniq -c | sort -nr | head -10
   484123 exon
   422160 CDS
   85796 biological_region
   48952 five_prime_UTR
   45910 mRNA
   34772 three_prime_UTR
   25606 gene
   6802 lnc_RNA
   6599 ncRNA_gene
   3359 processed_transcript
   ```

6. Having analyzed this GFF file, does it seem like a complete and well-annotated organism?

   Yes, probably because zebrafish are widely investigated in scientific research.









