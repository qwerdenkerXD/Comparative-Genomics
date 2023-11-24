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
    # download outgroup
    curl -H "Accept: application/zip" -o     "../Material/Ecoli.zip"       "https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCA_000005845.2/download?include_annotation_type=PROT_FASTA&filename=GCA_000005845.2.zip"
    mkdir ../Material/Outgroup
    unzip -o ../Material/Ecoli.zip -d ../Material/Outgroup


    tmp=../Results/tmp
    mkdir $tmp
    cp ../Prediction/* $tmp
    cp ../Material/Outgroup/ncbi_dataset/data/GCA_000005845.2/protein.faa $tmp/GCA_000005845.2_E.coli.faa
    python3 $1 -p logs -f ../Results/tmp -o ../Results/Orthologous_Genes_With_Outgroup
    rm -r $tmp
else
    echo USAGE: $0 path/to/orthofinder.py >&2
fi

exit 0