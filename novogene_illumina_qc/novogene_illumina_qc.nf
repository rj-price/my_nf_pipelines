#!/usr/bin/nextflow

params.reads = "data/*.fastq.gz"
params.results = "results" 

process fastqc {
    //conda "bioconda::fastqc=0.12.1"
    container "biocontainers/fastqc:v0.11.9_cv8"
    publishDir "${params.results}/fastqc"
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

workflow {
    reads_ch = Channel.fromPath(params.reads)
    fastqc(reads_ch)
}