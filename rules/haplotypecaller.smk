rule haplotypecaller:
    input:
        bam="{sample}/fq2bam/duplicates_marked.bam",
        recal="{sample}/fq2bam/base_recal.txt",
        ref=config["reference"]["fasta"],
    output:
        "{sample}/haplotypecaller/{sample}.vcf",
    log:
        "logs/haplotypecaller_{sample}.log",
    conda:
        "../envs/parabricks.yaml"
    threads: 40
    message:
        "{rule}: Call variants in {wildcards.sample} using pbrun haplotypecaller"
    shell:
        "pbrun haplotypecaller "
        "--in-bam {input.bam} "
        "--in-recal-file {input.recal} "
        "--ref {input.ref} "
        "--out-variants {output} &> {log}"


rule haplotypecaller_gvcf:
    input:
        bam="{sample}/fq2bam/duplicates_marked.bam",
        recal="{sample}/fq2bam/base_recal.txt",
        ref=config["reference"]["fasta"],
    output:
        "{sample}/haplotypecaller/{sample}.g.vcf.gz",
    log:
        "logs/haplotypecaller_gvcf_{sample}.log",
    conda:
        "../envs/parabricks.yaml"
    threads: 40
    message:
        "{rule}: Call variants in {wildcards.sample} using pbrun haplotypecaller"
    shell:
        "pbrun haplotypecaller "
        "--in-bam {input.bam} "
        "--in-recal-file {input.recal} "
        "--ref {input.ref} "
        "--gvcf "
        "--out-variants {output} &> {log}"


rule collect_variant_calling_metrics:
    input:
        vcf="{sample}/haplotypecaller/{sample}.g.vcf.gz",
        dbsnp=config["reference"]["dbsnp"],
        dict=config["reference"]["dict"],
    output:
        "{sample}/haplotypecaller/{sample}.variant_calling_detail_metrics",
        "{sample}/haplotypecaller/{sample}.variant_calling_summary_metrics",
    log:
        "logs/collect_variant_calling_metrics_{sample}.log",
    container:
        config["tools"]["gatk"]
    message:
        "{rule}: Collect metrics on called variants"
    shell:
        "gatk CollectVariantCallingMetrics "
        "-I {input.vcf} "
        "--DBSNP {input.dbsnp} "
        "-SD {input.dict} "
        "-O {wildcards.sample}/haplotypecaller/{wildcards.sample} "
        "--GVCF_INPUT &> {log}"
