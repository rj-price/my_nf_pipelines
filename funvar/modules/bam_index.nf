process BAM_INDEX {
    tag "BAM Index on $sample"

    container "rjprice/bwa_samtools:latest"
    cpus = 2
    memory = 1.GB
    queue = 'medium'

    input:
    tuple val(sample), path(bam) 

    output:
    tuple val("${sample}"), path("${sample}*.bai")
    
    script:
    """
    samtools index ${bam}
    """
}
