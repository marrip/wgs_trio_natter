rule mosdepth:
    input:
        "{sample}/fq2bam/duplicates_marked.bam",
    output:
        "{sample}/mosdepth/{sample}.mosdepth.global.dist.txt",
        "{sample}/mosdepth/{sample}.mosdepth.region.dist.txt",
        "{sample}/mosdepth/{sample}.mosdepth.summary.txt",
        "{sample}/mosdepth/{sample}.regions.bed.gz",
        "{sample}/mosdepth/{sample}.regions.bed.gz.csi",
    log:
        "{sample}/mosdepth/mosdepth.log",
    container:
        config["tools"]["mosdepth"]
    threads: 40
    message:
        "{rule}: Calculating coverage using mosdepth"
    shell:
        "mosdepth "
        "-n "
        "-t {threads} "
        "--fast-mode "
        "--by 500 "
        "{wildcards.sample}/mosdepth/{wildcards.sample} "
        "{input} &> {log}"
