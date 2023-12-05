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

plot="plotsr -o $out_path/syntheny.png --genomes $out_path/genomes.txt"

species_1=0

# create the alignments
for dir in ../Material/Genomes/ncbi_dataset/data/*/
do
    dir=${dir%*/}  # remove trailing slash
    genome_id=${dir##*/}
    species_2=$(head -1 $dir/$genome_id* | cut -f 2,3 -d " ")
    species_2_file=$dir/$genome_id*

    echo "$species_2_file\t$species_2" >> $out_path/genomes.txt

    if [[ $species_1 = 0 ]]
    then
        species_1=$species_2
        species_1_file=$species_2_file
        continue
    fi

    alignment="$out_path/${species_1}_vs_${species_2}.sam"
    minimap2 -t 10 -ax asm20 --eqx $species_1_file $species_2_file > "$alignment"
    syri -c "$alignment" -r $species_1_file -q $species_2_file --dir "$out_path" -F S

    plot+=" --sr \"$alignment\""

    species_1=$species_2
    species_1_file=$species_2_file
done
eval $plot

exit 0
