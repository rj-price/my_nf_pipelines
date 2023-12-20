process BAM_INDEX {
    container "rjprice/bwa_samtools:latest"
    cpus = 2
    memory = 1.GB
    queue = 'medium'

    input:
    tuple val(sample), path(bam) 

    output:
    tuple val("${sample}"), path("${sample}*.bam.bai")
    
    script:
    """
    samtools index ${bam}
    """
}
