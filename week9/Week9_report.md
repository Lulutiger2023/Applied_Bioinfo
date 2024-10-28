
# Alignment Analysis Report

## Question 1: 

**How many reads did not align with the reference genome?**

**Command:**  

```bash
samtools view -c -f 4 alignments/sra_sorted.bam
```
**Answer:**  
The number of unaligned reads is 699082.

---

## Question 2: 

**How many primary, secondary, and supplementary alignments are in the BAM file?**

**Commands:**  

```bash
samtools view -c -F 2304 alignments/sra_sorted.bam  # Primary alignments
samtools view -c -f 256 alignments/sra_sorted.bam   # Secondary alignments
samtools view -c -f 2048 alignments/sra_sorted.bam  # Supplementary alignments
```
**Answer:**  
- Primary alignments: 2523438
- Secondary alignments: 0
- Supplementary alignments: 2103

---

## Question 3: 

**How many properly paired alignments on the reverse strand are formed by reads contained in the first pair?**

**Command:**  
```bash
samtools view -c -f 99 alignments/sra_sorted.bam
```
**Answer:**  
The count of properly paired alignments on the reverse strand from read1 is 448386.

---

## Question 4: 

**Make a new BAM file that contains only the properly paired primary alignments with a mapping quality of over 10**

```bash
samtools view -h -q 10 -f 2 -F 2304 -b alignments/sra_sorted.bam > alignments/filtered.bam
samtools index alignments/filtered.bam
```

## Question 5:

**Flagstats Comparison**

```
samtools flagstat alignments/sra_sorted.bam
samtools flagstat alignments/filtered.bam
```

**Original BAM file (alignments/sra_sorted.bam):**  

- Total reads: 2525541
- Properly paired: 1790930
- Mapped: 1824356

**Filtered BAM file (alignments/filtered.bam):**  

- Total reads: 1774639
- Properly paired: 1774639
- Mapped: 1774639
