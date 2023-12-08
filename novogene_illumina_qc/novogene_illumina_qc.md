# Novogene Illumina QC pipeline
Using a simple QC and trimming pipeline to understand data flow through multiple processes in NextFlow.

Use ```myhpc.conf``` and ```fastqc.nf``` as a base for pipeline development.

Edit ```myhpc.conf``` to contain additional information regarding maximum compute requests, maximum number of jobs running, and to clean up ```work``` directory following a successful run. Also copy to ```home``` directory as ```cropdiv.config```.

## Output to set directory
Move ```fastqc.nf``` to ```novogene_illumina_qc.nf``` and modify to include additional parameters to output results to a set directory.
```
params.results = "results" 

process fastqc {
    publishDir "${params.results}/fastqc", mode: 'copy', overwrite: false
}
```
**Successful!**

## MultiQC
Add MultiQC process to ```novogene_illumina_qc.nf```:
```
process multiqc {
    container "ewels/multiqc:v1.18"
    publishDir "${params.results}/multiqc", mode: 'copy', overwrite: false
    cpus = 1
    memory = 1.GB
    queue = 'short'

    input:
    path fastqcOut

    output:
    path "*"

    script:
    """
    multiqc ${fastqcOut}
    """
}
```
And add process to workflow:
```
workflow {
    reads_ch = Channel.fromPath(params.reads)
    fastqc(reads_ch)
    multiqc(fastqc.out.collect())
}
```
**Successful!**

## Paired reads
To ingest paired reads, use:
```
params.reads = "data/*R{1,2}.fastq.gz"

process fastqc {
    input:
    tuple val(sample), path(reads)
}

workflow {
    reads_ch = Channel.fromFilePairs(params.reads)
}
```
If ```reads_ch.view()``` used, output would look like this...
```
[WT, [./data/WT_R1.fastq.gz, ./data/WT_R2.fastq.gz]]
```
**Successful!**

## Trimmomatic
Add a Trimmomatic process to trim and process paired reads and output trimmed and unpaired reads:
```
process trimmomatic {
    container "quay.io/biocontainers/trimmomatic:0.39--hdfd78af_2"
    publishDir "${params.results}/trimmed", mode: 'copy', overwrite: false
    cpus = 4
    memory = 1.GB
    queue = 'medium'

    input:
    tuple val(sample), path(reads) 

    output:
    tuple val("${sample}"), path("${sample}*.trimmed.fastq.gz"), emit: trim_fq
    tuple val("${sample}"), path("${sample}*.unpaired.fastq.gz"), emit: unpaired_fq
    
    script:
    """
    trimmomatic PE \\
        -threads 8 -phred33 \\
        ${reads[0]} ${reads[1]} \\
        ${sample}_R1.trimmed.fastq.gz ${sample}_R1.unpaired.fastq.gz \\
        ${sample}_R2.trimmed.fastq.gz ${sample}_R2.unpaired.fastq.gz \\
        ILLUMINACLIP:TruSeq3-PE:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 HEADCROP:10 MINLEN:80
    """
}
```

Rename ```fastqc``` and ```multiqc``` processes to ```pre_fastqc``` and ```pre_multiqc```, and duplicate these processes as ```post_fastqc``` and ```post_multiqc``` following ```trimmomatic``` to QC the trimmed reads.

Modify the workflow to look like this:
```
workflow {
    reads_ch = Channel.fromFilePairs(params.reads)
    pre_fastqc(reads_ch)
    pre_multiqc(pre_fastqc.out.collect())
    trimmomatic(reads_ch)
    post_fastqc(trimmomatic.out)
    post_multiqc(post_fastqc.out.collect())
}
```
**Successful!**
