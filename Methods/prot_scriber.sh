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

all_descriptions="$out_path/all_descriptions.tsv"

for file in ../Results/Prediction/*.faa
do
    filebase="$(basename "${file%.*}")"

    blast_out="$out_path/${filebase}.blast.tsv"
    diamond blastp --threads 10 --db /media/BioNAS/UniProtKB/202312/uniprot_trembl.fasta --query "$file" --out "$blast_out" --outfmt 6 qseqid sseqid stitle

    seq_families="$out_path/${filebase}.seqfamilies.tsv"
    gene_families=../Results/Orthologous_Genes/Results*/Orthogroups/Orthogroups.tsv
    declare -i species_col=1
    species_col+=$(head -1 $gene_families | sed "s/${filebase}.*//" | grep -cP "\t")

    cut -d $'\t' -f 1,$species_col $gene_families | sed -e "s/ //g" -e "/\t$/d" | tail -n +2 > "$seq_families"

    prot_out="$out_path/${filebase}.protscriber.tsv"
    prot-scriber -n 10 -f "$seq_families" -s "$blast_out" -o "$prot_out"
done