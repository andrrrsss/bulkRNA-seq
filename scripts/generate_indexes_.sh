#!/bin/bash

##PBS -l select=2:ncpus=8:mem=40000m,place=scatter
##PBS -l walltime=02:01:00
##PBS -m n
#
##parallel="/mnt/storage/opt/shared/bioinf/parallel/bin/"
#export PATH=$PATH:/mnt/storage/opt/shared/bioinf/parallel/bin

#InfoFolder="/mnt/storage/home/aaivashkin/bin/fastq"
#TempFolder="/mnt/storage/home/aaivashkin/bin/04.STAR/TEMP"
#WorkingFolder="/mnt/storage/home/aaivashkin/bin/04.STAR/Working"
#ResultsFolder="/mnt/storage/home/aaivashkin/bin/04.STAR/Results"
#FastQProcessingFolder="/mnt/storage/home/aaivashkin/bin/fastqc/fastp"
#LogsFolder="/mnt/storage/home/aaivashkin/bin/LogsFolder"
#FastQFilesTable="/mnt/storage/home/aaivashkin/bin/cell"
#StarGenomeReference="/mnt/storage/home/aaivashkin/bin/Refseqstar"

#source /opt/shared/anaconda/anaconda3-2020/bin/activate
#conda activate aalobov

#Outputdir="/mnt/storage/home/aaivashkin/bin/fastqc"

#cd /mnt/storage/home/aaivashkin/bin/fastq
#
#paralleljobs=8

STAR --runThreadN 20 --runMode genomeGenerate --genomeDir /home/ivashkin/Stargenome_indexes \
--genomeFastaFiles /home/ivashkin/references/GRCh38.primary_assembly.genome.fa.gz \
--sjdbGTFfile  /home/ivashkin/gencode.v39.annotation.gtf.gz --sjdbOverhang 70
