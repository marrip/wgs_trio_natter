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

pedigree = pd.read_table(config["pedigree"], dtype=str).set_index(["trio"], drop=False)
validate(pedigree, schema="../schemas/pedigree.schema.yaml")

### Set wildcard constraints


wildcard_constraints:
    sample="|".join(samples.index),
    unit="|".join(units["unit"]),


### Functions


def get_fastq(wildcards):
    fastqs = units.loc[(wildcards.sample), ["r1", "r2"]].dropna()
    return {"fwd": fastqs.r1, "rev": fastqs.r2}


def get_gvcf_path(sample):
    return "{sample}/haplotypecaller/{sample}.g.vcf.gz".format(sample=sample)


def get_gvcf_trio(wildcards):
    trio = pedigree.loc[(wildcards.trio), ["p1", "p2", "p3"]].dropna()
    return {
        "gvcf1": get_gvcf_path(trio.p1),
        "gvcf2": get_gvcf_path(trio.p2),
        "gvcf3": get_gvcf_path(trio.p3),
    }


def get_sample_results(samples, results):
    suffixes = {
        "haplotypecaller": [
            "panel.vcf",
            "variant_calling_detail_metrics",
            "variant_calling_summary_metrics",
        ],
        "manta": [
            "panel.vcf",
        ],
        "mosdepth": [
            "mosdepth.global.dist.txt",
            "mosdepth.region.dist.txt",
            "mosdepth.summary.txt",
            "regions.bed.gz",
            "regions.bed.gz.csi",
        ],
        "tiddit": [
            "panel.vcf",
        ],
    }
    for key in suffixes.keys():
        results = results + expand(
            "{sample}/{tool}/{sample}.{suffix}",
            sample=samples,
            tool=key,
            suffix=suffixes[key],
        )
    return results


def get_results(wildcards):
    results = expand("{trio}/snpeff/{trio}_annotated.{ext}", trio=pedigree.index, ext=["vcf", "html"])
    results = results + expand("{sample}/fastqc", sample=samples.index)
    results = get_sample_results(samples.index, results)
    return results
