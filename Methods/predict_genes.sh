#!/bin/bash -l

# name
#SBATCH --job-name=download_genome_data

# cpu
#SBATCH --ntasks=1

#SBATCH --mem-per-cpu=1MB

#SBATCH --output=%x_%j_slurm.out
#SBATCH --error=%x_%j_slurm.err

cd ../Material
mkdir Prediction

# match the species name with its best fitting trained species model in augustus
declare -A species=()
species["Saccharomyces cerevisiae"]="saccharomyces_cerevisiae_S288C"
species["Saccharomyces kluyveri"]="saccharomyces"  # nearest relative
species["Kluyveromyces lactis"]="kluyveromyces_lactis"
species["[Candida] glabrata"]="saccharomyces"  # nearest relative
species["Eremothecium gossypii"]="eremothecium_gossypii"
species["Lachancea thermotolerans"]="kluyveromyces_lactis"  # nearest relative

for dir in ./Genomes/ncbi_dataset/data/*/
do
    dir=${dir%*/}  # remove trailing slash
    genome_id=${dir##*/}
    species_name=$(head -1 $dir/$genome_id* | cut -f 2,3 -d " ")
    augustus --species='${species[$species_name]}' $dir/$genome_id* > "Prediction/${genome_id}_${species_name}.gff"
    /usr/share/augustus/scripts/getAnnoFasta.pl "Prediction/${genome_id}_${species_name}.gff"
done

# Finish the script
exit 0