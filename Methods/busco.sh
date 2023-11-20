#!/bin/bash -l

# name
#SBATCH --job-name=busco

# cpu
#SBATCH --ntasks=80

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
conda activate busco

# make sure EDTA env is correctly set and working:
conda info


mkdir ../Material/Busco
for file in ../Material/Prediction/*.aa
do
    busco -m proteins -i "$file" -o ../Material/Busco
done

exit 0
