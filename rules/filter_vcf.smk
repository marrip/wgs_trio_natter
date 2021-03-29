rule pon_filter_vcf:
    input:
        vcf="{sample}/haplotypecaller/{sample}.vcf",
        bed=config["reference"]["pon"],
    output:
        "{sample}/pon_filter_vcf/{sample}.vcf",
    log:
        "{sample}/pon_filter_vcf/pon_filter_vcf.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Filter vcf using PON bed file"
    shell:
        "(bedtools intersect "
        "-v "
        "-header "
        "-f 0.25 "
        "-a {input.vcf} -b {input.bed} > {output}) &> {log}"


rule panel_filter_vcf:
    input:
        vcf="{sample}/pon_filter_vcf/{sample}.vcf",
        bed=config["filter"],
    output:
        "{sample}/panel_filter_vcf/{sample}.vcf",
    log:
        "{sample}/panel_filter_vcf/panel_filter_vcf.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Filter vcf using panel bed file"
    shell:
        "(bedtools intersect "
        "-header "
        "-f 0.25 "
        "-a {input.vcf} -b {input.bed} > {output}) &> {log}"
