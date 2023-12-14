process MULTIQC {
    container "ewels/multiqc:v1.18"
    publishDir "${params.results}/multiqc", mode: 'copy', overwrite: false
    cpus = 1
    memory = 1.GB
    queue = 'short'

    input:
    path '*'
    path config

    output:
    path "multiqc_report.html"
    path "multiqc_data"

    """
    multiqc \\
        --config "${config}" \\
        .
    """
}