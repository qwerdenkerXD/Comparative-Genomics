root=$(dirname "$0")
cd $root/../Material/Genomes/ncbi_dataset/data

for dir in $root/*/
do
    dir=${dir%*/}  # remove trailing slash
    genome_id=${dir##*/}
    species_name=$(head -1 $dir/$genome_id* | cut -f 2,3 -d " ")

    reference_prediction=0
    if [ -f $dir/protein.faa ]; then
        reference_prediction=$(grep -c "^>" $dir/protein.faa)
    fi

    my_prediction=0
    if [ -f "$root/../Results/Prediction/${genome_id}_${species_name}.faa" ]; then
        my_prediction=$(grep -c "^>" "$root/../Results/Prediction/${genome_id}_${species_name}.faa")
    fi

    echo $species_name:
    echo "   my prediction: $my_prediction"
    echo "   reference prediction: $reference_prediction"
    echo
done
