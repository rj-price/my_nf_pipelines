#!/usr/bin/nextflow

params.reads = "data/*R{1,2}.fastq.gz"
params.results = "results" 

process pre_fastqc {
    container "biocontainers/fastqc:v0.11.9_cv8"
    publishDir "${params.results}/pre_fastqc", mode: 'copy', overwrite: false
    cpus = 1
    memory = 1.GB
    queue = 'short'
    
    input:
    tuple val(sample), path(reads)


    output:
    path "*_fastqc.{zip,html}"

    script:
    """
    fastqc -q ${reads}
    """
}

process pre_multiqc {
    container "ewels/multiqc:v1.18"
    publishDir "${params.results}/pre_multiqc", mode: 'copy', overwrite: false
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

process trimmomatic {
    container "quay.io/biocontainers/trimmomatic:0.39--hdfd78af_2"
    publishDir "${params.results}/trimmed", mode: 'copy', overwrite: false
    cpus = 4
    memory = 1.GB
    queue = 'medium'

    input:
    tuple val(sample), path(reads) 

    output:
    tuple val("${sample}"), path("${sample}*.trimmed.fastq.gz"), emit: trim_fq
    tuple val("${sample}"), path("${sample}*.unpaired.fastq.gz"), emit: unpaired_fq
    
    script:
    """
    trimmomatic PE \\
        -threads 8 -phred33 \\
        ${reads[0]} ${reads[1]} \\
        ${sample}_R1.trimmed.fastq.gz ${sample}_R1.unpaired.fastq.gz \\
        ${sample}_R2.trimmed.fastq.gz ${sample}_R2.unpaired.fastq.gz \\
        ILLUMINACLIP:TruSeq3-PE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 HEADCROP:10 MINLEN:80
    """
}

process post_fastqc {
    container "biocontainers/fastqc:v0.11.9_cv8"
    publishDir "${params.results}/post_fastqc", mode: 'copy', overwrite: false
    cpus = 1
    memory = 1.GB
    queue = 'short'
    
    input:
    tuple val(sample), path(trimReads)
    //tuple val(sample), path(unpairedReads)

    output:
    path "*_fastqc.{zip,html}"

    script:
    """
    fastqc -q ${trimReads}
    """
}

process post_multiqc {
    container "ewels/multiqc:v1.18"
    publishDir "${params.results}/post_multiqc", mode: 'copy', overwrite: false
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
    reads_ch = Channel.fromFilePairs(params.reads)
    pre_fastqc(reads_ch)
    pre_multiqc(pre_fastqc.out.collect())
    trimmomatic(reads_ch)
    post_fastqc(trimmomatic.out.trim_fq)
    post_multiqc(post_fastqc.out.collect())
}