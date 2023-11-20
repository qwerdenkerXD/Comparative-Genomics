cd ../Material/Genomes/ncbi_dataset/data

for dir in ./*/
do
    dir=${dir%*/}  # remove trailing slash
    genome_id=${dir##*/}
    species_name=$(head -1 $dir/$genome_id* | cut -f 2,3 -d " ")

    reference_prediction=0
    if [ -f $dir/protein.faa ]; then
        reference_prediction=$(grep -c "^>" $dir/protein.faa)
    fi

    my_prediction=0
    if [ -f "../../../Prediction/${genome_id}_${species_name}.aa" ]; then
        my_prediction=$(grep -c "^>" "../../../Prediction/${genome_id}_${species_name}.aa")
    fi

    echo $species_name:
    echo "   my prediction: $my_prediction"
    echo "   reference prediction: $reference_prediction"
    echo
done