rule fastp:
    input:
        unpack(get_fastq),
    output:
        fwd="{sample}/fastp/{unit}_R1.fq.gz",
        rev="{sample}/fastp/{unit}_R2.fq.gz",
        json="{sample}/fastp/{unit}.json",
        html="{sample}/fastp/{unit}.html",
    params:
        fwd=config["reference"]["adapter"]["fwd"],
        rev=config["reference"]["adapter"]["rev"],
    log:
        "{sample}/fastp/{unit}.log",
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


rule combine_fq:
    input:
        fwd=get_fastq_fwd,
        rev=get_fastq_rev,
    output:
        fwd="{sample}/fastp/R1.fq.gz",
        rev="{sample}/fastp/R2.fq.gz",
    log:
        "{sample}/fastp/combine_fq.log",
    container:
        config["tools"]["ubuntu"]
    message:
        "{rule}: Combine fastq files of same sample"
    shell:
        "cat {input.fwd} > {output.fwd} && "
        "cat {input.rev} > {output.rev} | tee {log}"
