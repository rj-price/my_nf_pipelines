#!/usr/bin/nextflow

params.input = "*.fastq.gz"

process fastqc {
    //conda "bioconda::fastqc=0.12.1"
    container "biocontainers/fastqc:v0.11.9_cv8"
    cpus = 1
    memory = 1.GB
    queue = 'short'
    
    input:
    path input

    output:
    path "*_fastqc.{zip,html}"

    script:
    """
    fastqc -q $input
    """
}

workflow {
    Channel.fromPath("*.fastq.gz") | fastqc
    /*Channel.fromPath(params.input) | fastqc*/
}