rule fastqc:
    input:
        "{sample}/fastp/R1.fq.gz",
        "{sample}/fastp/R2.fq.gz",
    output:
        directory("{sample}/fastqc"),
    log:
        "logs/fastqc_{sample}.log",
    container:
        config["tools"]["fastqc"]
    threads: 2
    message:
        "{rule}: Generate fastq statistics"
    shell:
        "fastqc "
        "-t {threads} "
        "--outdir {output} "
        "{input} &> {log}"
