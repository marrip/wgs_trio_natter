import pandas as pd
from snakemake.utils import validate
from snakemake.utils import min_version

min_version("5.22.0")

### Set and validate config file


configfile: "config.yaml"


validate(config, schema="../schemas/config.schema.yaml")

### Read and validate samples file

samples = pd.read_table(config["samples"]).set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

### Read and validate units file

units = pd.read_table(config["units"], dtype=str).set_index(
    ["sample", "unit"], drop=False
)
validate(units, schema="../schemas/units.schema.yaml")

### Read and validate pedigree file

pedigree = pd.read_table(config["pedigree"], dtype=str).set_index(
    ["trio"], drop=False
)
validate(pedigree, schema="../schemas/pedigree.schema.yaml")

### Set wildcard constraints


wildcard_constraints:
    sample="|".join(samples.index),
    unit="|".join(units["unit"]),


### Functions


def get_fastq(wildcards):
    fastqs = units.loc[(wildcards.sample, wildcards.unit), ["r1", "r2"]].dropna()
    return {"fwd": fastqs.r1, "rev": fastqs.r2}


def get_fastq_fwd(wildcards):
    return expand(
        "{sample}/fastp/{unit}_R1.fq.gz",
        sample=wildcards.sample,
        unit=units.loc[(wildcards.sample), ["unit"]].unit,
    )


def get_fastq_rev(wildcards):
    return expand(
        "{sample}/fastp/{unit}_R2.fq.gz",
        sample=wildcards.sample,
        unit=units.loc[(wildcards.sample), ["unit"]].unit,
    )


def get_gvcf_path(sample):
    return "/".join([sample, "dbsnp", sample + ".g.vcf.gz"])


def get_gvcf_trio(wildcards):
    trio = pedigree.loc[(wildcards.trio), ["p1", "p2", "p3"]].dropna()
    return {
        "gvcf1": get_gvcf_path(trio.p1),
        "gvcf1idx": get_gvcf_path(trio.p1) + ".tbi",
        "gvcf2": get_gvcf_path(trio.p2),
        "gvcf2idx": get_gvcf_path(trio.p2) + ".tbi",
        "gvcf3": get_gvcf_path(trio.p3),
        "gvcf3idx": get_gvcf_path(trio.p3) + ".tbi"
    }


def get_sample_results(samples, results):
    suffixes = {
        "mosdepth": [
            "mosdepth.global.dist.txt",
            "mosdepth.region.dist.txt",
            "mosdepth.summary.txt",
            "regions.bed.gz",
            "regions.bed.gz.csi",
        ],
        "haplotypecaller": [
            "variant_calling_detail_metrics",
            "variant_calling_summary_metrics",
        ],
    }
    for key in suffixes.keys():
        results = results + expand("{sample}/{tool}/{sample}.{suffix}", sample=samples, tool=key, suffix=suffixes[key])
    return results
    

def get_results(wildcards):
    results = expand("{trio}/trio_filter_gvcf/{trio}.g.vcf", trio=pedigree.index)
    results = results + expand("{sample}/fastqc", sample=samples.index)
    results = get_sample_results(samples.index,results)
    return results
