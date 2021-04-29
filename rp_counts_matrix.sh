#!/bin/bash

#SBATCH --partition=brc
#SBATCH --time=24:00:00
#SBATCH --mem=16G
#SBATCH --ntasks=8
#SBATCH --nodes=1
#SBATCH --job-name=rp_counts_matrix
#SBATCH --output=/scratch/users/k2142172/tests/rp_counts_matrix.out
#SBATCH --verbose

# script exits if return value of a command is not zero
set -e
# prints lines of script as they are run
set -v
# prevents overwriting of existing files through redirection
set -o noclobber

# import config variables
. ./$config

# create output dir if necessary, and redirect log and err files there
mkdir -p ${out_dir}/gene_expression2

exec >${out_dir}/gene_expression2/rp_counts_matrix.out 2>${out_dir}/gene_expression2/rp_counts_matrix.err

# path to tools
featurecounts=/scratch/users/k2142172/packages/subread-2.0.1-Linux-x86_64/bin/featureCounts

# variable with list of bams
bams=$(ls ${out_dir}/processed_bams/*.bam)

# run featurecounts over all bams to give one gene counts matrix
$featurecounts \
  -a ${resources_dir}/${build}/Homo_sapiens.GRCh38.103.gtf \
  -F GTF \
  -g gene_id \
  -p \
  -s 2 \
  -T 8 \
  --verbose \
  -o ${out_dir}/gene_expression2/${project}_gene_counts.tab \
  $bams