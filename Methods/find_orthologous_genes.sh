#!/bin/bash -l

# name
#SBATCH --job-name=find_orthologous_genes

# cpu
#SBATCH --ntasks=40

#SBATCH --mem-per-cpu=1GB

#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

# takes one argument that is the path to 'orthofinder.py'
if [ $1 ] && [ -f $1 ]
then
    python3 $1 -p logs -f "../Results/Prediction" -o "../Results/Orthologous_Genes"
else
    echo USAGE: \"$0\" \"path/to/orthofinder.py\" >&2
fi

exit 0
