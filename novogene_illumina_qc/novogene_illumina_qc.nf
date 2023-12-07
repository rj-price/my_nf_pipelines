#!/usr/bin/nextflow

params.reads = "data/*.fastq.gz"
params.results = "results" 

process fastqc {
    //conda "bioconda::fastqc=0.12.1"
    container "biocontainers/fastqc:v0.11.9_cv8"
    publishDir "${params.results}/fastqc", mode: 'copy', overwrite: false
    cpus = 1
    memory = 1.GB
    queue = 'short'
    
    input:
    path reads

    output:
    path "*_fastqc.{zip,html}"

    script:
    """
    fastqc -q ${reads}
    """
}

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

workflow {
    reads_ch = Channel.fromPath(params.reads)
    fastqc(reads_ch)
    multiqc(fastqc.out.collect())
}