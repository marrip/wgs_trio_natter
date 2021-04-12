rule tiddit:
    input:
        bam="{sample}/fq2bam/duplicates_marked.bam",
        ref=config["reference"]["fasta"],
    output:
        "{sample}/tiddit/{sample}.gc.wig",
        "{sample}/tiddit/{sample}.ploidy.tab",
        "{sample}/tiddit/{sample}.sample.bam",
        "{sample}/tiddit/{sample}.signals.tab",
        "{sample}/tiddit/{sample}.vcf",
        "{sample}/tiddit/{sample}.wig",
    log:
        "logs/tiddit_{sample}.log",
    container:
        config["tools"]["tiddit"]
    message:
        "{rule}: Run TIDDIT on sample {wildcards.sample}"
    shell:
        "TIDDIT.py "
        "--sv "
        "--bam {input.bam} "
        "--ref {input.ref} "
        "-o {wildcards.sample}/tiddit/{wildcards.sample} &> {log}"
