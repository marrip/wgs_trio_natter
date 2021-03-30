rule config_manta:
    input:
        unpack(get_gvcf_trio),
        ref=config["reference"]["fasta"],
    output:
        "{trio}/manta/runWorkflow.py",
    log:
        "{trio}/manta/config_manta.log",
    container:
        config["tools"]["manta"]
    message:
        "{rule}: Generate Manta run workflow script"
    shell:
        "configManta.py "
        "--bam={input.bam1} "
        "--bam={input.bam2} "
        "--bam={input.bam3} "
        "--referenceFasta={input.ref} "
        "--runDir={wildcards.trio}/manta &> {log}"


rule manta:
    input:
        unpack(get_gvcf_trio),
        ref=config["reference"]["fasta"],
        script="{trio}/manta/runWorkflow.py",
    output:
        "{trio}/manta/results/variants/diploidSV.vcf.gz",
    log:
        "{trio}/manta/manta.log",
    container:
        config["tools"]["manta"]
    message:
        "{rule}: Run Manta workflow script"
    threads: 40
    shell:
        "{input.script} "
        "-j {threads} "
        "-g unlimited &> {log}"
