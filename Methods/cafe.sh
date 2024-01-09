#!/bin/bash -l

# name
#SBATCH --job-name=cafe

# cpu
#SBATCH --ntasks=6

#SBATCH --mem-per-cpu=2GB

#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

out_path=../Results/Cafe
mkdir $out_path
cd $out_path

ultrametric=$(python3 -c "
from ete3 import Tree
t = Tree('$(head ../Orthologous_Genes/Results_Nov22/Species_Tree/SpeciesTree_rooted.txt)')
t.convert_to_ultrametric()
print(t.write())
")

cafe5 -i ../Orthologous_Genes/Results*/Orthogroups/Orthogroups.tsv -t <(echo "$ultrametric")