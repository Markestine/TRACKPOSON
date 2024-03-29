# TRACKPOSON
Pipeline to detect transposable elements (TEs) insertions polymorphism

Trackposon is a pipeline to detect TEs insertions with paired-end raw data in the 3000 rice genomes.  
Retrotranspositional landscape of Asian rice revealed by 3000 genomes, Carpentier et al, Nature Communications, 2019 ⟨10.1038/s41467-018-07974-5⟩

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

- bowtie2 index for your TE reference sequence (the 32 TE families consensus are in fasta file 32_TE_families_TRACKPOSON_NC_Carpentier_et_al.fa)
bowtie2-build $fa $name_index

-  blast+ database from the reference genome  
makeblastdb -in $ref.fa -dbtype nucl -title $db_title

- 10kb windows bed file from the reference genome  
bedtools makewindows -g $genome_file -w 10000 >  $genome_ref_10kbwindows.bed

The genome_file should tab delimited and structured as follows:  
chromName chromSize  
For example :  
Chr1    249250621  
Chr2    243199373  


Change the path for your own files in TRACKPOSON.sh  
and after run TRACKPOSON (TRACKPOSON.sh)  

--------------------
Step 1 - Run TRACKPOSON
bash TRACKPOSON.sh

Step2 - Automatic anaysis of output
bash Analyse_pipeline.sh

--------------------
Analysis of TRACKPOSON output

- Analyse_pipeline.sh : create a final matrix of presence or absence TIPs for each TE family (Analyse_pipeline.R) and draw 2 histograms for the distribution of TEs insertion in 3000 rice genome dataset (Analyse_tradi.R)  
