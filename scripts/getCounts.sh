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
OUTDIR2=./data/trimLeftFasta
OUTDIR3=./data/trimRightFasta

files=(
    'Lib2Ara1_R1_001' 'Lib2Ara2_R1_001' 'Lib2Ara3_R1_001'
    'Lib2Glu1_R1_001' 'Lib2Glu2_R1_001' 'Lib2Glu3_R1_001') 

for file in "${files[@]}";
do
    start_time=$(date +%s) # Start time in seconds
    echo "Processing sample $file"

    #echo "converting fastq to fasta"
    #seqkit fq2fa --threads 50 "${FASTQ}/${file}.fastq.gz" > "${OUTDIR1}/${file}.fasta"

    #echo "Filtering fastq with the Amplicon region"
    #seqkit amplicon --threads 50 -m 3 -F CGTTGCTGGTGGTATTGGTGCAG -R AGCTTGCATGCCTGCAGGTCGAC "${OUTDIR1}/${file}.fasta"  > "${OUTDIR2}/${file}_filtered.fasta"

    # this will trim the adapter from the right side of the reads reads
    # this outputed reads will not have N uncalled bases
    #flexbar --reads test.fasta --target test_trimmed --adapters adapter.fasta --adapter-trim-end RIGHT --min-read-length 18 --max-uncalled 2
    echo "Trimming custom seq from the right side of the reads"
    flexbar --threads 50 --reads "${OUTDIR1}/${file}.fasta" --adapters data/adapterLeft.fasta --adapter-trim-end LEFT --target "${OUTDIR2}/${file}_trimmed_left"
    flexbar --threads 50 --reads "${OUTDIR2}/${file}_trimmed_left.fasta" --adapters data/adapterRight.fasta --adapter-trim-end RIGHT --target "${OUTDIR3}/${file}_trimmed.fasta"

    # could fix the multi line fasta created by flexbar, but in this case I us
    awk '/^>/{if (seq) print seq; print; seq=""; next} {seq = seq $0} END{if (seq) print seq}' "${OUTDIR3}/${file}_trimmed.fasta" > "${OUTDIR4}/${file}_trimmed.fasta"

    cat "${OUTDIR4}/${file}_trimmed.fasta" | sort | uniq -cd > Glu1_R1_uniq_customseq5.txt



    end_time=$(date +%s) # End time in seconds
    duration=$(( (end_time - start_time) / 60 )) # Duration in minutes
    echo "Duration: $duration minutes."
    echo " "

done

echo "*************************************** Process finished ********************************************"
