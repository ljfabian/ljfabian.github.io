# Snakefiles & basic rules
## Snakefiles
To create a workflow or pipeline within Snakemake, you need to have a central file to hold all of the rules, call the different jobs and link the entire pipeline together. This is called the *Snakefile*. 

## Simple rules and chaining them together
Each step within the Snakefile is called a *rule* and is defined as so in the file. 

Generally, a pipeline will run from activating your snakemake mamba env with 
`mamba activate smk`, then you will call either a specific rule from the script, or the _all_ rule within the snakemake file. 

The _all_ rule should just be something that defines what you

This would be done at the very basic level with:
`snakemake all`

This will look at a basic level like:

```python
rule all:
    input:
        'path/to/output/file'
```

Snakemake will look at the *input* of the _all_ rule, and look to see if the files already exist. If they do, it will report the files exist and there is no need to waste resources and run. Please note, if there are changes to the Snakefile between runs, even if there is the required *output* file, it will still re-run as the output is generated on an old workflow.  

If they don't exist, Snakemake will then look through all of the other rules in the Snakefile, trying to find where the *input* of the _all_ rule is in the *output* of another rule or rules. These are called target rules, and are used to define build targets.

The target rule needs to be explicit in what the required files are. It cannot use the wildcards across the file, so this is the main place you have to be explicit. 

These could look like:

```python
rule a:
    output:
        'path/to/output/file'
    shell:
        ' touch {output}'
```

When the *output* of rule _a_ is the desired file, rule a will be called as it produces the input of the _all_ rule in its output. In this case, it doesn't have any inputs, so the rule can just be called straight out. If there was an additional file required for _all_, then it would search other rules to see if the file was in their outputs and call them accordingly. 

```python
rule all:
    input:
        'path/to/output/file',
        'path/to/otheroutput/file2'


rule b:
    input:
        'raw/sample.csv'
    output:
        'path/to/otheroutput/file2
    shell:
        'head -n 100 {input} > {output}'
```

This would call both rule _a_ to get the original required input file, but also rule _b_. As _b_ also has an input file, snakemake will do the same thing as it did for all. It will check if the *input* exists already, and if not, search for another rule producing this file. This is how you can chain multiple rules together across an entire Snakefile. 

Rules inputs and outputs can actually be reffered to in other rules, making the chaining very explicit: `rules.b.output`

## Calling snakefiles
As mentioned above, you would use ``snakemake all` to call a snakemake workflow to run. You can add additional sections into the call to make it run under certain conditions. 

If you specify mamba/conda environments that need to be used, you would add:
- `--use-conda` or `-cdm`. 

If some of your rules are being ran via slurm, you would need to add these additional flags to the call:
- `--slurm` to tell it to use slurm for the jobs
- `--default-resources slurm_account=<your_account> slurm_partition=<your_partition>`

You can tell it how many jobs you plan to schedule, and how many cores to use:
- `-j X` to do X jobs
- `-c Y` to use Y cores
