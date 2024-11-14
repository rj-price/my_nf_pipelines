process SNPEFF_DB {
    container "biocontainers/snpeff:v4.1k_cv3"
    publishDir "${params.results}/snpEffDB", mode: 'copy', overwrite: false
    cpus = 2
    memory = 8.GB
    queue = 'medium'

    input:
    path annotation
    path genome

    output:
    path "*"
    
    script:
    def prefix = "${genome.baseName}"

    """
    mkdir -p snpEffDB/${prefix}

    cp ${annotation} snpEffDB/${prefix}/genes.gff
    cp ${genome} snpEffDB/${prefix}

    snpEff -Xmx6g build -dataDir snpEffDB \\
        -configOption ${prefix}.genome=${prefix} \\
        -gff3 -v ${prefix}
    """
}
