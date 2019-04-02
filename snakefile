configfile:
    "config.json"

# SAMPLES, = glob_wildcards(config['data']+"/{id}.fastq.gz")


rule trim:
	dir:
		config['trimmed_data']
	input:
		config['raw_data']+"/{sample}_R1_001.fastq.gz",
		config['raw_data']+"/{sample}_R2_001.fastq.gz"
	shell:
		"cd {dir} && trim_galore {input} --paired --retain_unpaired -q 20 --fastqc

		
rule star:
    input:
        config['data']+"/{sample}_L001_R1_001.fastq.gz",
        config['data']+"/{sample}_L001_R2_001.fastq.gz"
    output:
        temp("{sample}.mapped.bam")
    params:
        rg = "@RG\\tID:{sample}\\tPL:ILLUMINA\\tSM:{sample}",
        ref = config['genome']
    conda:
        "envs.yaml"
    shell:
        "bwa mem -R '{params.rg}' -M {params.ref} {input} | samtools sort -o {output} -"
	
	
