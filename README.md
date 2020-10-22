# TRACKPOSON
Pipeline to detect transposable elements (TEs) insertions polymorphism

Trackposon is a pipeline to detect TEs insertions with paired-end raw data.

---------------------
Requirements

Softwares
- bowtie2
- samtools
- blastn+
- bedtools
- perl script (find_insertion_point.pl) in the running directory
- BioSearchIO and GenericResult perl modules

--------------------
Files input
- Paired-end data from resequencing genome  
Noted : the name of fast files will be like this $file_1.fq & $file_2.fq  

- bowtie2 index for your TE reference sequence  
bowtie2-build $fa $name_index

-  blast+ database from the reference genome  
makeblastdb -in $ref.fa -dbtype nucl -title $db_title

- 10kb windows bed file from the reference genome  
bedtools make windows -g $genome_file -w 10000 >  $genome_ref_10kbwindows.bed

The genome_file should tab delimited and structured as follows:  
<chromName><TAB><chromSize>  
For example :  
Chr1    249250621  
Chr2    243199373  


Change the path for your own files in TRACKPOSON.sh  
and after run TRACKPOSON (./TRACKPOSON.sh)  
