#!/bin/bash -l

# name
#SBATCH --job-name=analyze_syntheny_dagchainer

# cpu
#SBATCH --ntasks=80

#SBATCH --mem-per-cpu=1GB

#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

out_path=../Results/Syntheny_DAGchainer
mkdir $out_path
cd $out_path

for file in ../Prediction/*.faa
do
    combined+="$(sed "s/^>/>$(basename "${file%.*}")./; s/ /_/g" "$file")
"
done
query="combined.faa"
echo "$combined" > "$query"

diamond makedb --db "$query"

blast_result="all_vs_all.match_file"

diamond blastp --threads 80 --query "$query" --db "$query" --out "$blast_result" --outfmt 6 qseqid qtitle qstart qend sseqid stitle sstart send evalue

dagchainer=../../Methods/dagchainer
dagchainer_in="${blast_result}.filtered"


# see https://dagchainer.sourceforge.net/
perl "$dagchainer/accessory_scripts/filter_repetitive_matches.pl" 5 < "$blast_result" > "$dagchainer_in"

perl "$dagchainer/run_DAG_chainer.pl" -i "$dagchainer_in" -Z 12 -D 10 -g 1 -A 5

DISPLAY=:0.0 perl "$dagchainer/Java_XY_plotter/run_XYplot.pl" "$dagchainer_in" "${dagchainer_in}.aligncoords"