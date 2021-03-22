# WGS-Trio-Natter :snake:

Snakemake workflow to process WGS trio data from MGI instrument

## Dependencies

To run this analysis, a couple of dependencies need to be met:

- [parabricks](https://www.nvidia.com/en-us/docs/parabricks/quickstart-guide/software-overview/) ≥ v3.2.0.1
- python ≥ 3.8
- [snakemake](https://snakemake.readthedocs.io/en/stable/) ≥ 5.22.1
- [Singularity](https://sylabs.io/docs/) ≥ 3.7

## Required Reference Files

We are using resources from [Broad Institute](https://console.cloud.google.com/storage/browser/genomics-public-data/resources/broad/hg38/v0):

- `Homo_sapiens_assembly38.fasta` + bwa index, faidx and dict
- bgzipped version of `Homo_sapiens_assembly38.dbsnp138.vcf` + tabix
- `Homo_sapiens_assembly38.known_indels.vcf.gz` + tabix

## Usage

The workflow may be started doing something like this:

```
snakemake \
  -s Snakefile \
  --use-singularity \
  --singularity-args " --cleanenv --bind /Path/to/data/and/references"
```

Make sure to add the desired file paths to `config.yaml`, `sample.tsv`, `units.tsv` and `pedigree.tsv`.
