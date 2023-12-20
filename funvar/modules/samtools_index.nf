process SAMTOOLS_INDEX {
    container "rjprice/bwa_samtools:latest"
    cpus = 2
    memory = 1.GB
    queue = 'medium'

    input:
    path genome

    output:
    path "*.fai"

    script:
    """
    samtools faidx ${genome}
    """
}
