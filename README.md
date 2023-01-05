### Nextflow Playground

This is self paced nextflow workflow learning repo. Its a baby steps towards gaining expertise in writing workflow in nextflow.

The toy example here is basic fastq stats workflow. The workflow takes the fastq reads files in paired & runs fastqc & fastp (trimming) & generates multiqc report using the fastqc results.

## How to run the pipeline

### Install nextflow :

Nextflow does not require any installation procedure, just download the distribution package by copying and pasting this command in your terminal:

```
curl -fsSL https://get.nextflow.io | bash

```

It creates the nextflow executable file in the current directory. You may want to move it to a folder accessible from your $PATH.

### Running the test pipeline
- By cloning the git repo in your local  & running the workflow

```
nextflow run main.nf --input_dir path_to_paired_end_fastq_files --output_dir path_to_output_directory

```

- Running directly from github repo

```
nextflow run https://github.com/Ankita-1211/nextflow-playground.git -r main  --input_dir path_to_paired_end_fastq_files --output_dir path_to_output_directory

```
