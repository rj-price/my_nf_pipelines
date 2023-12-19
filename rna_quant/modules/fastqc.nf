process FASTQC {
    tag "FastQC on $sample"

    container "biocontainers/fastqc:v0.11.9_cv8"
    publishDir "${params.results}/fastqc", mode: 'copy', overwrite: false
    cpus = 1
    memory = 1.GB
    queue = 'short'
    
    input:
    tuple val(sample), path(reads)


    output:
    tuple val(sample), path("*_fastqc.{zip,html}")

    script:
    """
    fastqc -q ${reads}
    """
}