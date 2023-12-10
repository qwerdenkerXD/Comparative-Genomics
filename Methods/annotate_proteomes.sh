#!/bin/bash -l

# name
#SBATCH --job-name=annotate_proteomes

# cpu
#SBATCH --ntasks=10

#SBATCH --mem-per-cpu=10GB

#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

out_path=../Results/Annotated_Proteomes
mkdir $out_path

for file in ../Results/Prediction/*.faa
do
    hmmscan --cpu 10 -o "$out_path/$(basename "${file%.*}").txt" --tblout "$out_path/$(basename "${file%.*}").tsv" "../Material/HMMER/Pfam-A.hmm" "$file"
done