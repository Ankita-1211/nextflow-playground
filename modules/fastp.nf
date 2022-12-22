process FASTP {

    tag "${sampleName}"
    publishDir "$params.output_dir/fastp", pattern: "*.html", mode: "copy"
    publishDir "$params.output_dir/trimmed_fastq", pattern: "*.gz", mode: "copy"
    
    output:
        tuple path(fwd_trim), path(rev_trim)
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
        -w $task.cpus --detect_adapter_for_pe \
        -W 4 -M 10 --cut_by_quality3 --length_required 15 \
        -i ${reads[0]} -I ${reads[1]} \
        -o $fwd_trim -O $rev_trim \
        -j $json_out \
        -h $html_out
        
        """

}

