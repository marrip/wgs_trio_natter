rule combine_fq:
    input:
        unpack(get_fastq),
    output:
        fwd="{sample}/combined_reads/R1.fq.gz",
        rev="{sample}/combined_reads/R2.fq.gz",
    log:
        "logs/combine_fq_{sample}.log",
    container:
        config["tools"]["ubuntu"]
    message:
        "{rule}: Combine fastq files of same sample"
    shell:
        "cat {input.fwd} > {output.fwd} && "
        "cat {input.rev} > {output.rev} | tee {log}"

rule fastp:
    input:
        fwd="{sample}/combined_reads/R1.fq.gz",
        rev="{sample}/combined_reads/R2.fq.gz",
    output:
        fwd="{sample}/fastp/R1.fq.gz",
        rev="{sample}/fastp/R2.fq.gz",
        json="{sample}/fastp/{sample}.json",
        html="{sample}/fastp/{sample}.html",
    params:
        fwd=config["reference"]["adapter"]["fwd"],
        rev=config["reference"]["adapter"]["rev"],
    log:
        "logs/fastp_{sample}.log",
    container:
        config["tools"]["fastp"]
    threads: 16
    message:
        "{rule}: Trim adapter sequences and fix mgi id"
    shell:
        "fastp "
        "--in1 {input.fwd} "
        "--in2 {input.rev} "
        "--out1 {output.fwd} "
        "--out2 {output.rev} "
        "--fix_mgi_id "
        "--adapter_sequence {params.fwd} "
        "--adapter_sequence_r2 {params.rev} "
        "--json {output.json} "
        "--html {output.html} "
        "-w {threads} &> {log}"
