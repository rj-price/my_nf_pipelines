#!/usr/bin/nextflow

/**
 * Quality control, trimming and quantification of Illumina paired end RNA-seq data from Novogene.
 */

// General parameters
params.datadir  = "${launchDir}/data"
params.outdir   = "${launchDir}/results"

// Input parameters
params.reads            = "${params.datadir}/reads/*{1,2}.fq.gz"
params.transcriptome    = "${params.datadir}/transcriptome/*.fasta"

// Trimmomatic
params.slidingwindow    = "SLIDINGWINDOW:4:20"
params.minlength        = "MINLEN:80"
params.headcrop         = "HEADCROP:10"

log.info """\
        R N A   Q U A N T
=================================
            GENERAL
Data Folder      : ${params.datadir}
Results Folder   : ${params.outdir}
=================================
        INPUT & REFERENCES 
Read Files       : ${params.reads}
Transcriptome    : ${params.transcriptome}
=================================
            TRIMMOMATIC
Sliding Window   : ${params.slidingwindow}
Minimum Length   : ${params.minlength}
Head Crop        : ${params.headcrop}
=================================
"""

include { fastqc as pre_fastqc; fastqc as post_fastqc } from "./modules/fastqc.nf" 
include { trimmomatic } from "./modules/trimmomatic.nf"
include { multiqc as pre_multiqc; multiqc as post_multiqc } from "./modules/multiqc.nf" 
include { salmon_index } from "./modules/salmon_index.nf"
include { salmon_quant } from "./modules/salmon_quant.nf"

workflow {
    reads_ch = Channel.fromFilePairs(params.reads, checkIfExists:true)
    pre_fastqc(reads_ch)
    pre_multiqc(pre_fastqc.out.collect())
    trimmomatic(reads_ch)
    post_fastqc(trimmomatic.out.trim_fq)
    post_multiqc(post_fastqc.out.collect())

    //Transcriptome index
    transcriptome_ch = Channel.fromPath(params.transcriptome)
    salmon_index(transcriptome_ch)
    //Qunatification of trimmed reads
    salmon_quant(trimmomatic.out.trim_fq, salmon_index.out)
}