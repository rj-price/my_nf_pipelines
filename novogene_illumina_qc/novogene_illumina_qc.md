# Novogene Illumina QC pipeline
Using a simple QC and trimming pipeline to understand data flow through multiple processes in NextFlow.

Use ```myhpc.conf``` and ```fastqc.nf``` as a base for pipeline development.

Edit ```myhpc.conf``` to contain additional information regarding maximum compute requests, maximum number of jobs running, and to clean up ```work``` directory following a successful run. Also copy to ```home``` directory as ```cropdiv.config```.

Move ```fastqc.nf``` to ```novogene_illumina_qc.nf``` and modify to include additional parameters to output results to a set directory.
```
params.results = "results" 

process fastqc {
    publishDir "${params.results}/fastqc", mode: 'copy', overwrite: false
}
```

Add MultiQC process to ```novogene_illumina_qc.nf```
```
process multiqc {
    container "ewels/multiqc:v1.18"
    publishDir "${params.results}/multiqc", mode: 'copy', overwrite: false
    cpus = 1
    memory = 1.GB
    queue = 'short'

    input:
    path fastqcOut

    output:
    path "*"

    script:
    """
    multiqc ${fastqcOut}
    """
}
```
And add process to workflow
```
workflow {
    reads_ch = Channel.fromPath(params.reads)
    fastqc(reads_ch)
    multiqc(fastqc.out.collect())
}
```
