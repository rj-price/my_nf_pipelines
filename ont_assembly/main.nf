#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
 * Quality control, filtering and assembly of Oxford Nanopore WGS data.
 */

// Parameters
params.reads_dir = null
params.genome_size = null
params.outdir = "${launchDir}/results"

// Input validation
if (!params.reads_dir || !params.genome_size || !params.outdir) {
    error "Missing required parameters. Please provide --reads_dir, --genome_size, and --outdir."
}

log.info """\

     O N T   A S S E M B L Y
=================================
             GENERAL
Reads Folder     : ${params.reads_dir}
Results Folder   : ${params.outdir}
=================================
              INPUT
Genome Size      : ${params.genome_size}
=================================
            FILTLONG
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

// Main workflow
workflow {
    // Create input channel
    reads_ch = Channel.fromPath(params.reads_dir)

    // Porechop
    PORECHOP(reads_ch)

    // NanoPlot
    NANOPLOT(PORECHOP.out)

    // Filtlong
    FILTLONG(PORECHOP.out)

    // NECAT
    NECAT(FILTLONG.out, params.genome_size)

    // Racon
    RACON(FILTLONG.out, NECAT.out)

    // Medaka
    MEDAKA(FILTLONG.out, RACON.out)

    // BUSCO
    BUSCO(MEDAKA.out)

    // GFAStats
    GFASTATS(MEDAKA.out, params.genome_size)
}

// Workflow completion notification
workflow.onComplete {
    log.info "Pipeline completed at: $workflow.complete"
    log.info "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
}