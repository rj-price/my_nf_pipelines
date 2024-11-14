process NECAT {
    container 'community.wave.seqera.io/library/necat:0.0.1_update20200803--3374eaaf9f244948'
    publishDir "${params.outdir}/${sample_id.baseName}/necat", mode: 'copy'
    cpus = 4
    memory = 40.GB
    queue = 'long'

    input:
    tuple val(sample_id), path(fastq)
    val genome_size

    output:
    tuple val(sample_id), path("${sample_id.baseName}_necat.fasta"), emit: assembly

    script:
    """
    echo ${fastq} > read_list.txt
    necat config ${sample_id.baseName}_config.txt

    sed -i "s/PROJECT=/PROJECT=${sample_id.baseName}/g" ${sample_id.baseName}_config.txt
    sed -i 's/ONT_READ_LIST=/ONT_READ_LIST=read_list.txt/g' ${sample_id.baseName}_config.txt
    sed -i "s/GENOME_SIZE=/GENOME_SIZE=${genome_size}/g" ${sample_id.baseName}_config.txt
    sed -i 's/THREADS=4/THREADS=${task.cpus}/g' ${sample_id.baseName}_config.txt
    sed -i 's/PREP_OUTPUT_COVERAGE=40/PREP_OUTPUT_COVERAGE=80/g' ${sample_id.baseName}_config.txt
    sed -i 's/CNS_OUTPUT_COVERAGE=30/CNS_OUTPUT_COVERAGE=80/g' ${sample_id.baseName}_config.txt

    necat correct ${sample_id.baseName}_config.txt
    necat assemble ${sample_id.baseName}_config.txt
    necat bridge ${sample_id.baseName}_config.txt
    
    cp ${sample_id.baseName}/6-bridge_contigs/polished_contigs.fasta ${sample_id.baseName}_necat.fasta
    """
}
