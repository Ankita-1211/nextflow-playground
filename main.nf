process FASTQC {

    tag "${sampleName}"
    cpus 10
    
    publishDir "result/fastqc", mode: "copy"
    // this line is making the output folder & saving the results.

    input:
        tuple val(sampleName), path(reads)

    output:
        //path('*html')
        //path('*zip')
        //this line is just getting the html output via publishDir
        path("*"), emit: fastqc_html_ch

    script:

        """
        fastqc -t $task.cpus $reads
        
        """

}


process FASTP {

    tag "${sampleName}"
    publishDir "result/fastp", pattern: "*.html", mode: "copy"
    publishDir "result/trimmed", pattern: "*.gz", mode: "copy"
    
    output:
        tuple path(fwd_trim), path(rev_trim)
        //tuple path('*html'), path('*json')
        //tuple path(fwd_trim), path(rev_trim), emit: fastp_ch
        path('*html'), emit: fastp_html_ch
    
    input:
        tuple val(sampleName), file(reads)

    script:
    
        fwd_trim = sampleName + '_trimmed_R1.fastq.gz'
        rev_trim = sampleName + '_trimmed_R2.fastq.gz'
        json_out = sampleName + '.json'
        html_out = sampleName + '.html'

        """
        
        fastp \
        -w 16 --detect_adapter_for_pe \
        -W 4 -M 10 --cut_by_quality3 --length_required 15 \
        -i ${reads[0]} -I ${reads[1]} \
        -o $fwd_trim -O $rev_trim \
        -j $json_out \
        -h $html_out
        
        """

}

process multiqc {
    publishDir "result/multiqc", mode:'copy'
       
    input:
    path (inputfiles)
    
    output:
    path 'multiqc_report.html'
     
    script:
    """
    multiqc . 
    """
} 


log.info """\
         BASIC FASTQ FILE QC - N F   P I P E L I N E
         ===================================
         reads        : ${params.input_dir}
         """
         .stripIndent()

workflow {
  
  reads_ch = Channel.fromFilePairs("$params.input_dir/*{1,2}.fastq.gz")
  
  FASTP(reads_ch)
 
  fastqc_ch = FASTQC(reads_ch)
  
  multiqc(fastqc_ch)
  
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


