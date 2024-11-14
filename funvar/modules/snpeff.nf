process SNPEFF {
    container "biocontainers/snpeff:v4.1k_cv3"
    publishDir "${params.results}/snpEff", mode: 'copy', overwrite: false
    cpus = 2
    memory = 2.GB
    queue = 'medium'

    input:
    path annotation
    path genome

    output:
    path "*"
    
    script:
    def prefix = "${genome.baseName}"

    """
    snpEff FvWT_JP all_febCv_filtered_somatic.vcf \\
        -dataDir /mnt/shared/scratch/jnprice/quorn/SNP_calling/gatk_mutect2/snpEffDB \\
        -stats snpEff_febCv_summary.html \\
        > all_febCv_filtered_somatic_annotated.vcf
    """
}
