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
FASTQ=./data/rawFastq
OUTDIR1=./data/rawFasta
OUTDIR2=./data/ampFastav02
OUTDIR3=./data/trimFastav02
OUTDIR4=./resultsPY/v02GT

files=(
    'Lib2Ara1_R1_001' 'Lib2Ara2_R1_001' 'Lib2Ara3_R1_001'
    'Lib2Glu1_R1_001' 'Lib2Glu2_R1_001' 'Lib2Glu3_R1_001') 

for file in "${files[@]}";
do
    start_time=$(date +%s) # Start time in seconds
    echo "Processing sample $file"

    #echo "converting fastq to fasta"
    #seqkit fq2fa --threads 50 "${FASTQ}/${file}.fastq.gz" > "${OUTDIR1}/${file}.fasta"

    echo "Selecting Amplicon region"
    # this version I am excluding the C from the begning of the reads
    # 4 mismatches allowed, will represent 10% in the 40bp amplicon
    seqkit amplicon --threads 50 -m 4 -F GTTGCTGGTGGTATTGGTGCAG -R AGCTTGCATGCCTGCAGGTCGAC "${OUTDIR1}/${file}.fasta"  > "${OUTDIR2}/${file}_filtered.fasta"

    # # this will trim the adapter from the right side of the reads reads
    # # this outputed reads will not have N uncalled bases, for this will need --max-uncalled 2.
    # flexbar also has a mismatch option with ratio of 0.1 (10%)
    echo "Trimming custom sequence 3 off the reads"
    flexbar --threads 50 -ae 0.1 --reads "${OUTDIR2}/${file}_filtered.fasta" --adapters data/adapterRight.fasta --adapter-trim-end RIGHT --target "${OUTDIR3}/${file}_trimmed.fasta"

    end_time=$(date +%s) # End time in nanoseconds
    duration=$(( (end_time - start_time) / 60 )) # Duration in minutes
    echo "Duration: $duration minutes."
    echo " "

done


echo "Counting uniq reads"
time python3 scripts/countReads.py --input_dir $OUTDIR3 --output_dir $OUTDIR4


echo "*************************************** Process finished ********************************************"
