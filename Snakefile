include: "rules/common.smk"
include: "rules/dbsnp.smk"
include: "rules/fastqc.smk"
include: "rules/fq2bam.smk"
include: "rules/haplotypecaller.smk"
include: "rules/mosdepth.smk"
include: "rules/prep_fq.smk"
include: "rules/trio_combine_gvcf.smk"
include: "rules/trio_filter_gvcf.smk"


rule all:
    input:
        unpack(get_results),
