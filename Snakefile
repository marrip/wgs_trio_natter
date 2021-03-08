include: "rules/common.smk"
include: "rules/prep_fq.smk"


rule all:
    input:
        "NA12878/fastp/R1.fq.gz",
        "NA12878/fastp/R2.fq.gz",
