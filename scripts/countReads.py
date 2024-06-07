import os
from Bio import SeqIO
from collections import Counter

import argparse

parser = argparse.ArgumentParser(description='Count the number of reads in a FASTA file')
parser.add_argument('--input_dir', '-i', required=True, help='The directory containing the FASTA files')
parser.add_argument('--output_dir','-o', required=True, help='The directory to write the results to')
args = parser.parse_args()


# Step 1: Read the FASTA file
input_dir = args.input_dir
output_dir = args.output_dir

for file in os.listdir(input_dir):
    if file.endswith(".fasta"):
        print('Counting reads for file:', file)
        input_fasta = os.path.join(input_dir, file)
        sequences = [str(record.seq) for record in SeqIO.parse(input_fasta, "fasta")]

        # # Step 2: Count sequences
        sequence_counts = Counter(sequences)

        # Step 3: Output the results
        out = file.split("_")[0]
        print(f'Writing results to: {out}')
        outfile = f"{output_dir}/{out}_counts.txt"
        print(outfile)
        with open(f"{output_dir}/{out}_counts.txt", "w") as output_file:
            output_file.write(f"Sequence\tCounts{out}\n")
            for sequence, count in sequence_counts.items():
                output_file.write(f"{sequence}\t{count}\n")