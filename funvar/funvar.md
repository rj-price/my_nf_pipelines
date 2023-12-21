# Fungal Variant Calling pipeline

Use a fungal variant calling pipeline to learn how to create more complex pipelines using a sample sheet with input ingestion.

## Proposed workflow
```
sample_sheet > reads_ch, mutant_ch, wt_ch, genome_ch, gff_ch

reads_ch > fastqc
reads_ch > trimmomatic
trim_reads > fastqc

genome_ch > bwa_index
genome_ch > fai_index
trim_reads, genome_ch > bwa_map > sort_sam > mark_dups > index_bam / samtools_stats

mapped_ch > mutect_call > mutect_filter (AF > 0.9) > combine_calls
calls_ch > snpeff
```

### Mulled Container
Need to create bwa and samtools container. On local machine, create the following Dockerfile:
```
FROM mambaorg/micromamba:0.25.1

LABEL image.author.name "Jordan Price"
LABEL image.author.email "rj_price@hotmail.co.uk"

COPY --chown=$MAMBA_USER:$MAMBA_USER env.yml /tmp/env.yml

RUN micromamba create -n bwa_samtools

RUN micromamba install -y -n bwa_samtools -f /tmp/env.yml && \
    micromamba clean --all --yes

ENV PATH /opt/conda/envs/bwa_samtools/bin:$PATH
```
And the conda environment yaml file:
```
name: bwa_samtools
channels:
    - conda-forge
    - defaults
    - bioconda
dependencies:
    - bioconda::bwa=0.7.17
    - bioconda::samtools=1.19
```
Create the image and then push to Docker Hub:
```
docker build -t bwa_samtools .

docker tag bwa_samtools rjprice/bwa_samtools
docker push rjprice/bwa_samtools
```

## Test run
```
nextflow main.nf -c ~/cropdiv.config -resume
```
