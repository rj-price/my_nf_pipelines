#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

// Input Parameters
params.reads_dir    = "${launchDir}/data"
params.outdir       = "${launchDir}/results"
params.prefix       = "assembly"
params.genome_size  = null

// Input validation
if (!params.reads_dir || !params.outdir || !params.genome_size || !params.prefix ) {
    error "Missing required parameters. Please provide --reads_dir, --genome_size, --prefix, and --outdir."
}


log.info """\

     O N T   A S S E M B L Y     
=================================
         INPUT PARAMETERS
Data Folder      : ${params.reads_dir}
Ouput Folder     : ${params.outdir}
Genome Size      : ${params.genome_size}
Prefix           : ${params.prefix}
=================================

""".stripIndent()


// Import modules
include { PORECHOP } from './modules/porechop'
include { NANOPLOT } from './modules/nanoplot'
include { FILTLONG } from './modules/filtlong'
include { NECAT } from './modules/necat'
include { RACON } from './modules/racon'
include { MEDAKA } from './modules/medaka'
include { BUSCO } from './modules/busco'
include { GFASTATS } from './modules/gfastats'
include { MULTIQC } from './modules/multiqc'

// Main workflow
workflow {
    // Create input channel
    reads_ch = Channel.fromPath(params.reads_dir)
        .map { dir -> tuple(dir.baseName, dir) }

    // Porechop
    PORECHOP(reads_ch)

    // NanoPlot
    NANOPLOT(PORECHOP.out.porechopped)

    // Filtlong
    FILTLONG(PORECHOP.out.porechopped)

    // NECAT
    NECAT(FILTLONG.out.filtered, params.genome_size)

    // Racon
    RACON(FILTLONG.out.filtered, NECAT.out.assembly)

    // Medaka
    MEDAKA(FILTLONG.out.filtered, RACON.out.polished)

    // BUSCO
    BUSCO(MEDAKA.out.consensus)

    // GFAStats
    GFASTATS(MEDAKA.out.consensus, params.genome_size)

    // Collect all QC reports
    multiqc_files = Channel.empty()
    multiqc_files = multiqc_files.mix(NANOPLOT.out.collect())
    multiqc_files = multiqc_files.mix(BUSCO.out.collect())

    // MultiQC
    MULTIQC(multiqc_files.collect())
}

// Workflow completion notification
workflow.onComplete {
    log.info "Pipeline completed at: $workflow.complete"
    log.info "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}