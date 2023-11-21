#!/bin/bash -l

# name
#SBATCH --job-name=detect_transposables

# cpu
#SBATCH --ntasks=10

#SBATCH --mem-per-cpu=1GB

#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# activate EDTA conda environment:
conda activate EDTA

methods_dir="$(pwd)"
mkdir ../Results/Detected_Transposons
for dir in ../Material/Genomes/ncbi_dataset/data/*/
do
    dir=${dir%*/}  # remove trailing slash
    genome_id=${dir##*/}
    species_name=$(head -1 $dir/$genome_id* | cut -f 2,3 -d " ")
    
    out_dir="../Results/Detected_Transposons/$genome_id"
    mkdir "$out_dir"
    file=($dir/$genome_id*)
    cp "${file[0]}" $out_dir
    cd $out_dir
    perl /opt/edta/EDTA/EDTA.pl --genome "./${file[0]##*/}"
    cd $methods_dir
done

exit 0