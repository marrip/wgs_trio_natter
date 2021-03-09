include: "rules/common.smk"
include: "rules/prep_fq.smk"


rule all:
    input:
        "NA12878/fq2bam/duplicates_marked.bam",
