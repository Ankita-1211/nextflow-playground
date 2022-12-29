include { FASTQC } from './modules/fastqc.nf' 
include { FASTP } from './modules/fastp.nf' 
include { MULTIQC } from './modules/multiqc.nf' 

log.info """\
         BASIC FASTQ FILE QC - N F   P I P E L I N E
         ============================================
         input_reads_path        : ${params.input_dir}
         output_dir              : ${params.output_dir}
         """
         .stripIndent()

workflow {
  
  reads_ch = Channel.fromFilePairs("$params.input_dir/*{1,2}.fastq.gz").dump(tag:'Input Reads')
  
  FASTP(reads_ch)
 
  fastqc_ch = FASTQC(reads_ch)
  
  MULTIQC(fastqc_ch)
  
}

workflow.onComplete {

    println ( workflow.success ? """
        Pipeline execution summary
        ---------------------------
        Completed at: ${workflow.complete}
        Duration    : ${workflow.duration}
        Success     : ${workflow.success}
        workDir     : ${workflow.workDir}
        exit status : ${workflow.exitStatus}
        """ : """
        Failed: ${workflow.errorReport}
        exit status : ${workflow.exitStatus}
        """
    )
}
