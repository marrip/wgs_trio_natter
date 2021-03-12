rule trio_filter_gvcf:
    input:
        vcf="{trio}/trio_combine_gvcf/{trio}.g.vcf",
        bed=config["filter"],
    output:
        "{trio}/trio_filter_gvcf/{trio}.g.vcf",
    log:
        "{trio}/trio_filter_gvcf/trio_filter_gvcf.log",
    container:
        config["tools"]["common"]
    message:
        "{rule}: Filter trio gvcf using bed file"
    shell:
        "(bedtools intersect "
        "-header "
        "-f 0.25 "
        "-a {input.vcf} -b {input.bed} > {output}) &> {log}"
