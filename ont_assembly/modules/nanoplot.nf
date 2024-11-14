process NANOPLOT {
    container 'community.wave.seqera.io/library/nanoplot:1.43.0--c7226d331b0968bf'
    publishDir "${params.outdir}/${sample_id.baseName}/nanoplot", mode: 'copy'
    cpus = 2
    memory = 4.GB
    queue = 'short'

    input:
    tuple val(sample_id), path(fastq)

    output:
    path "*"

    script:
    """
    NanoPlot -t ${task.cpus} --fastq ${fastq} -o .
    """
}
