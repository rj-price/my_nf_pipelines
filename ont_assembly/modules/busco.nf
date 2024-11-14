process BUSCO {
    container 'community.wave.seqera.io/library/busco:5.2.2--b38cf04af6adc85b'
    publishDir "${params.outdir}/${sample_id.baseName}/final", mode: 'copy'
    cpus = 8
    memory = 3.GB
    queue = 'medium'

    input:
    tuple val(sample_id), path(assembly)

    output:
    path "BUSCO_${sample_id.baseName}.fungi"

    script:
    """
    busco -m genome -c ${task.cpus} -i ${assembly} -o BUSCO_${sample_id.baseName}.fungi -l fungi_odb10
    """
}
