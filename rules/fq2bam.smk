rule fq2bam:
    input:
        fwd="{sample}/fastp/R1.fq.gz",
        rev="{sample}/fastp/R2.fq.gz",
        ref=config["reference"]["fasta"],
        sites=config["reference"]["sites"],
    output:
        bam="{sample}/fq2bam/duplicates_marked.bam",
        recal="{sample}/fq2bam/base_recal.txt",
    log:
        "{sample}/fq2bam/fq2bam.log",
    conda:
        "../envs/parabricks.yaml"
    threads: 40
    shell:
        "pbrun fq2bam "
        "--ref {input.ref} "
        "--in-fq {input.fwd} {input.rev} "
        "--knownSites {input.sites} "
        "--out-bam {output.bam} "
        "--out-recal-file {output.recal} "
        "--tmp-dir {wildcards.sample}/fq2bam/tmp &> {log}"
