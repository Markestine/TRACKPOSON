#####
# Automatic analysis of TRACKPOSON output
#####

#!/usr/bin/bash


#name of TE familly
te=fam54
echo $te

#only coveragebed analyzed
mkdir final_cov2
mv coveragebed_* final_cov2
cd final_cov2

#all TE insertion 
for file in *bed;do awk -F "\t" '{print $1"_"$2"_"$3}' $file;done | sort -u > all_insertion_$te.names
#umber of TE insertion
wc -l all_insertion_$te.names

#Retrieve insertion with minimum of coverage at 5
for file in coveragebed_*;do awk -F "\t" '{if ($4>=5){print $1"_"$2"_"$3}}' $file;done | sort -u  > all_position_cov5_$te.names
wc -l all_position_cov5_$te.names

#reformat output
for file in *bed;do n=$(echo $file | sed -e "s/coveragebed_//" | sed -e "s/\-vs-.*_per10kb.bed//"); awk -F "\t" '{print $1"_"$2"_"$3}' $file > $n.txt;done

#delete empty files
find ../final_cov2/ -size 0 -exec rm -f {} \;

#Create final matrice with R 
R CMD BATCH "--args $te" Analyse_pipeline.R

###Reformat the matrix
sed -e "s/\.txt//g" matrice_final.csv | sed -e "s/FALSE/0/g" | sed -e "s/TRUE/1/g" | sed -e "s/\-/\_/g" | sed -e "s/\./\_/g" | awk 'NR<2{print $0;next}{print $0| "sort -k1,1V"}'  > matrice_final_$te.csv


#script R traditionel + histo
R CMD BATCH "--args $te" /home/mchristine/Bureau/3000g/Analyse_tradi.R
