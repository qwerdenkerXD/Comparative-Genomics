#!/bin/bash -l

# name
#SBATCH --job-name=find_orthologous_genes_with_outgroups

# cpu
#SBATCH --ntasks=40

#SBATCH --mem-per-cpu=1GB

#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

methods_dir="$(dirname "$0")"

# takes one argument that is the path to 'orthofinder.py'
if [ $1 ] && [ -f $1 ]
then
    # download outgroup
    curl -H "Accept: application/zip" -o     "$methods_dir/../Material/Ecoli.zip"       "https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_027921745.1/download?include_annotation_type=PROT_FASTA&filename=GCF_027921745.1.zip"
    mkdir "$methods_dir/../Material/Outgroup"
    unzip -o "$methods_dir/../Material/Ecoli.zip" -d "$methods_dir/../Material/Outgroup"
    rm "$methods_dir/../Material/Ecoli.zip"

    tmp="$methods_dir/../Results/tmp"
    mkdir $tmp
    cp "$methods_dir/../Results/Prediction/*" $tmp
    cp "$methods_dir/../Material/Outgroup/ncbi_dataset/data/GCF_027921745.1/protein.faa" "$tmp/GCF_027921745.1_Schizosaccharomyces osmophilus.faa"
    python3 $1 -p logs -f "$methods_dir/../Results/tmp" -o "$methods_dir/../Results/Orthologous_Genes_With_Outgroup"
    rm -r $tmp
else
    echo USAGE: \"$0\" \"path/to/orthofinder.py\" >&2
fi

exit 0