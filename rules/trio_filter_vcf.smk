rule trio_pon_filter_vcf:
    input:
        vcf="{trio}/genotype_gvcfs/{trio}.vcf.gz",
        bed=config["haplotypecaller"]["pon"],
    output:
        "{trio}/trio_pon_filter_vcf/{trio}.vcf",
    log:
        "logs/trio_pon_filter_vcf_{trio}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Filter trio vcf using PON bed file"
    shell:
        "(bedtools intersect "
        "-v "
        "-header "
        "-f 0.95 "
        "-a {input.vcf} -b {input.bed} > {output}) &> {log}"


rule trio_panel_filter_vcf:
    input:
        vcf="{trio}/trio_pon_filter_vcf/{trio}.vcf",
        bed=config["filter"],
    output:
        "{trio}/trio_panel_filter_vcf/{trio}.vcf",
    log:
        "logs/trio_panel_filter_vcf_{trio}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Filter trio vcf using panel bed file"
    shell:
        "(bedtools intersect "
        "-header "
        "-f 0.25 "
        "-a {input.vcf} -b {input.bed} > {output}) &> {log}"
