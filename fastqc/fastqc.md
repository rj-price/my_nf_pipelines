# FastQC pipeline
Following session 1 of the NextFlow [Basic Nextflow Training Workshop](https://training.nextflow.io/basic_training/), write a simple pipeline to perform FastQC analysis of sequencing reads using a custom config.

## Using Conda
Copy pipeline from training session 1 video into ```fastqc.nf```. \
Copy conda config to ```mylocal.conf```.
```
conda {
    enabled = true
}
```

Run in an interactive session:
```
nextflow run fastqc.nf -c mylocal.conf
```
**Successful!**

---

To run using the Slurm job scheduler, add the following to ```myhpc.conf```.
```
process {
    executor = 'slurm'
}

conda {
    enabled = true
}
```

Run in an interactive session:
```
nextflow run fastqc.nf -c myhpc.conf
```
**Successful!**

---

To specify the compute parameters for the FastQC process, add the following to ```myhpc.conf```.
```
process {
    withName: 'fastqc' {
        cpus = 2
        memory = 1.GB
        queue = 'short'
    }
}
```

## Using Apptainer
Using containers is considered better NextFlow practice than using conda.

To use Apptainer, add the following to ```myhpc.conf```...
```
apptainer {
    enabled = true
    autoMounts = true
    cacheDir = '/mnt/shared/scratch/jnprice/apps/singularity_cache'
}
```
...and the following, within the fastqc process, to ```fastqc_hpc_appt.nf```
```
container "biocontainers/fastqc:v0.11.9_cv8"
```

Also move the process specific compute information from ```myhpc.conf``` into ```fastqc.nf```

Run in an interactive session:
```
nextflow run fastqc.nf -c myhpc.conf
```

**Successful!**