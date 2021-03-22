rule genotype_gvcfs:
    input:
        gvcf="{trio}/trio_combine_gvcf/{trio}.g.vcf",
        ref=config["reference"]["fasta"],
    output:
        "{trio}/genotype_gvcfs/{trio}.vcf.gz",
    log:
        "{trio}/genotype_gvcfs/genotype_gvcfs.log",
    container:
        config["tools"]["gatk"]
    message:
        "{rule}: Joint genotyping on gvcfs"
    shell:
       "gatk GenotypeGVCFs "
       "-R {input.ref} "
       "-V {input.gvcf} "
       "-O {output} &> {log}"
