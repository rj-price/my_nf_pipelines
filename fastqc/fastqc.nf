#!/usr/bin/nextflow

/**
 * Raw fastq data quality control
 */

// Define input data
params.input = "*.fastq.gz"
params.outdir = "results" 

log.info """\
            F A S T Q C
===================================
Reads            : ${params.input}
Output Folder    : ${params.outdir}
"""

// Define FastQC process
process fastqc {
    //conda "bioconda::fastqc=0.12.1"
    container "biocontainers/fastqc:v0.11.9_cv8"
    cpus = 1
    memory = 1.GB
    queue = 'short'
    publishDir "${params.outdir}", mode: 'copy', overwrite: false
    
    input:
    path input

    output:
    path "*_fastqc.{zip,html}"

    script:
    """
    fastqc -q $input
    """
}

// Specify workflow with defined processes
workflow {
    reads_ch = Channel.fromPath(params.input, checkIfExists:true)
    fastqc(reads_ch)
}