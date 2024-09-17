# Week3

**Species**: *Saccharomyces cerevisiae*

## Scripts:

Activate the environment

```
$ conda activate bioinfo
```

Download the NCBI data

```
$ datasets download genome accession GCF_000146045.2 --include gff3,cds,protein,rna,genome
```

Unzip the data folder

```
$ unzip ncbi_dataset.zip
```

Separate intervals of type "gene" into a different file

```
$ cat /Users/lulutiger/Desktop/SCHOOL_Courses/BMMB852/week3/ncbi_dataset/data/GCF_000146045.2/genomic.gff | awk ' $3=="gene" {print $0}' > /Users/lulutiger/Desktop/SCHOOL_Courses/BMMB852/week3/ncbi_dataset/data/GCF_000146045.2/gene.gff
```

Look for the first column name in the reference file, to be put in my Gff file created.

```
$ cat GCF_000146045.2_R64_genomic.fna | head -1
```

## Images:

**1.IGV_visualization**

![1.IGV_visualization](/Users/lulutiger/Desktop/SCHOOL_Courses/BMMB852_Applied/week3/homework/1.IGV_visualization.jpg)**2.Extracted gene_file**

![2.gene_file](/Users/lulutiger/Desktop/SCHOOL_Courses/BMMB852_Applied/week3/homework/2.gene_file.jpg)

**3.gene_track**

![3.gene_track.pic](/Users/lulutiger/Desktop/SCHOOL_Courses/BMMB852_Applied/week3/homework/3.gene_track.pic.jpg)

**4.My Gff file**

![4.creat_Gff](/Users/lulutiger/Desktop/SCHOOL_Courses/BMMB852_Applied/week3/homework/4.creat_Gff.jpg)

## Additional notes

This week, Dr.Albert has taught us to download data from online datasets, to use IGV, and also to understand the structure of the GFF file and how it can be visualized by IGV.

Really cool lectures! And thanks a lot for the detailed instructions!





