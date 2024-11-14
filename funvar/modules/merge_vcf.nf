


for file in C3{5..9}*_filtered_somatic.vcf;
    do bgzip $file
    bcftools index $file.gz
    done

for file in C4{0..1}*_filtered_somatic.vcf;
    do bgzip $file
    bcftools index $file.gz
    done

bcftools merge --force-samples \
    C35_filtered_somatic.vcf.gz \
    C35s1_filtered_somatic.vcf.gz \
    C35s2_filtered_somatic.vcf.gz \
    C36_filtered_somatic.vcf.gz \
    C36s1_filtered_somatic.vcf.gz \
    C37_filtered_somatic.vcf.gz \
    C37s1_filtered_somatic.vcf.gz \
    C37s2_filtered_somatic.vcf.gz \
    C37s3_filtered_somatic.vcf.gz \
    C38_filtered_somatic.vcf.gz \
    C38s1_filtered_somatic.vcf.gz \
    C38s2_filtered_somatic.vcf.gz \
    C39_filtered_somatic.vcf.gz \
    C39s1_filtered_somatic.vcf.gz \
    C40_filtered_somatic.vcf.gz \
    C40s1_filtered_somatic.vcf.gz \
    C40s2_filtered_somatic.vcf.gz \
    C41_filtered_somatic.vcf.gz \
    -o all_febCv_filtered_somatic.vcf