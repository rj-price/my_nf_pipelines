process GFASTATS {
    container 'community.wave.seqera.io/library/gfastats:1.3.7--5ddeb8c027819e41'
    publishDir "${params.outdir}/${sample_id.baseName}/final", mode: 'copy'
    cpus = 1
    memory = 1.GB
    queue = 'short'

    input:
    tuple val(sample_id), path(assembly)
    val genome_size

    output:
    path "${sample_id.baseName}_genome_stats.tsv"

    script:
    """
    gfastats ${assembly} ${genome_size} --threads ${task.cpus} --tabular --nstar-report > ${sample_id.baseName}_genome_stats.tsv
    """
}
