rule dbsnp:
    input:
        vcf="{sample}/haplotypecaller/{sample}.g.vcf.gz",
        dbsnp=config["reference"]["dbsnp"],
    output:
        "{sample}/dbsnp/{sample}.g.vcf.gz",
    log:
        "{sample}/dbsnp/dbsnp.log",
    conda:
        "../envs/parabricks.yaml"
    threads: 40
    message:
        "{rule}: Annotate vcf using SNP database"
    shell:
        "pbrun dbsnp "
        "--in-vcf {input.vcf} "
        "--in-dbsnp-file {input.dbsnp} "
        "--out-vcf {output} &> {log}"


rule indexgvcf:
    input:
        "{sample}/dbsnp/{sample}.g.vcf.gz",
    output:
        "{sample}/dbsnp/{sample}.g.vcf.gz.tbi",
    log:
        "{sample}/dbsnp/indexgvcf.log",
    conda:
        "../envs/parabricks.yaml"
    threads: 40
    message:
        "{rule}: Index annotated gvcf file"
    shell:
        "pbrun indexgvcf "
        "--input {input} &> {log}"
