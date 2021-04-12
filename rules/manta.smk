rule config_manta:
    input:
        bam="{sample}/fq2bam/duplicates_marked.bam",
        ref=config["reference"]["fasta"],
    output:
        "{sample}/manta/runWorkflow.py",
    log:
        "logs/config_manta_{sample}.log",
    container:
        config["tools"]["manta"]
    message:
        "{rule}: Generate Manta run workflow script"
    shell:
        "configManta.py "
        "--bam={input.bam} "
        "--referenceFasta={input.ref} "
        "--runDir={wildcards.sample}/manta &> {log}"


rule manta:
    input:
        bam="{sample}/fq2bam/duplicates_marked.bam",
        ref=config["reference"]["fasta"],
        script="{sample}/manta/runWorkflow.py",
    output:
        "{sample}/manta/results/variants/candidateSmallIndels.vcf.gz",
        "{sample}/manta/results/variants/candidateSmallIndels.vcf.gz.tbi",
        "{sample}/manta/results/variants/candidateSV.vcf.gz",
        "{sample}/manta/results/variants/candidateSV.vcf.gz.tbi",
        "{sample}/manta/results/variants/diploidSV.vcf.gz",
        "{sample}/manta/results/variants/diploidSV.vcf.gz.tbi",
    log:
        "logs/manta_{sample}.log",
    container:
        config["tools"]["manta"]
    message:
        "{rule}: Run Manta workflow script"
    threads: 40
    shell:
        "{input.script} "
        "-j {threads} "
        "-g unlimited &> {log}"


rule prep_manta_vcf:
    input:
        "{sample}/manta/results/variants/diploidSV.vcf.gz",
    output:
        "{sample}/manta/{sample}.vcf",
    log:
        "logs/prep_manta_vcf_{sample}.log",
    container:
        config["tools"]["ubuntu"]
    message:
        "{rule}: Copy and unzip manta vcf"
    shell:
        "cp {input} {output}.gz &> {log} && "
        "gunzip {output}.gz &>> {log}"
