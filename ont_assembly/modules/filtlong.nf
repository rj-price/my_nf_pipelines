process FILTLONG {
    container 'community.wave.seqera.io/library/filtlong:0.2.1--5cb367f8dffa9e28'
    publishDir "${params.outdir}/${sample_id}", mode: 'copy'
    cpus = 2
    memory = 10.GB
    queue = 'medium'

    input:
    tuple val(sample_id), path(fastq)

    output:
    tuple val(sample_id), path("${sample_id}_filt.fastq.gz"), emit: filtered

    script:
    """
    filtlong --min_length 1000 --min_mean_q 90 ${fastq} | gzip > ${sample_id}_filt.fastq.gz
    """
}
