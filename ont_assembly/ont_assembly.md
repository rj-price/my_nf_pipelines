# ONT Genome Assembly

Adapting my [ONT assembly pipeline](https://github.com/rj-price/ont_assembly_starter) into a NextFlow pipeline using the new SeqeraAI.

## SeqeraAI Prompts

### Initial Prompt
"I have a Nanopore fungal genome assembly pipeline written in bash. Can you convert it to a Nextflow pipeline? (Paste in contents of `assembly.sh`)"

**Initial pipeline used conda**

### Second Prompt
"Can you change the conda use to containers?"

Run script testing on each module through SeqeraAI.


## Test Run
```bash
nextflow run main.nf -c ~/cropdiv.config --reads_dir /mnt/shared/scratch/jnprice/private/yeasties/ONT_assemblies/barcode03/barcode03.fastq.gz --genome_size 15000000 --outdir ./output
```

**Did not work due to processes trying to output directly to outdir rather than work**

Update processes and workflow to incorporate publishDir and try again.

**Did not work due to Medaka not able to download model**
```
RuntimeError: Error validating model from '--model' argument: The model file for r1041_e82_400bps_sup_g615 is not installed and could not be installed to any of /usr/local/lib/python3.8/site-packages/medaka/data or /home/jnprice/.medaka/data. If you cannot gain write permissions, download the model file manually from https://github.com/nanoporetech/medaka/raw/master/medaka/data/r1041_e82_400bps_sup_g615_model_pt.tar.gz and use the downloaded model as the --model option.
```

Modify `medaka.nf` process to download model and re-run using `-resume` flag.

**Pipeline completed successfully with one warning.**
```bash
WARN  nextflow.processor.PublishDir - Process `MULTIQC` publishDir path contains a variable with a null value
```


# To Do:
- Add parameter for prefix (default assembly) to overcome sampleID problem
- Add additional parameters for each module (ie. min length, min Q, coverage, model, etc.)