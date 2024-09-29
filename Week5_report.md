# Week5. Simulating FASTQ files

**Species: Saccharomyces cerevisiae**

The scripts can be found [HERE](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/Week5_scripts.sh)

## Summary Report:

1. Select a genome, then download the corresponding FASTA file.

   - The size of the file

     **3.7M**

   - The total size of the genome

     **12157105** bp

   - The number of chromosomes in the genome

     There are **mitochondrion** and **16 chromosomes** in the genome

   - The name (id) and length of each chromosome in the genome.

     | ID           | Length  |
     | ------------ | ------- |
     | NC_001133.9  | 230218  |
     | NC_001134.8  | 813184  |
     | NC_001135.5  | 316620  |
     | NC_001136.10 | 1531933 |
     | NC_001137.3  | 576874  |
     | NC_001138.5  | 270161  |
     | NC_001139.9  | 1090940 |
     | NC_001140.6  | 562643  |
     | NC_001141.2  | 439888  |
     | NC_001142.9  | 745751  |
     | NC_001143.9  | 666816  |
     | NC_001144.5  | 1078177 |
     | NC_001145.3  | 924431  |
     | NC_001146.8  | 784333  |
     | NC_001147.6  | 1091291 |
     | NC_001148.4  | 948066  |
     | NC_001224.1  | 85779   |

2. Generate a simulated FASTQ output for a sequencing instrument of your choice. Set the parameters so that your target coverage is 10x.

   - How many reads have you generated?

     **1,215,710**

   - What is the average read length?

     **100 bp** (as specified in the simulation parameters)

   - How big are the FASTQ files?

     FASTQ file sizes (uncompressed):

     Forward reads: **121.6 MB**

     Reverse reads: **121.6 MB**

     Total size: 243.2 MB (uncompressed)

   - Compress the files and report how much space that saves.

     Uncompressed file size: 121.6MB each.

     Compressed file size: 56MB each.

     **Space saved**: Around **54%** (from a total of 243.2MB to 112MB).

3. How much data would be generated when covering the Yeast, the Drosophila or the Human genome at 30x?

​	Around **364.7** MB.

## Detailed Steps:

1. Base URL for the genome of Saccharomyces cerevisiae from NCBI

```
BASE_URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64"
```

2. Define file names (dynamically extracted from the folder URL)

```
FASTA_FILE="GCF_000146045.2_R64_genomic.fna.gz"
```

3. Download the file

```
wget "${BASE_URL}/${FASTA_FILE}"
ls -lh ${FASTA_FILE}
```

Result: **3.7M** Apr  9  2018 GCF_000146045.2_R64_genomic.fna.gz

4. Unzip the file

```
gunzip ${FASTA_FILE}
UNZIPPED_FASTA_FILE="${FASTA_FILE%.gz}"
```

5. Index the fasta file

```
samtools faidx ${UNZIPPED_FASTA_FILE}
FAI_FILE="${UNZIPPED_FASTA_FILE}.fai"
cat ${FAI_FILE}
```

Result: There are **mitochondrion** and **16 chromosomes** in the genome, as follows:

NC_001133.9     230218  76      80      81
NC_001134.8     813184  233249  80      81
NC_001135.5     316620  1056676 80      81
NC_001136.10    1531933 1377332 80      81
NC_001137.3     576874  2928491 80      81
NC_001138.5     270161  3512653 80      81
NC_001139.9     1090940 3786270 80      81
NC_001140.6     562643  4890926 80      81
NC_001141.2     439888  5460680 80      81
NC_001142.9     745751  5906143 80      81
NC_001143.9     666816  6661293 80      81
NC_001144.5     1078177 7336523 80      81
NC_001145.3     924431  8428257 80      81
NC_001146.8     784333  9364322 80      81
NC_001147.6     1091291 10158537        80      81
NC_001148.4     948066  11263548        80      81
NC_001224.1     85779   12223540        80      81

```
total_genome_size=$(awk '{sum += $2} END {print sum}' ${FAI_FILE})
echo "$total_genome_size"
```

Result: Total genome size: **12157105** bp

6. Simulate reads with wgsi

```
# Set the trace
set -uex

# The location of the genome file (FASTA format)
GENOME=${UNZIPPED_FASTA_FILE}

# Calculate the number of reads using bc for arithmetic calculation
N=$(echo "$expected_coverage * $total_genome_size / $expected_read_length" | bc)
echo "Number of reads: $N"

# Lengh of the reads
L=100

# The files to write the reads to
R1=./reads/wgsim_read1.fq
R2=./reads/wgsim_read2.fq

# --- Simulation actions below ---

# Make the directory that will hold the reads extracts 
# the directory portion of the file path from the read
mkdir -p $(dirname ${R1})

# Simulate with no errors and no mutations
wgsim -N ${N} -1 ${L} -2 ${L} -r 0 -R 0 -X 0 \
      ${GENOME} ${R1} ${R2}

# Run read statistics
seqkit stats ${R1} ${R2}

# Compress the reads
gzip ${R1}
gzip ${R2}
cd reads
ls -lh 
```

Result:

[wgsim] seed = 1727651297

[wgsim_core] calculating the total length of the reference sequence...

[wgsim_core] 17 sequences, total length: 12157105



file          format type  num_seqs   sum_len min_len avg_len max_len

./reads/wgsim_read1.fq FASTQ  DNA  1,215,710 121,571,000   100   100   100

./reads/wgsim_read2.fq FASTQ  DNA  1,215,710 121,571,000   100   100   100

