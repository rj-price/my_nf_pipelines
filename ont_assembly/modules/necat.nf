process NECAT {
    container 'community.wave.seqera.io/library/necat:0.0.1_update20200803--3374eaaf9f244948'
    cpus = 4
    memory = 40.GB
    queue = 'long'

    input:
    path fastq
    val genome_size

    output:
    path "${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}_necat.fasta"

    script:
    """
    mkdir -p ${params.outdir}/${fastq.simpleName}/necat
    realpath ${fastq} > ${params.outdir}/${fastq.simpleName}/necat/read_list.txt
    necat config ${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}_config.txt
    sed -i "s/PROJECT=/PROJECT=${fastq.simpleName}/g" ${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}_config.txt
    sed -i 's/ONT_READ_LIST=/ONT_READ_LIST=read_list.txt/g' ${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}_config.txt
    sed -i "s/GENOME_SIZE=/GENOME_SIZE=${genome_size}/g" ${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}_config.txt
    sed -i 's/THREADS=4/THREADS=${task.cpus}/g' ${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}_config.txt
    sed -i 's/PREP_OUTPUT_COVERAGE=40/PREP_OUTPUT_COVERAGE=80/g' ${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}_config.txt
    sed -i 's/CNS_OUTPUT_COVERAGE=30/CNS_OUTPUT_COVERAGE=80/g' ${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}_config.txt

    necat correct ${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}_config.txt
    necat assemble ${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}_config.txt
    necat bridge ${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}_config.txt
    
    cp ${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}/6-bridge_contigs/polished_contigs.fasta ${params.outdir}/${fastq.simpleName}/necat/${fastq.simpleName}_necat.fasta
    """
}
