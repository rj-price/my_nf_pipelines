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
nextflow run fastqc_hpc.nf -c myhpc.conf
```
**Successful!**