process RACON {
    container 'community.wave.seqera.io/library/minimap2_racon:5f257adb6aaf9096'
    publishDir "${params.outdir}/${sample_id.baseName}/longpolish", mode: 'copy'
    cpus = 4
    memory = 40.GB
    queue = 'long'
    
    input:
    tuple val(sample_id), path(fastq)
    tuple val(sample_id), path(necat_assembly)

    output:
    tuple val(sample_id), path("${sample_id.baseName}_racon.fasta"), emit: polished

    script:
    """
    minimap2 -ax map-ont -t ${task.cpus} ${necat_assembly} ${fastq} > map.sam
    racon --threads ${task.cpus} ${fastq} map.sam ${necat_assembly} > ${sample_id.baseName}_racon.fasta
    """
}
