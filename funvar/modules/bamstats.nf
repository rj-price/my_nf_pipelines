process BAM_STATS {
    tag "BAM Stats on $sample"

    container "rjprice/bwa_samtools:latest"
    cpus = 2
    memory = 1.GB
    queue = 'medium'

    input:
    tuple val(sample), path(bam), path(bai)
    //tuple val(sample), path(bai) 
    path genome

    output:
    tuple val("${sample}"), path("${sample}.stats")
    
    script:
    """
    samtools stats --threads 2 --ref-seq ${genome} ${bam} > ${sample}.stats
    """
}
