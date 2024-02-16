#!/usr/bin/env nextflow

params.input_file = "/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/input/test.txt"
params.outdir = "/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/"
params.qc_outdir = "/home/achopra/BPA_Alt_Human/BPA/Fast_qc/"

/*
 * Process to download and convert SRA files to FASTQ format
 */
process DownloadAndConvertSRA {
    tag "$sra_id"

    input:
    val sra_id from Channel.fromPath(params.input_file).splitCsv().flatten()

    output:
    path "${params.outdir}/${sra_id}" into qc_input

    script:
    """
    mkdir -p ${params.outdir}/${sra_id}
    prefetch ${sra_id}
    fasterq-dump ${sra_id} -O ${params.outdir}/${sra_id} -e 4 --skip-technical
    """
}

/*
 * Process to perform FastQC quality check
 */
process QualityCheck {
    tag "$sra_id"

    input:
    path sra_dir from qc_input

    output:
    path "${params.qc_outdir}/${sra_id}" 

    script:
    def sra_id = sra_dir.getBaseName()
    """
    mkdir -p ${params.qc_outdir}/${sra_id}
    fastqc ${sra_dir}/${sra_id}.fastq --outdir ${params.qc_outdir}/${sra_id}
    """
}

workflow.onComplete {
    println("Pipeline completed successfully.")
}
