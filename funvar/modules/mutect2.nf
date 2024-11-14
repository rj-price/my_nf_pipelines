process MUTECT2 {
    tag "Mutect2 on $sample"

    container "broadinstitute/gatk:4.3.0.0"
    cpus = 2
    memory = 4.GB
    queue = 'medium'

    input:
    tuple val(sample), path(bam) 

    output:
    tuple val("${sample}"), path("${sample}.markdup.bam"), emit: bam
    tuple val("${sample}"), path("${sample}.markdup.txt"), emit: log_file
    
    script:
    """
    gatk --java-options "-Xmx3000M -XX:ParallelGCThreads=2" \\
        Mutect2 \\
        -R FvWT_JP.fasta \\
        -I Cv.bam \\
        -I 03_mark_duplicates/WT.bam \\
        -normal WTnew \\
        -O "$fileshort"_unfiltered_somatic.vcf

    gatk --java-options "-Xmx3000M -XX:ParallelGCThreads=2" \\
        FilterMutectCalls -R FvWT_JP.fasta -V "$fileshort"_unfiltered_somatic.vcf -O "$fileshort"_prefiltered_somatic.vcf

    gatk --java-options "-Xmx3000M -XX:ParallelGCThreads=2" \\
        SelectVariants \\
        -R FvWT_JP.fasta \\
        -V "$fileshort"_prefiltered_somatic.vcf \\
        --exclude-filtered \\
        -O "$fileshort"_filtered_somatic.vcf
    """
}
