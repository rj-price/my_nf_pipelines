#!/usr/bin/nextflow

/*params.input = "*.fastq.gz"*/

process fastqc {
    conda "bioconda::fastqc=0.12.1"

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