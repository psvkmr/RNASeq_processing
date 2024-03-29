#!/bin/bash -l

#SBATCH --partition=brc
#SBATCH --time=00:30:00
#SBATCH --mem=6G
#SBATCH --job-name=r_pipeline
#SBATCH --verbose
#SBATCH --output=/scratch/users/k2142172/tests/rp_counts_qc.out

# added -l to bash interpret to use login mode so conda env can be used

# import config variables
. ./$config

# create output dir if necessary, and redirect log and err files there
exec >${out_dir}/gene_expression/${project}_rp_counts_qc.out 2>${out_dir}/gene_expression/${project}_rp_counts_qc.out

# conda env path
env=/scratch/users/k2142172/packages/anaconda3/envs/r4

# path to Rscript
rscript=/scratch/users/k2142172/packages/anaconda3/envs/r4/bin/Rscript

# rp_normalise_counts.Rmd
markdown_file=/scratch/users/k2142172/scripts/pipeline/rp_normalise_counts.Rmd

# gene_counts.tab
counts_matrix=${out_dir}/gene_expression/STAR/${project}_gene_counts.tab

# TRUE/FALSE - default FALSE
drop_samples=${drop_samples}

# 'sample1 sample2 sample3' - default ''
dropped_samples=${dropped_samples}

# output html
output_file=${out_dir}/gene_expression/${project}_counts_qc.html


conda activate $env

$rscript -e "rmarkdown::render('$markdown_file', \
    output_file='$output_file', \
    params=list(counts_matrix='$counts_matrix', \
        project='${project}', \
        out_dir='${out_dir}', \
        drop_samples='$drop_samples',\
        dropped_samples='$dropped_samples'))"


