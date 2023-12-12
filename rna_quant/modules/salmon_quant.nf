process salmon_quant {
    container "biocontainers/salmon:v0.12.0ds1-1b1-deb_cv1"
    publishDir "${params.results}/quant", mode: 'copy', overwrite: false
    cpus = 4
    memory = 1.GB
    queue = 'medium'

    input:
    tuple val(sample), path(reads) 
    path index

    output:
    tuple val("${sample}"), path("${sample}*.trimmed.fastq.gz"), emit: trim_fq
    
    script:
    """
    salmon quant \
        -i ${index} \
        -l A \
        -1 $ReadF \
        -2 $ReadR \
        --validateMappings \
        -p 4 \
        --numBootstraps 1000 \
        --dumpEq \
        --seqBias \
        --gcBias \
        -o "$short"_quant
    """
}