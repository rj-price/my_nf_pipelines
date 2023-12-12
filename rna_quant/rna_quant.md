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

