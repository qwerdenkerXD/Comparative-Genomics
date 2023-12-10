#!/bin/bash -l

# name
#SBATCH --job-name=prot_scriber

# cpu
#SBATCH --ntasks=10

#SBATCH --mem-per-cpu=10GB

#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

out_path=../Results/Protscriber
mkdir $out_path

for file in ../Results/Prediction/*.faa
do
    blast_out="$out_path/$(basename ${file%.*}).blast.tsv"
    diamond blastp --threads 10 --db /media/BioNAS/UniProtKB/202312/uniprot_trembl.fasta --query "$file" --out "$blast_out" --outfmt 6 qseqid sseqid stitle

    prot_out="$out_path/$(basename ${file%.*}).protscriber.tsv"
    prot-scriber -n 10 -o "$prot_out"
done