rule pon_filter_vcf:
    input:
        vcf="{sample}/{tool}/{sample}.vcf",
        bed=lambda wildcards: config[wildcards.tool]["pon"],
    output:
        "{sample}/{tool}/{sample}.pon.vcf",
    log:
        "logs/pon_filter_vcf_{tool}_{sample}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Filter {wildcards.sample} vcf using {input.bed}"
    shell:
        "(bedtools intersect "
        "-v "
        "-header "
        "-f 0.95 "
        "-a {input.vcf} -b {input.bed} > {output}) &> {log}"


rule panel_filter_vcf:
    input:
        vcf="{sample}/{tool}/{sample}.pon.vcf",
        bed=config["filter"],
    output:
        "{sample}/{tool}/{sample}.panel.vcf",
    log:
        "logs/panel_filter_vcf_{tool}_{sample}.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Filter {wildcards.sample} vcf using {input.bed}"
    shell:
        "(bedtools intersect "
        "-header "
        "-f 0.25 "
        "-a {input.vcf} -b {input.bed} > {output}) &> {log}"
