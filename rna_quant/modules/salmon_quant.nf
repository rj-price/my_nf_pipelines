process SALMON_QUANT {
    container "biocontainers/salmon:v0.12.0ds1-1b1-deb_cv1"
    publishDir "${params.results}/quant", mode: 'copy', overwrite: false
    cpus = 4
    memory = 1.GB
    queue = 'medium'

    input:
    tuple val(sample), path(reads) 
    path index

    output:
    //path "${sample}_quant"
    tuple val("${sample}"), path("${sample}_quant")
    //tuple val("${sample}"), path("${sample}_quant/aux_info/meta_info.json"), emit: log_file
    
    script:
    """
    salmon quant \\
        -i ${index} \\
        -l A \\
        -1 ${reads[0]} \\
        -2 ${reads[1]} \\
        --validateMappings \\
        -p 4 \\
        --numBootstraps 1000 \\
        --dumpEq \\
        --seqBias \\
        --gcBias \\
        -o ${sample}_quant
    """
}