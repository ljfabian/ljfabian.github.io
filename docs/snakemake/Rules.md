# Rules
## Description
Each step within the [Snakefile](Snakefiles.md) is called a *rule* and is defined as so in the file. 

## Basic rule sections

Rules need to have either an *input* or an *output* to be useful. All non-target rules will do something to the input, to generate the output. These both need to be defined in the rule. They can be reffered to in the *shell* or *script* or *run* sections of the rule using curly braces. 

```python
rule x:
    input:
        'foo'
    output:
        'bar'
    shell:
        'somecommand {input} {output}'
```
 
 These inputs and outputs can consist of a single file, or many. You can put them as a python list, or as with a Snakemake expand statement. 

 ```python
 rule x:
    input:
        files = ['input/file1', 'input/file2', 'input/file3']
    output:
    run:
        for i in input.files:
            shell(f'somecommand {i}')
```
As shown in this example, the inputs can be named, then reffered to as _input.files_ as above. 

Within the rule, you can use *run* with some python syntax to iterate or work with the files and data you have. You also don't have to explicitly state the output in the rule, it will just check for the files upon completion. While it is often better to be explicit, this could be difficult if you are using a specific bioinformatic package which could not define outputs in the commandline.  

These can be hard strings as above, or they can consist of wildcards, allowing snakemake to fill in the rest. This allows it to 

## Parameters
Rules can also include parameters, which are not files, but variables that you may want to change between runs. Think flag values for software, such as changing the LD window sizes for testing or info & maf filtering levels in a job. 

These can again be reffered to in the rule and there can be multiple. 

```python
rule y:
    input:
        'foo.txt'
    output:
        'bar.txt'
    params:
        n_lines = '1000'
    shell:
        'head -n {params.n_lines} {input} > {output}'
```

Like inputs and outputs, these parameters can be referred to in the other rules:
`rules.y.params.n_lines`


## Slurm usage
If you are running the pipeline somewhere that requires a scheduling system, such as slurm, you will need to define resources for the rule to use. This will generally function as each time a rule is ran, it will be its own slurm job. 

You generally will define the resource as required by the script following the requirements of the system. For example, a job using qctools called via a shell script `01_remove_samples.sh`, which is fed command line arguements for the various parts of the code. 

```python
rule xyz:
    input:
        bgen = f'{config["release_path_bgen"]}/chr{{chrom}}_dosage.bgen',
        sample = f'{config["release_path_bgen"]}/chr22_dosage.sample'
    output:
        bgen = f'{config["temp_path"]}/chr{{chrom}}_removed.bgen',  
        sample = f'{config["temp_path"]}/chr{{chrom}}_removed.sample'     
    params:
        removal_list = config['rmv']
    resources:
        cores=4,
        mem_mb=35000,
        ntasks=1,
        hours=15,
        account=config['slurm_account'],
        partition=config['slurm_partition'],
        cpu=1   
    log: f'logs/01_removed/{{chrom}}.log'
    shell: '''
    sh 01_remove_samples.sh \
        {input.bgen} \
        {input.sample} \
        {params.removal_list} \
        {output.bgen} \
        {output.sample} \
        > {log}
    '''
```

## Wildcards

