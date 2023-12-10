#!/bin/bash -l

# name
#SBATCH --job-name=hmmpress

# cpu
#SBATCH --ntasks=1

#SBATCH --mem-per-cpu=50GB

#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

hmmpress ../Material/HMMER/Pfam-A.hmm
