process salmon_index {
    container "biocontainers/salmon:v0.12.0ds1-1b1-deb_cv1"
    cpus = 4
    memory = 1.GB
    queue = 'short'

    input:
    path transcriptome

    output:
    path "*"

    script:
    """
    salmon index -t ${transcriptome} -i transcriptome_index --keepDuplicates -k 27
    """
}