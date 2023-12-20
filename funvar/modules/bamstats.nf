process BAM_STATS {
    container "rjprice/bwa_samtools:latest"
    cpus = 2
    memory = 1.GB
    queue = 'medium'

    input:
    tuple val(sample), path(bam) 
    path genome

    output:
    tuple val("${sample}"), path("${sample}.stats")
    
    script:
    """
    samtools stats --threads 2 ${genome} ${bam} > ${sample}.stats
    """
}
