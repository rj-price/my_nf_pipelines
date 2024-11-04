process NANOPLOT {
    container 'community.wave.seqera.io/library/nanoplot:1.43.0--c7226d331b0968bf'
    cpus = 2
    memory = 4.GB
    queue = 'short'

    input:
    path fastq

    output:
    path "${params.outdir}/${fastq.simpleName}/nanoplot"

    script:
    """
    mkdir -p ${params.outdir}/${fastq.simpleName}/nanoplot
    NanoPlot -t ${task.cpus} --fastq ${fastq} -o ${params.outdir}/${fastq.simpleName}/nanoplot
    """
}
