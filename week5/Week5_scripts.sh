# Species: Saccharomyces cerevisiae

# Base URL for the genome of Saccharomyces cerevisiae from NCBI
BASE_URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64"

# Define file names (dynamically extracted from the folder URL)
FASTA_FILE="GCF_000146045.2_R64_genomic.fna.gz"

# Download the file
wget "${BASE_URL}/${FASTA_FILE}"
ls -lh ${FASTA_FILE}

# Unzip the file
gunzip ${FASTA_FILE}
UNZIPPED_FASTA_FILE="${FASTA_FILE%.gz}"

# Index the fasta file
samtools faidx ${UNZIPPED_FASTA_FILE}
FAI_FILE="${UNZIPPED_FASTA_FILE}.fai"
cat ${FAI_FILE}
total_genome_size=$(awk '{sum += $2} END {print sum}' ${FAI_FILE})
echo "$total_genome_size"

# Simulate reads with wgsim
GENOME=${UNZIPPED_FASTA_FILE}
expected_coverage=10
expected_read_length=100

# Set the trace
set -uex

# Calculate the number of reads using bc for arithmetic calculation

N=$(echo "$expected_coverage * $total_genome_size / $expected_read_length" | bc)
echo "Number of reads: $N"
# N=1215710

# The files to write the reads to
R1=./reads/wgsim_read1.fq
R2=./reads/wgsim_read2.fq

# --- Simulation actions below ---

# Make the directory that will hold the reads extracts 
# the directory portion of the file path from the read
mkdir -p $(dirname ${R1})

# Simulate with no errors and no mutations
wgsim -N ${N} -1 ${expected_read_length} -2 ${expected_read_length} -r 0 -R 0 -X 0 ${GENOME} ${R1} ${R2}


# Run read statistics
seqkit stats ${R1} ${R2}

# Compress the reads
gzip ${R1}
gzip ${R2}
cd reads
ls -lh 
