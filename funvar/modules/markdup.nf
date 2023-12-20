process MARKDUP {
    container "broadinstitute/gatk:4.3.0.0"
    cpus = 2
    memory = 4.GB
    queue = 'medium'

    input:
    tuple val(sample), path(bam) 

    output:
    tuple val("${sample}"), path("${sample}.markdup.bam"), emit: bam
    tuple val("${sample}"), path("${sample}.markdup.txt"), emit: log_file
    
    script:
    """
    gatk --java-options "-Xmx3000M -XX:ParallelGCThreads=2" \\
        MarkDuplicates -I ${bam} -O ${sample}.markdup.bam -M ${sample}.markdup.txt
    """
}
