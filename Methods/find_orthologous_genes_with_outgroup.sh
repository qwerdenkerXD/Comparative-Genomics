#!/bin/bash -l

# name
#SBATCH --job-name=find_orthologous_genes_with_outgroups

# cpu
#SBATCH --ntasks=40

#SBATCH --mem-per-cpu=1GB

#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

# takes one argument that is the path to 'orthofinder.py'
if [ $1 ] && [ -f $1 ]
then
    # download outgroup
    curl -H "Accept: application/zip" -o     "../Material/S.osmophilus.zip"       "https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_027921745.1/download?include_annotation_type=PROT_FASTA&filename=GCF_027921745.1.zip"
    mkdir "../Material/Outgroup"
    unzip -o "../Material/S.osmophilus.zip" -d "../Material/Outgroup"
    rm "../Material/S.osmophilus.zip"

    tmp="../Results/tmp"
    mkdir "$tmp"
    cp ../Results/Prediction/* "$tmp"
    cp "../Material/Outgroup/ncbi_dataset/data/GCF_027921745.1/protein.faa" "$tmp/GCF_027921745.1_Schizosaccharomyces osmophilus.faa"
    python3 $1 -p logs -f "../Results/tmp" -o "../Results/Orthologous_Genes_With_Outgroup"
    rm -r "$tmp"
else
    echo USAGE: \"$0\" \"path/to/orthofinder.py\" >&2
fi

exit 0