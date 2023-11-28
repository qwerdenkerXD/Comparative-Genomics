#!/bin/bash -l

# SEE:
# https://hpc-uit.readthedocs.io/en/latest/jobs/examples.html#general-blueprint-for-a-jobscript

##############################
#       Job blueprint        #
##############################

# Give your job a name, so you can recognize it in the queue overview
#SBATCH --job-name=download_genome_data

# You can further define the number of tasks with --ntasks-per-*
# See "man sbatch" for details. e.g. --ntasks=4 will ask for 4 cpus.
#SBATCH --ntasks=1

# How much memory you need.
# --mem will define memory per node and
# --mem-per-cpu will define memory per CPU/core. Choose one of those.
#SBATCH --mem-per-cpu=1MB
##SBATCH --mem=5GB    # this one is not in effect, due to the double hash

# Define custom output and error files:
# See
# https://unix.stackexchange.com/questions/285690/slurm-custom-standard-output-name
#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

# This is where the actual work is done. In this case, the script only waits.
# The time command is optional, but it may give you a hint on how long the
# command worked

curl -H "Accept: application/zip" -o     "../Material/S. cerevisiae.zip"       "https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_000146045.2/download?include_annotation_type=GENOME_FASTA,GENOME_GFF,RNA_FASTA,CDS_FASTA,PROT_FASTA,SEQUENCE_REPORT&filename=GCF_000146045.2.zip"
curl -H "Accept: application/zip" -o     "../Material/E. gossypii.zip"         "https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_000091025.4/download?include_annotation_type=GENOME_FASTA,GENOME_GFF,RNA_FASTA,CDS_FASTA,PROT_FASTA,SEQUENCE_REPORT&filename=GCF_000091025.4.zip"
curl -H "Accept: application/zip" -o     "../Material/K. lactis.zip"           "https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_000002515.2/download?include_annotation_type=GENOME_FASTA,GENOME_GFF,RNA_FASTA,CDS_FASTA,PROT_FASTA,SEQUENCE_REPORT&filename=GCF_000002515.2.zip"
curl -H "Accept: application/zip" -o     "../Material/N. glabratus.zip"        "https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_000002545.3/download?include_annotation_type=GENOME_FASTA,GENOME_GFF,RNA_FASTA,CDS_FASTA,PROT_FASTA,SEQUENCE_REPORT&filename=GCF_000002545.3.zip"
curl -H "Accept: application/zip" -o     "../Material/L. thermotolerans.zip"   "https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_000142805.1/download?include_annotation_type=GENOME_FASTA,GENOME_GFF,RNA_FASTA,CDS_FASTA,PROT_FASTA,SEQUENCE_REPORT&filename=GCF_000142805.1.zip"
curl -H "Accept: application/zip" -o     "../Material/L. kluyveri.zip"         "https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCA_000149225.2/download?include_annotation_type=GENOME_FASTA,GENOME_GFF,RNA_FASTA,CDS_FASTA,PROT_FASTA,SEQUENCE_REPORT&filename=GCA_000149225.2.zip"

cd ../Material
mkdir Genomes
unzip -o "*.zip" -d Genomes
rm *.zip

# Finish the script
exit 0