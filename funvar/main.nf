#!/usr/bin/nextflow

/*
 * Fungal variant calling of Illumina paired end WGS data.
 */

// General parameters
params.datadir   = "${launchDir}/data"
params.results   = "${launchDir}/results"

// Input parameters
params.reads            = "${params.datadir}/reads/*R{1,2}.f*q.gz"
params.genome           = "${params.datadir}/genome/*.fasta"
params.annotation       = "${params.datadir}/genome/*.gff3"
params.multiqc_config   = "${launchDir}/modules/multiqc_config.yaml"

// Trimmomatic parameters
params.slidingwindow    = "SLIDINGWINDOW:4:20"
params.minlength        = "MINLEN:80"
params.headcrop         = "HEADCROP:10"

// Variant filter parameters
params.quality          = "QUAL<50"
params.alt_allele       = "AF<0.9"

/*
log.info """\

           F U N V A R
=================================
            GENERAL
Data Folder      : ${params.datadir}
Results Folder   : ${params.results}
=================================
        INPUT & REFERENCES 
Read Files       : ${params.reads}
Genome           : ${params.genome}
Annotation       : ${params.annotation}
MultiQC Config   : ${params.multiqc_config}
=================================
            TRIMMOMATIC
Sliding Window   : ${params.slidingwindow}
Minimum Length   : ${params.minlength}
Head Crop        : ${params.headcrop}
=================================

""".stripIndent()
 */

// Define modules to use in workflow
include { BWA_INDEX                                     } from "${launchDir}/modules/bwa_index.nf" 
include { SAMTOOLS_INDEX                                } from "${launchDir}/modules/samtools_index.nf" 

include { FASTQC as PRE_FASTQC; FASTQC as POST_FASTQC   } from "${launchDir}/modules/fastqc.nf" 
include { TRIMMOMATIC                                   } from "${launchDir}/modules/trimmomatic.nf"

include { BWA_MAP                                       } from "${launchDir}/modules/bwa_map.nf" 
include { SORTSAM                                       } from "${launchDir}/modules/sortsam.nf" 
include { MARKDUP                                       } from "${launchDir}/modules/markdup.nf" 
include { BAM_INDEX                                     } from "${launchDir}/modules/bam_index.nf" 
include { BAM_STATS                                     } from "${launchDir}/modules/bamstats.nf" 

include { SNPEFF_DB                                     } from "${launchDir}/modules/snpeff_db.nf" 

include { MULTIQC                                       } from "${launchDir}/modules/multiqc.nf" 


workflow {
    reads_ch = Channel.fromFilePairs(params.reads, checkIfExists:true)

    // Process genome
    genome_ch = Channel.fromPath(params.genome)
    annotation_ch = Channel.fromPath(params.annotation)
    bwa_index_ch = BWA_INDEX(genome_ch)
    fai_index_ch = SAMTOOLS_INDEX(genome_ch)

    // Process reads
    PRE_FASTQC(reads_ch)
    TRIMMOMATIC(reads_ch)
    POST_FASTQC(TRIMMOMATIC.out.trim_fq)

    // Align reads and process bam files
    BWA_MAP(TRIMMOMATIC.out.trim_fq, bwa_index_ch.first())
    SORTSAM(BWA_MAP.out)
    MARKDUP(SORTSAM.out)
    BAM_INDEX(MARKDUP.out.bam)
    bam_ch = MARKDUP.out.bam.join(BAM_INDEX.out)
    BAM_STATS(bam_ch, genome_ch.first())

    control_ch = bam_ch.filter( ~/^WT.*/ )
    control_ch.view()

    // Call variants, process and merge
        // 

    // Annotate variants
        // Prepare snpeff db
    //SNPEFF_DB(annotation_ch, genome_ch.first())
        // Run snpeff
    
    multiqc_config = file(params.multiqc_config)

    Channel.empty()
        .mix(PRE_FASTQC.out)
        .mix(TRIMMOMATIC.out.log_file)
        .mix(POST_FASTQC.out)
        .mix(MARKDUP.out.log_file)
        .mix(BAM_STATS.out)
        .map {sample, files -> files}
        .collect()
        .set {log_files}

    MULTIQC(log_files, multiqc_config)
}

workflow.onComplete {
    log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.results/multiqc/multiqc_report.html\n" : "Oops .. something went wrong" )
}
