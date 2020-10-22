####You need to change the variables
###################################
fq1=$file"1.fq.gz"
fq2=$file"2.fq.gz"
out=$out_name
te=$te_name
DIR=$output_DIR
DB=$path_to_TE-bowtie2_index
blast_ref_database=$path_to_blast_ref_database
perl_script=$path_to_find_insertion_point.pl
ref_genome_10kbpwindows.bed=$path_to_ref_genome_10kbpwindows.bed
########################
#######################

cd $DIR

######mapping reads against TE reference

bowtie2 --time --end-to-end  -k 1 --very-fast -p 6 -x $DB  -1 $fq1 -2 $fq2  | samtools view -bS -@ 2 - > "$out"-vs-"$te".bam

#######keep only unmap reads with flag unmap/map
#et fasta creation
samtools view "$out"-vs-"$te".bam | awk -F "\t" '{if ( ($1!~/^@/) && (($2==69) || ($2==133) || ($2==165) || ($2==181) || ($2==101) || ($2==117)) ) {print ">"$1"\n"$10}}' > $out-vs-$te.fa

######blast fa against reference genome (IRGSP1.0) for identification insertion point
blastn -db $blast_ref_database -query $out-vs-$te.fa -out $out-vs-$te.fa.bl -num_threads 8 -evalue 1e-20

######parse blast to find TE insertion point 
perl $perl_script $out-vs-$te.fa.bl $out-vs-$te

######sort bed output
sort -k1,1 -k2,2n $out-vs-$te.bed > $out-vs-$te.sort.bed

######coveragebed by 10kb windows
bedtools coverage -counts -nonamecheck -a $ref_genome_10kbpwindows.bed -b $out-vs-$te.sort.bed | awk -F "\t" '{if ($4>=2){print $0}}' > coveragebed_$out-vs-$te\_per10kb.bed

######cleaning temporary files
rm $out-vs-$te.bam
rm $out-vs-$te.fa*
rm $out-vs-$te.bed
