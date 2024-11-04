process GFASTATS {
    container 'community.wave.seqera.io/library/gfastats:1.3.7--5ddeb8c027819e41'
    cpus = 1
    memory = 1.GB
    queue = 'short'

    input:
    path assembly
    val genome_size

    output:
    path "${params.outdir}/${assembly.simpleName}/final/${assembly.simpleName}_genome_stats.tsv"

    script:
    """
    gfastats ${assembly} ${genome_size} --threads ${task.cpus} --tabular --nstar-report > ${params.outdir}/${assembly.simpleName}/final/${assembly.simpleName}_genome_stats.tsv
    """
}
