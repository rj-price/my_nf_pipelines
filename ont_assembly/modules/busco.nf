process BUSCO {
    container 'community.wave.seqera.io/library/busco:5.2.2--b38cf04af6adc85b'
    cpus = 8
    memory = 3.GB
    queue = 'medium'

    input:
    path assembly

    output:
    path "${params.outdir}/${assembly.simpleName}/final/BUSCO_${assembly.simpleName}.fungi"

    script:
    """
    cd ${params.outdir}/${assembly.simpleName}/final
    busco -m genome -c ${task.cpus} -i ${assembly} -o BUSCO_${assembly.simpleName}.fungi -l fungi_odb10
    """
}
