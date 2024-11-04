# ONT Genome Assembly

Adapting my [ONT assembly pipeline](https://github.com/rj-price/ont_assembly_starter) into a NextFlow pipeline using the new SeqeraAI.

## SeqeraAI Prompts

### Initial Prompt
I have a Nanopore fungal genome assembly pipeline written in bash. Can you convert it to a Nextflow pipeline? (Paste in contents of `assembly.sh`)

**Initial pipeline used conda**

### Second Prompt
Can you change the conda use to containers?

Run script testing on each module through SeqeraAI.


## Test Run
```bash
nextflow run main.nf -c ~/cropdiv.config --reads_dir /mnt/shared/scratch/jnprice/private/yeasties/ONT_assemblies/barcode03/barcode03.fastq.gz --genome_size 15000000
```