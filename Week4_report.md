## Week4 Assignment

## Part 1: Write a script

The scripts can be found here: [Week4_Scripts](https://github.com/Lulutiger2023/Applied_Bioinfo/blob/main/Week4_scripts.sh).

To run the scripts on Paul's data, I make the following adjustments and the changes work out well:

(I made some changes to the 'Download the file' section, as the repository structure is different for the ENSEMBL database)

```
# Base URL for the genome of Saccharomyces cerevisiae from NCBI
BASE_URL_GFF="http://ftp.ensemblgenomes.org/pub/viruses/gff3/sars_cov_2"
BASE_URL_FASTA="http://ftp.ensemblgenomes.org/pub/viruses/fasta/sars_cov_2/dna"

# Define file names (dynamically extracted from the folder URL)
GFF_FILE="Sars_cov_2.ASM985889v3.101.gff3.gz"
FASTA_FILE="Sars_cov_2.ASM985889v3.dna.toplevel.fa.gz"
GENES="gene.gff3"

# Download the file
wget "${BASE_URL_GFF}/${GFF_FILE}"
wget "${BASE_URL_FASTA}/${FASTA_FILE}"
```

For Kierstyn Higgins' data, I make the following changes:

```
# Base URL for the genome of GCF_000013425.1 from NCBI
BASE_URL="ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/013/425/GCF_000013425.1_ASM1342v1"

# Define file names (dynamically extracted from the folder URL)
GFF_FILE="GCF_000013425.1_ASM1342v1_genomic.gff.gz"
FASTA_FILE="GCF_000013425.1_ASM1342v1_genomic.fna.gz"
GENES="gene.gff3"
```

## Part 2: Make use of ontologies

1. Choose a feature type from the GFF file and look up its definition in the sequence ontology.

   **Answer**: 

   **feature type**: cds

   **definition**: A contiguous sequence which begins with, and includes, a start codon and ends with, and includes, a stop codon.

2. Find both the parent terms and children nodes of the term.

   **Answer**:

   **parent term**: mrna_region 

   **children**: 

   \- polypeptide (derives_from)

   \- cds_region (part_of)

   \- edited_cds 

   \- cds_fragment 

   \- transposable_element_cds 

   \- cds_extension 

   \- cds_independently_known 

   \- cds_predicted 

3. Provide a short discussion of what you found.

   **Answer**: CDS is short for Coding Sequence, representing a sequence of nucleotides that directly corresponds to the amino acids in a protein product. Exploring the hierarchical structure of the term CDS within the Sequence Ontology, the parent term mRNA_region refers to regions of messenger RNA that contribute to protein coding or regulation, while the children terms offer insights into different functional or structural variations of the coding sequence.

   

​       