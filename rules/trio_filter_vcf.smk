rule trio_filter_gvcf:
    input:
        vcf="{trio}/genotype_gvcfs/{trio}.vcf.gz",
        bed=config["filter"],
    output:
        "{trio}/trio_filter_vcf/{trio}.vcf",
    log:
        "{trio}/trio_filter_vcf/trio_filter_vcf.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Filter trio vcf using bed file"
    shell:
        "(bedtools intersect "
        "-header "
        "-f 0.25 "
        "-a {input.vcf} -b {input.bed} > {output}) &> {log}"
        # "bgzip {input.vcf} && "
        # "vcftools "
        # "--gzvcf {input.vcf}.gz "
        # "--recode "
        # "--bed {input.bed} "
        # "--out {wildcards.trio}/trio_filter_gvcf/{wildcards.trio} &> {log}"
