#This is the assignment for the [Week 2: Demonstrate data analysis at UNIX command line]
#Tell us a bit about the organism.
#Danio rerio, commonly known as the zebrafish, is a small freshwater fish that belongs to the minnow family (Cyprinidae). It is native to South Asia, particularly in countries like India, Bangladesh, Nepal, and Myanmar. 

#codes start here
#download the data and preprocessing 
$ wget https://ftp.ensembl.org/pub/current_gff3/danio_rerio/Danio_rerio.GRCz11.112.gff3.gz
$ cat Danio_rerio.GRCz11.112.gff3 | grep -v '#' > fish.gff3

#How many features does the file contain?
$ cat fish.gff3 | cut -f 3 | sort | uniq | wc -l  
#result: 26

#How many sequence regions (chromosomes) does the file contain? 
$ cut -f 3 fish.gff3 | grep -w 'chromosome' | wc -l
#result: 26

#How many genes are listed for this organism?
$ cut -f 3 fish.gff3 | grep -w "gene" | wc -l
#result: 25606

$ cut -f 3 fish.gff3 | sort | uniq -c | sort -nr | head -10
#result: 484123 exon, 422160 CDS, 85796 biological_region, 48952 five_prime_UTR
#45910 mRNA, 34772 three_prime_UTR, 25606 gene, 6802 lnc_RNA, 6599 ncRNA_gene
#3359 processed_transcript

#Having analyzed this GFF file, does it seem like a complete and well-annotated organism?
#Yes, probably because zebrafish are widely investigated in scientific research

#Share any other insights you might note.
#after watching the AI enabled coding videos, I learned the following lines could produce same results here (with tabs as the delimiter)
#$ cat fish.gff3 | awk '$3 == "gene"' | wc -l
#$ cut -f 3 fish.gff3 | grep -w "gene" | wc -l

#The end

