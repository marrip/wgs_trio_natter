rule filter_vcf:
    input:
        vcf="{sample}/haplotypecaller/{sample}.vcf",
        bed=config["filter"],
    output:
        "{sample}/filter_vcf/{sample}.vcf",
    log:
        "{sample}/filter_vcf/filter_vcf.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Filter vcf using bed file"
    shell:
        "(bedtools intersect "
        "-header "
        "-f 0.25 "
        "-a {input.vcf} -b {input.bed} > {output}) &> {log}"
