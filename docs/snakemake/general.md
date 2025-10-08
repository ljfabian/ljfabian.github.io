# Snakemake
## Description
Snakemake is a workflow management system, based in Python language to aid its readability.

Workflow management systems allow you to break down complicated scripts which are largely intesive or take a long time on HPC systems into a collection of smaller jobs. There is _gating_ at each step of the pipeline, so if the first 3 of your 6 jobs runs, you don't need to start again at the beggining if the 4th job breaks, you just restart from the last successful job.

Snakemake can work with slurm scheduling, conda/mamba environments, automatically determine dependencies between rules and can easily be generalised to be useful in multiple situations, among many other features. 

Always refer to the current up to date documentation: https://snakemake.readthedocs.io/en/stable/
There is plenty of additional documentation online: https://carpentries-incubator.github.io/snakemake-novice-bioinformatics/ 

Much of this brief introduction is taken from the snakemake documentation. 

Citation: [Mölder et al. 2021](https://f1000research.com/articles/10-33/v3)

## Installation
Current and previous versions of Snakemake can be installed via Conda or Mamba, and is reccomended as this allows dependency handling. [Miniforge](https://github.com/conda-forge/miniforge) is reccomended.

Once you have installed miniforge or another conda based distribution system ([such as on BC4](../setup_miniforge/miniforge_setup.md)), you can generate a conda/mamba env called _smk_ using:
`mamba create -c conda-forge -c bioconda -n smk snakemake`

Once created and installed, you can activate with:
`mamba activate smk`

## Sections
1. [Snakefiles](Snakefiles.md)
2. Rules
3. Workflows