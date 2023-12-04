methods_dir="$(pwd)"
cd "$methods_dir/../Material/Genomes/ncbi_dataset/data"

for dir in ./*/
do
    dir=${dir%*/}  # remove trailing slash
    genome_id=${dir##*/}
    species_name=$(head -1 $dir/$genome_id* | cut -f 2,3 -d " ")
    declare -i all_te=0
    declare -i coding_te=0

    echo "$species_name:"
    if [ -f "$methods_dir"/../Results/Detected_Transposons/$genome_id/*.final/*.EDTA.raw.fa ]; then
        all_te=$(grep -c "^>" "$methods_dir"/../Results/Detected_Transposons/$genome_id/*.final/*.EDTA.raw.fa)
        coding_te=$(grep -c "^>" "$methods_dir"/../Results/Detected_Transposons/$genome_id/*.final/*.intact.fa)
    else
        for all_file in "$methods_dir"/../Results/Detected_Transposons/$genome_id/*.raw/*.raw.fa
        do
            all_te+=$(grep -c "^>" "$all_file")
        done
        for coding_file in "$methods_dir"/../Results/Detected_Transposons/$genome_id/*.raw/*.intact.fa
        do
            coding_te+=$(grep -c "^>" "$coding_file")
        done
    fi
    echo "   detected transposable elements: $all_te"
    echo "   potential elements in prediction: $coding_te"
    echo
done