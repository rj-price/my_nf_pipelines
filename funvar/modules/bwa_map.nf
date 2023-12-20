process BWA_MAP {
    container "rjprice/bwa_samtools:latest"
    cpus = 4
    memory = 1.GB
    queue = 'medium'

    input:
    tuple val(sample), path(reads) 
    path index

    output:
    tuple val("${sample}"), path("${sample}.bam")
    
    script:
    """
    INDEX=\$(find -L ./ -name "*.amb" | sed 's/\\.amb\$//')
    
    bwa mem \\
        -t 4 \\
        \$INDEX \\
        ${reads[0]} \\
        ${reads[1]} \\
        | samtools view --threads 8 -b -o ${sample}.bam
    """
}
