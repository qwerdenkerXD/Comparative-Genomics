methods_dir="$(pwd)"
cd "$methods_dir/../Material/Genomes/ncbi_dataset/data"

for dir in ./*/
do
    dir=${dir%*/}  # remove trailing slash
    genome_id=${dir##*/}
    species_name=$(head -1 $dir/$genome_id* | cut -f 2,3 -d " ")

    echo "$species_name:"
    sed -n '/Results/,$p; /Dependencies/q' "$methods_dir/../Results/Busco/${genome_id}_${species_name}.aa"/short_summary.specific.saccharomycetes*.txt | head -n -2
    echo "

    "
done