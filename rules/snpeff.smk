rule snpeff:
    input:
        vcf="{trio}/trio_filter_vcf/{trio}.vcf",
        cfile=config["snpeff"]["cfile"],
    output:
        vcf="{trio}/snpeff/{trio}_annotated.vcf",
        html="{trio}/snpeff/{trio}_annotated.html",
    params:
        config["snpeff"]["db"],
    log:
        "logs/snpeff_{trio}.log",
    container:
        config["tools"]["snpeff"]
    message:
        "{rule}: Annotate trio vcf file with SnpEff"
    shell:
        "(java -jar /snpEff/snpEff.jar "
        "-v "
        "-c {input.cfile} "
        "-nodownload "
        "-canon "
        "-s {output.html} "
        "{params} "
        "{input.vcf} > {output.vcf}) &> {log}"
