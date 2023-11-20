#!/bin/bash -l

# name
#SBATCH --job-name=detect_transposables

# cpu
#SBATCH --ntasks=10

#SBATCH --mem-per-cpu=1GB

#SBATCH --output=%x_%j_slurm.out
#SBATCH --error=%x_%j_slurm.err

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

mkdir ../Material/Detected_Transposons
for dir in ../Material/Genomes/ncbi_dataset/data/*/
do
    dir=${dir%*/}  # remove trailing slash
    genome_id=${dir##*/}
    species_name=$(head -1 $dir/$genome_id* | cut -f 2,3 -d " ")
    
    out_dir="../Material/Detected_Transposons/$genome_id"
    mkdir "$out_dir"
    cp "$dir/$genome_id*" $out_dir
    perl /opt/edta/EDTA/EDTA.pl --genome "$out_dir/$genome_id*"
done

exit 0