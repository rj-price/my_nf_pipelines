process RACON {
    container 'community.wave.seqera.io/library/minimap2_racon:5f257adb6aaf9096'
    cpus = 4
    memory = 40.GB
    queue = 'long'
    
    input:
    path fastq
    path necat_assembly

    output:
    path "${params.outdir}/${fastq.simpleName}/longpolish/${fastq.simpleName}_racon.fasta"

    script:
    """
    mkdir -p ${params.outdir}/${fastq.simpleName}/longpolish
    minimap2 -ax map-ont -t ${task.cpus} ${necat_assembly} ${fastq} > ${params.outdir}/${fastq.simpleName}/longpolish/map.sam
    racon --threads ${task.cpus} ${fastq} ${params.outdir}/${fastq.simpleName}/longpolish/map.sam ${necat_assembly} > ${params.outdir}/${fastq.simpleName}/longpolish/${fastq.simpleName}_racon.fasta
    """
}
