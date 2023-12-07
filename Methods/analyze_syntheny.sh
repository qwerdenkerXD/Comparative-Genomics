#!/bin/bash -l

# name
#SBATCH --job-name=analyze_syntheny

# cpu
#SBATCH --ntasks=10

#SBATCH --mem-per-cpu=10GB

#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

out_path=../Results/Syntheny
mkdir $out_path

plot="plotsr --cfg plotsr.cfg -H 5 -W 5 -o ../Results/syntheny.png --genomes $out_path/genomes.txt"

echo "" > $out_path/genomes.txt

out_path_proc=$out_path/preprocessed_genomes
mkdir $out_path_proc
function preprocess_files() {

    # normalize chromosome identifiers
    processed_1="$(awk "/^>/ {++i; print \">chr\" i; next} 1" $1)"
    processed_2="$(awk "/^>/ {++i; print \">chr\" i; next} 1" $2)"

    #TODO remove mitochondrium chromosomes... -> all sequences with another header than >chr[A-Z]+

    outfile_1="$out_path_proc/$(basename $1).processed"
    outfile_2="$out_path_proc/$(basename $2).processed"
    echo "$processed_1" > "$outfile_1"
    echo "$processed_2" > "$outfile_2"

    # first alignment to identify homologue chromosomes
    aligned="$(minimap2 -t 10 -ax asm5 --eqx $outfile_1 $outfile_2)"
    homologues=($(echo "$aligned" | cut -f 1,3 | grep -P "^chr[1-9].*chr[1-9]" | uniq))

    # give homologues same identifier
    for (( i = 0; i < ${#homologues[@]}; i+=2 )); do
        sed -i "s/${homologues[i]}/chr_${i}/" $outfile_2
        sed -i "s/${homologues[i+1]}/chr_${i}/" $outfile_1
    done

    # return filenames
    files=("$outfile_1" "$outfile_2")
    echo "${files[@]}"
}


species_1=0

for dir in ../Material/Genomes/ncbi_dataset/data/*/
do
    dir=${dir%*/}  # remove trailing slash
    genome_id=${dir##*/}
    species_2=$(head -1 $dir/$genome_id* | cut -f 2,3 -d " ")
    species_2_file=$dir/$genome_id*

    if [[ $species_1 = 0 ]]
    then
        species_1=$species_2
        species_1_file=$species_2_file
        continue
    fi

    # preprocess the genomes
    processed=($(preprocess_files "$species_1_file" "$species_2_file"))

    # use SyRi -> create alignment and analyze afterwards
    alignment="$out_path/${species_1}_vs_${species_2}.sam"
    minimap2 -t 10 -ax asm5 --eqx "${processed[0]}" "${processed[1]}" > "$alignment"
    mkdir "$out_path/tmp"
    syri -c "$alignment" -r "${processed[0]}" -q "${processed[1]}" --dir "$out_path/tmp" -F S

    # if everything is fine, SyRi gives the 'syri.out' as result, needed for plotting
    if [ -f "$out_path/tmp/syri.out" ]; then

        # modify genomes file for plotsr
        # therefore, remove previous entry (beacause species_1 and species_2 are alternating)
        # and add the current two species
        echo "$(head -n -1 "$out_path/genomes.txt")" > "$out_path/genomes.txt"
        echo "${processed[0]}	$species_1
${processed[1]}	$species_2" >> $out_path/genomes.txt
        mv "$out_path/tmp/syri.out" "${alignment%.*}.out"

        # add SyRi result to plotsr args
        plot+=" --sr \"${alignment%.*}.out\""
    fi

    rm -r "$out_path/tmp"

    species_1=$species_2
    species_1_file=$species_2_file
done

# just for reproducibility
echo "
$plot"

eval $plot

mv plotsr.log logs

exit 0
