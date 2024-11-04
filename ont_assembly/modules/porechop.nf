process PORECHOP {
    container 'community.wave.seqera.io/library/porechop:0.2.4--b0e5b14915819586'
    cpus = 4
    memory = 30.GB
    queue = 'medium'

    input:
    path reads_dir

    output:
    path "${params.outdir}/${reads_dir.baseName}/${reads_dir.baseName}.fastq.gz"

    script:
    """
    mkdir -p ${params.outdir}/${reads_dir.baseName}
    porechop -t ${task.cpus} -i ${reads_dir} -o ${params.outdir}/${reads_dir.baseName}/${reads_dir.baseName}.fastq.gz
    """
}
