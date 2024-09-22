# Species: Saccharomyces cerevisiae

# Base URL for the genome of Saccharomyces cerevisiae from NCBI
BASE_URL="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/146/045/GCF_000146045.2_R64"

# Define file names (dynamically extracted from the folder URL)
GFF_FILE="GCF_000146045.2_R64_genomic.gff.gz"
FASTA_FILE="GCF_000146045.2_R64_genomic.fna.gz"

GENES="gene.gff3"

#
# Nothings needs to be changed below this line
#

# Download the file
wget "${BASE_URL}/${GFF_FILE}"
wget "${BASE_URL}/${FASTA_FILE}"

# Unzip the file
gunzip ${GFF_FILE}
gunzip ${FASTA_FILE}

# Remove the .gz extension to get the unzipped file names
UNZIPPED_GFF_FILE="${GFF_FILE%.gz}"
UNZIPPED_FASTA_FILE="${FASTA_FILE%.gz}"

# Extract the gene features from the GFF3 file
awk '$3=="gene" {print $0}' ${UNZIPPED_GFF_FILE} > ${GENES}

# Count the number of genes in the file
wc -l ${GENES}



