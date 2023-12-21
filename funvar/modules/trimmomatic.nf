process TRIMMOMATIC {
    tag "Trimmomatic on $sample"

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
    tuple val("${sample}"), path("${sample}_trim.log"), emit: log_file
    
    script:
    """
    trimmomatic PE \\
        -threads 8 -phred33 \\
        ${reads[0]} ${reads[1]} \\
        ${sample}_R1.trimmed.fastq.gz ${sample}_R1.unpaired.fastq.gz \\
        ${sample}_R2.trimmed.fastq.gz ${sample}_R2.unpaired.fastq.gz \\
        ILLUMINACLIP:TruSeq3-PE:2:30:10 LEADING:3 TRAILING:3 \\
        ${params.slidingwindow} ${params.minlength} ${params.headcrop} \\
        2> ${sample}_trim.log
    """
}