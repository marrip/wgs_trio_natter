rule trio_combine_gvcf:
    input:
        unpack(get_gvcf_trio),
        ref=config["reference"]["fasta"],
    output:
        "{trio}/trio_combine_gvcf/{trio}.g.vcf",
    log:
        "{trio}/trio_combine_gvcf/trio_combine_gvcf.log",
    conda:
        "../envs/parabricks.yaml"
    threads: 40
    message:
        "{rule}: Combine annotated gvcfs"
    shell:
        "pbrun triocombinegvcf "
        "--ref {input.ref} "
        "--in-gvcf {input.gvcf1} "
        "--in-gvcf {input.gvcf2} "
        "--in-gvcf {input.gvcf3} "
        "--out-variants {output} &> {log}"
