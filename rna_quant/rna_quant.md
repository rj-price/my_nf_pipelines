# RNA-seq Quantification pipeline
Modularity is a NextFlow best practice. Using modular processes allow the same process to be used multiple times. Use an RNA-seq QC, trimming and qunatification pipeline to understand modular pipeline design.

Set up file structure as follows:
```
rna_quant/
├── main.nf
├── modules
│   ├── fastqc.nf
│   ├── multiqc.nf
│   ├── salmon_index.nf
│   ├── salmon_quant.nf
│   └── trimmomatic.nf
└── rna_quant.md
```

Using the following tutorials/posts, set up the processes and the ```main.nf``` workflow.

1. https://vibbits-nextflow-workshop.readthedocs.io/en/latest/nextflow/first_pipeline.html
2. https://training.nextflow.io/basic_training/rnaseq_pipeline
3. https://stackoverflow.com/questions/76541773/combining-output-from-multiple-nextflow-processes-into-another-process-nextflow
4. https://codebeast.works/ngs-data-analysis-nextflow-dsl2


Change process names to uppercase to easily differentiate processes from operators in workflow.

## MultiQC
Use a ```multiqc_config.yaml``` file to collect all outputs and run MultiQC on everything at the end of the run.

Add the following to ```main.nf```:
```
params.multiqc_config = './modules/multiqc_config.yaml'

include { MULTIQC } from "${launchDir}/modules/multiqc.nf" 

workflow {
    multiqc_config = file(params.multiqc_config)

    Channel.empty()
        .mix(PRE_FASTQC.out)
        .mix(TRIMMOMATIC.out.log_file)
        .mix(POST_FASTQC.out)
        .mix(SALMON_QUANT.out)
        .map {sample, files -> files}
        .collect()
        .set {log_files}

    MULTIQC(log_files, multiqc_config)
}
```

## Process tags
Add tags to processes to help define processes in logs, eg. 
```
tag "Salmon on $sample”
```

## Test Run
Run pipeline with Crop Diversity HPC config.
```
nextflow run main.nf -c ~/cropdiv.config
```
**Successful!**

## Reporting
Nextflow can produce multiple reports and charts providing several runtime metrics and execution information.

Run rna_quant workflow as below:
```
nextflow main.nf -c ~/cropdiv.config -with-report -with-trace -with-timeline -with-dag dag.png
```

- The ```-with-report``` option enables the creation of the workflow execution report. Open the file report.html with a browser to see the report created with the above command.
- The ```-with-trace``` option enables the creation of a tab separated value (TSV) file containing runtime information for each executed task. Check the trace.txt for an example.
- The ```-with-timeline``` option enables the creation of the workflow timeline report showing how processes were executed over time. This may be useful to identify the most time consuming tasks and bottlenecks. See an example at this link.
- Finally, the ```-with-dag``` option enables the rendering of the workflow execution direct acyclic graph representation. Note: This feature requires the installation of Graphviz on your computer.
