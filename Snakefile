include: "rules/common.smk"
include: "rules/fastqc.smk"
include: "rules/filter_vcf.smk"
include: "rules/fq2bam.smk"
include: "rules/genotype_gvcfs.smk"
include: "rules/haplotypecaller.smk"
include: "rules/manta.smk"
include: "rules/mosdepth.smk"
include: "rules/prep_fq.smk"
include: "rules/snpeff.smk"
include: "rules/tiddit.smk"
include: "rules/trio_combine_gvcf.smk"
include: "rules/trio_filter_vcf.smk"


rule all:
    input:
        unpack(get_results),
