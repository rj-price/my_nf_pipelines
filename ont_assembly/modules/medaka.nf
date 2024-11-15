process MEDAKA {
    container 'quay.io/biocontainers/medaka:2.0.1--py38h8774169_0'
    publishDir "${params.outdir}/${sample_id}/final", mode: 'copy'
    cpus = 4
    memory = 40.GB
    queue = 'long'
    
    input:
    tuple val(sample_id), path(fastq)
    tuple val(sample_id), path(racon_assembly)

    output:
    tuple val(sample_id), path("${sample_id}_medaka.fasta"), emit: consensus

    script:
    """
    wget https://github.com/nanoporetech/medaka/raw/master/medaka/data/r1041_e82_400bps_sup_g615_model_pt.tar.gz
    medaka_consensus -i ${fastq} -d ${racon_assembly} -o . -t ${task.cpus} -m r1041_e82_400bps_sup_g615_model_pt.tar.gz
    mv consensus.fasta ${sample_id}_medaka.fasta
    """
}
