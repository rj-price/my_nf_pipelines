process MEDAKA {
    container 'community.wave.seqera.io/library/medaka:2.0.1--c15f6748e3c63d63'
    cpus = 4
    memory = 40.GB
    queue = 'long'
    
    input:
    path fastq
    path racon_assembly

    output:
    path "${params.outdir}/${fastq.simpleName}/final/${fastq.simpleName}_medaka.fasta"

    script:
    """
    mkdir -p ${params.outdir}/${fastq.simpleName}/longpolish
    mkdir -p ${params.outdir}/${fastq.simpleName}/final
    medaka_consensus -i ${fastq} -d ${racon_assembly} -o ${params.outdir}/${fastq.simpleName}/longpolish -t ${task.cpus} -m r941_min_high_g360
    cp ${params.outdir}/${fastq.simpleName}/longpolish/consensus.fasta ${params.outdir}/${fastq.simpleName}/final/${fastq.simpleName}_medaka.fasta
    """
}
