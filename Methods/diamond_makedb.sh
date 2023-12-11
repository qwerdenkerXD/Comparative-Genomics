#!/bin/bash -l

# name
#SBATCH --job-name=diamond_makedb

# cpu
#SBATCH --ntasks=1

#SBATCH --mem-per-cpu=50GB

#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

diamond makedb ../Material/Diamond/uniprot_trembl.fasta
