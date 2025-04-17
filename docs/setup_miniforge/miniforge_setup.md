# Miniforge3 setup on BC4
## Description
To use software which has not previously been installed on HPC systems, or custom versions, you can use distribution packages such as [miniforge3](https://github.com/conda-forge/miniforge), [uv](https://docs.astral.sh/uv/), [pixi.sh](https://pixi.sh/latest/) or [miniconda](https://www.anaconda.com/docs/getting-started/miniconda/main). These can all download packages which may be required for various workflows. 

These are _usually_ fairly lightweight (<1Gb) until you intiate and start using them to install numerous softwares and environments, at which point they can rapidly inflate in size.

Currently, you should take consideration for which channels you use can be used when it is a conda based system (miniconda, anaconda, miniforge3 using conda) as default conda channels are not free for commercial use (e.g. see https://stackoverflow.com/questions/74762863/are-conda-miniconda-and-anaconda-free-to-use-and-open-source).

Other channels, such as conda-forge (default used by miniforge3) and bioconda do not require commercial licenses to use currently, but this should be checked alongside your workplace policies before choosing channels to use. 

Pip can be used in place of the channels if you initiate a environment, allowing you to just use the default for accessing python packages. UV does much the same as pip for python packages, but can generate environments and handle dependencies and version control automatically on install and update. Mamba or conda are often better for installing a wider range of packages and tools which are not solely python or R packages. Pixi aims to do the same, using UV for python handling (or atleast plans to in the future).

## Installing miniforge3 on BC4/equivalent HPC system
These instructions are adapted from University of Bristol [ACRC documentation](https://www.acrc.bris.ac.uk/protected/hpc-docs/software/own_software.html)

If based at UoB, I would recommend following these instructions as they are likely updated more regularly. 

### Installing miniforge
Log into the HPC system on the command line:
```bash
ssh -X ab12345@bc4login.acrc.bris.ac.uk
```

Navigate to your working directory `/user/work/ab12345/` (as home directory `/user/home/ab12345/` only has 20Gb max space allowance).

Download the latest release of miniforge for the operating system. For BC4, this is:
```bash
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
```

This will install a `Miniforge3-Linux-x86_64.sh`, which you should alter the permissions to give yourself execute permissions.

Run the program, specifying  `-p $WORK` to install it to your working scratch rather than your home directory which will run out of space quickly.  
```bash
./Miniforge3-Linux-x86_64.sh -p $WORK/miniforge3
```

Once you have gone through the various policies, you will be offered the option of running `conda init` or equivalent. You can let this run so you will automatically be started in your base environment each time you log into the HPC system. This can be reversed using `conda init --reverse $SHELL`.

Alternatively, it is a good idea to take the modified section out of your `.bashrc` file and put it in a seperate file, which you can run to  manually initiate the environment instead. There can be conflicts with standard HPC modules. 

To do this, cut the newly added section from your `~/.bashrc` and paste it to i.e. a new file called `~/initMamba.sh`. This new file will appear similar to: 

```bash
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/user/work/${USER}/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/user/work/${USER}/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/user/work/${USER}/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/user/work/${USER}/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/user/work/${USER}/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/user/work/${USER}/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
```
`${USER}` will likely be replaced with your username instead. 

Either running `. ~/initMamba.sh` or adding an alias to your own `.bashrc` file (which should no longer have the section above) will allow you to activate this environment wherever you are in the HPC system. I have added a _mamba_ _initiate_ alias to mine, allowing `mi` to run this code. 

```bash
alias mi='. ~/initMamba.sh'
```

## Mamba vs conda
[Mamba](https://github.com/mamba-org/mamba) is generally an updated and faster alternative to conda. It does much of the same as conda, but using c++ instead to improve its efficiency. Generally it can function as a "drop in replacement" for conda.

[Mamba documentation](https://mamba.readthedocs.io/en/latest/user_guide/mamba.html)


## Environment handling
[Adaption continued from ACRC documentation](https://www.acrc.bris.ac.uk/protected/hpc-docs/software/conda_env.html)

Assuming you have installed mamba via miniforge as above, when you run `mi` or `. ~/initMamba.sh` you will be placed in your base environment. You should *never* install or work directly in this environment. This can just be used to generate new environments as you require. You can exit the base environment by restarting the terminal or `mamba deactivate`.

To create a enw enviroment from scratchyou can use the command:
```bash
mamba create --name myenv
```
Note that if using conda, you should add the flag `-p ${WORK}/miniforge3/envs` to save these here rather than your home directory.

You can list environments using: 
```bash
mamba env list
```

Activate an environment:
```bash
mamba activate myenv
```

Once inside an environment, you can use mamba to install packages as you require for the project.
```bash
mamba install python
```
or add -c to specify the channel you want to search.

The environment name will be displayed to the left of your command line, i.e. if in `base`: 
```(base) [pn22681@bc4login1(BlueCrystal4) ljfabian.github.io]$ ```

When finished, you can go back to base via: 
```bash
mamba deactivate
```

I generated a `standard` environment to install basic things such as R, python, numpy, pandas which I can use for basic tasks or for intial testing. From this, I often will clone this environment alter it away to install custom versions of python to, i.e. handle snakemake. 
```bash
mamba create --name CLONE_ENV_NAME --clone ENV_NAME
```

By not using the base environment, this also means I can easily delete broken environments or ones that are not needed anymore. 
```bash
mamba env remove -n myenv
```


If you are finished with an environment, or wish to share it with collaborators, you can generate a yaml file to show the requirements and installed versions for the environment:
```bash
mamba env export -n myenv > myenv.yaml
```

Someone else with mamba installed can create the environment themselves too, with the same versioning. 
```bash
mamba env create -f myenv.ymaml
```

## other Useful commands
[Abdullah Al Imran example cheatsheet](https://www.imranabdullah.com/2021-08-21/Conda-and-Mamba-Commands-for-Managing-Virtual-Environments)

update mamba:
```bash
mamba update -n base mamba
```

add channels: 
```bash
mamba config --add channels bioconda
```

check dependencies:
```bash
mamba repoquery depends -a mypackage
```

Remove a package:
```bash
mamba remove mypackage
```
