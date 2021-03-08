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
