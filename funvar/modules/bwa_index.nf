process BWA_INDEX {
    container "biocontainers/bwa:v0.7.17_cv1"
    cpus = 2
    memory = 1.GB
    queue = 'short'

    input:
    path genome

    output:
    path "bwa"

    script:
    def prefix = "${genome.baseName}"

    """
    mkdir bwa

    bwa \\
        index \\
        -p bwa/${prefix} \\
        ${genome} 
    """
}