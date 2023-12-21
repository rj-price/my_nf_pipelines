process SORTSAM {
    tag "Sort BAM on $sample"

    container "broadinstitute/gatk:4.3.0.0"
    cpus = 2
    memory = 4.GB
    queue = 'medium'

    input:
    tuple val(sample), path(bam) 

    output:
    tuple val("${sample}"), path("${sample}.sorted.bam")
    
    script:
    """
    gatk --java-options "-Xmx3000M -XX:ParallelGCThreads=2" \\
        SortSam -I ${bam} -SO coordinate -O ${sample}.sorted.bam
    """
}
