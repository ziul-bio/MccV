#!/usr/bin/bash

#Exit program if any erro accurs
set -o errexit

echo "************************************************************************************************"
echo "                          Deep mutational scanning - Part 1 - Count reads"
echo "************************************************************************************************"
echo " "
echo " "

echo "*************************************** Starting Process ***************************************"
echo " "

INPUT=./data/trimFasta
OUTDIR=./data/clustered

files=(
    'Lib2Ara1_R1_001' 'Lib2Ara2_R1_001' 'Lib2Ara3_R1_001'
    'Lib2Glu1_R1_001' 'Lib2Glu2_R1_001' 'Lib2Glu3_R1_001') 

for file in "${files[@]}";
do
    start_time=$(date +%s) # Start time in seconds
    echo "Processing sample $file"
    # -aL 1.0 -aS 1.0 -s 1.0 -S 0 -uL 0.0 -uS 0.0 -U 0 these option will ensure my aligned cluester have all seq with the same size
    # -aL 1.0 and -aS 1.0: This means the alignment must cover 100% of both the longer and the shorter sequence, effectively ensuring full-length matching.
    #-s 1.0: This ensures that sequences must be 100% the length of the representative sequence in a cluster, meaning no length variation is allowed.
    #-S 0: This will not allow any absolute difference in length in terms of bases or amino acids.
    cd-hit -i "${INPUT}/${file}_trimmed.fasta" -o "${OUTDIR2}/${file}_clustered" -c 0.99 -n 5  -G 0 -M 0 -T 50 -sc 1 -aL 1.0 -aS 1.0 -s 1.0 -S 0 -uL 0.0 -uS 0.0 -U 0

    
    end_time=$(date +%s) # End time in seconds
    duration=$(( (end_time - start_time) / 60 ))
    echo "Duration: $duration min."
    echo " "

done

echo "*************************************** Process finished ********************************************"
