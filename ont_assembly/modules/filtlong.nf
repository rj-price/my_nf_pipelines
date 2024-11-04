process FILTLONG {
    container 'community.wave.seqera.io/library/filtlong:0.2.1--5cb367f8dffa9e28'
    cpus = 2
    memory = 10.GB
    queue = 'medium'

    input:
    path fastq

    output:
    path "${params.outdir}/${fastq.simpleName}/${fastq.simpleName}_filt.fastq.gz"

    script:
    """
    mkdir -p ${params.outdir}/${fastq.simpleName}
    filtlong --min_length 1000 --min_mean_q 90 ${fastq} | gzip > ${params.outdir}/${fastq.simpleName}/${fastq.simpleName}_filt.fastq.gz
    """
}
