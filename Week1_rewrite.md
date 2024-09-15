# Week1

1. Set up your computer.

   **ANSWER: YES!

2. Follow the installation instructions.

   **ANSWER**: ALREADY DONE!

3. How can you tell that you were successful? 

   **ANSWER**: By running the doctor.py and see:

   ```
   lulutiger@Lulus-MacBook-Air ~
   $ doctor.py
   # Doctor! Doctor! Give me the news.
   # Checking symptoms ...
   # bwa           ... OK
   # datamash      ... OK
   # fastqc -h     ... OK
   # hisat2        ... OK
   # featureCounts ... OK
   # efetch        ... OK
   # esearch       ... OK
   # samtools      ... OK
   # fastq-dump    ... OK
   # bowtie2       ... OK
   # bcftools      ... OK
   # seqtk         ... OK
   # seqkit        ... OK
   # bio           ... OK
   # fastq-dump -X 1 -Z SRR1553591 ... OK
   # You are doing well, Majesty!
   (bioinfo) 
   ```

4. Can you run the samtools program?

   **ANSWER**: YES

5. What version is your samtools program?

   **ANSWER**: Version: 1.20

6. Share the link to your GitHub repository that you have set up.

   **ANSWER**: https://github.com/Lulutiger2023

7. Describe a Unix command not discussed in the class or the book. Try to find something that might be useful. When would you use that command?

   **ANSWER**: "awk" is a powerful command-line tool for processing and analyzing text data. It is particularly useful for tasks that involve searching, formatting, and extracting information from structured data like CSV files, logs, or any text with columns.

8. Describe a customization for the command you chose above (describe the effect of a flag/parameter).

   **ANSWER**: Customization: The -F Flag in awk; When you use this flag, you tell "awk" which character to use as the delimiter, like:

   ```
   awk -F'\t' '{print $1, $3}' file_with_tabs.txt
   ```

9. What flags will make the ls command write out the files sizes in “human-friendly” mode?

   **ANSWER**: ls -h

10. What flag will make the rm command ask for permission when removing a file?

    **ANSWER**: rm -i

11. Create a nested directory structure. Create files in various directories. 

    **ANSWER**:  
    mkdir -p biostar/1stclass/project
    mkdir -p biostar/2ndclass/project
    touch biostar/1stclass/project/file1.md
    touch biostar/2ndclass/project/file2.md

12. List the absolute and relative path to a file.

    **ANSWER**: 
    absolute: /home/user/work/data/AF086833/snpEffectPredictor.bin
    relative: ../snpEffectPredictor.bin

13. Demonstrate path shortcuts using the home directory, current directory, and parent directory.
    **ANSWER**: 
    home: ~
    Current: ./
    Parent: ../

    

    

    

    

    

    