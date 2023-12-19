#!/usr/bin/nextflow

/*
 * Quality control, trimming and quantification of Illumina paired end RNA-seq data.
 */

// General parameters
params.datadir   = "${launchDir}/data"
params.results   = "${launchDir}/results"

// Input parameters
params.reads            = "${params.datadir}/reads/*R{1,2}.f*q.gz"
params.transcriptome    = "${params.datadir}/transcriptome/*.fasta"
params.multiqc_config   = "${launchDir}/modules/multiqc_config.yaml"

// Trimmomatic parameters
params.slidingwindow    = "SLIDINGWINDOW:4:20"
params.minlength        = "MINLEN:80"
params.headcrop         = "HEADCROP:10"

log.info """\

        R N A   Q U A N T
=================================
            GENERAL
Data Folder      : ${params.datadir}
Results Folder   : ${params.results}
=================================
        INPUT & REFERENCES 
Read Files       : ${params.reads}
Transcriptome    : ${params.transcriptome}
MultiQC Config   : ${params.multiqc_config}
=================================
            TRIMMOMATIC
Sliding Window   : ${params.slidingwindow}
Minimum Length   : ${params.minlength}
Head Crop        : ${params.headcrop}
=================================

""".stripIndent()

// Define modules to use in workflow
include { FASTQC as PRE_FASTQC; FASTQC as POST_FASTQC } from "${launchDir}/modules/fastqc.nf" 
include { TRIMMOMATIC } from "${launchDir}/modules/trimmomatic.nf"
include { SALMON_INDEX } from "${launchDir}/modules/salmon_index.nf"
include { SALMON_QUANT } from "${launchDir}/modules/salmon_quant.nf"
include { MULTIQC } from "${launchDir}/modules/multiqc.nf" 


workflow {
    reads_ch = Channel.fromFilePairs(params.reads, checkIfExists:true)

    PRE_FASTQC(reads_ch)
    TRIMMOMATIC(reads_ch)
    POST_FASTQC(TRIMMOMATIC.out.trim_fq)

    index_ch = SALMON_INDEX(params.transcriptome)
    quant_ch = SALMON_QUANT(TRIMMOMATIC.out.trim_fq, index_ch)
    
    multiqc_config = file(params.multiqc_config)

    Channel.empty()
        .mix(PRE_FASTQC.out)
        .mix(TRIMMOMATIC.out.log_file)
        .mix(POST_FASTQC.out)
        .mix(quant_ch)
        .map {sample, files -> files}
        .collect()
        .set {log_files}

    MULTIQC(log_files, multiqc_config)
}

workflow.onComplete {
    log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.results/multiqc/multiqc_report.html\n" : "Oops .. something went wrong" )
}
