#!/bin/bash

#PBS -l select=2:ncpus=8:mem=40000m,place=scatter
#PBS -l walltime=02:01:00
#PBS -m n

parallel="/mnt/storage/opt/shared/bioinf/parallel/bin/"
export PATH=$PATH:/mnt/storage/opt/shared/bioinf/parallel/bin

InfoFolder="/mnt/storage/home/aaivashkin/bin/fastq"
TempFolder="/mnt/storage/home/aaivashkin/bin/04.STAR/TEMP"
WorkingFolder="/mnt/storage/home/aaivashkin/bin/04.STAR/Working"
ResultsFolder="/mnt/storage/home/aaivashkin/bin/04.STAR/Results"
FastQProcessingFolder="/mnt/storage/home/aaivashkin/bin/fastqc/fastp"
LogsFolder="/mnt/storage/home/aaivashkin/bin/LogsFolder"
FastQFilesTable="/mnt/storage/home/aaivashkin/bin/cell"
StarGenomeReference="/mnt/storage/home/aaivashkin/bin/Refseqstar"


fastqc="/home/software/FastQC/fastqc"
fastp="/home/software/fastp"
star="/home/software/STAR-2.7.0a/bin/Linux_x86_64_static/STAR"
qorts="/home/software/hartleys-QoRTs-099881f/QoRTs.jar"

paralleljobs=2



#FastQFilesTable="/home/genomicdata/CalcRNASeq/Star_decoder/UnitsRNASeqNotch.tab"
FastQFilesTable="$HOME/04.STAR/UnitsRNASeqNotch.tab"

mkdir -p $ResultsFolder
mkdir -p $WorkingFolder
rm -rf $TempFolder
mkdir -p $TempFolder

LogsFolder=$ResultsFolder/Logs
QCFolder=$ResultsFolder/QC
FastQProcessingFolder=$WorkingFolder/FastQProcessing
BAMProcessingFolder=$WorkingFolder/BAMProcessing

mkdir -p $LogsFolder
mkdir -p $QCFolder
mkdir -p $FastQProcessingFolder
mkdir -p $BAMProcessingFolder


cd $InfoFolder

#parallel --lb --jobs 40 --plus --quote --header : --colsep '\t' --verbose \
#--joblog $LogsFolder/paralelllog_FastQCLanes.txt \
#$fastqc {Read1} --outdir=$FastQProcessingFolder \
#:::: $FastQFilesTable \
#2>&1 | tee $LogsFolder/consolelog_FastQCLanes.txt

#parallel --lb --jobs $paralleljobs --plus --header : --colsep '\t' --verbose \
#--joblog $LogsFolder/FastQfiltering_paralelllog.txt $
#-i {Read1} \
#-o $FastQProcessingFolder/{Unit}.filtered.R1.fastq.gz \
#--json $FastQProcessingFolder/{Unit}.fastp.json \
#--html $FastQProcessingFolder/{Unit}.fastp.html \
#:::: $FastQFilesTable \
#2>&1 | tee $LogsFolder/FastQfiltering_consolelog.txt

#multiqc -f --data-dir $FastQProcessingFolder --filename $QCFolder/FastQ_QCreport

pwd

#parallel --lb --jobs $paralleljobs --plus --header : --colsep '\t' --verbose \
#--joblog $LogsFolder/STAR_paralelllog.txt $star \
#--outTmpDir $TempFolder/{Unit}/ \
#--readFilesCommand zcat \
#--readFilesIn $FastQProcessingFolder/{Unit}.filtered.R1.fastq.gz \
#--genomeDir $StarGenomeReference \
#--runThreadN 4 \
#--outFilterMultimapNmax 15 \
#--outFilterMismatchNmax 6 \
#--limitBAMsortRAM 10000000000 \
#--outSAMstrandField intronMotif \
#--outSAMtype BAM SortedByCoordinate \
#--outFileNamePrefix $ResultsFolder/{Unit} \
#:::: $FastQFilesTable \
#2>&1 | tee $LogsFolder/STAR_consolelog.txt

STAR --genomeLoad Remove \
--genomeDir $StarGenomeReference \

#parallel --lb --jobs $paralleljobs --plus --header : --colsep '\t' --verbose \
#--joblog $LogsFolder/bamtools_paralelllog.txt \
#conda install -c bioconda bamtools index \
#-in $ResultsFolder/{Unit}Aligned.sortedByCoord.out.bam \
#:::: $FastQFilesTable \
#2>&1 | tee $LogsFolder/bamtools_consolelog.txt


#parallel --lb --jobs $paralleljobs --plus --header : --colsep '\t' --verbose \
#--joblog $LogsFolder/QORTS_paralelllog.txt  \
#java -Xmx10G -jar  QC \
#--singleEnded \
#--stranded \
#--maxReadLength 76 \
#--generateMultiPlot \
#--noGzipOutput \
#--verbose \
#$ResultsFolder/{Unit}Aligned.sortedByCoord.out.bam \
#/home/references/gencode.v31.annotation.gtf \
#$ResultsFolder/{Unit}/ \
#:::: $FastQFilesTable \
#2>&1 | tee $LogsFolder/QORTS_consolelog.txt

#mkdir - p /home/student1/04.STAR/countTables/

#rm -R -- */

#java -jar $qorts mergeAllCounts \
#--noGzip \
#/home/student1/04.STAR/Results/ \
#/home/student1/04.STAR/RNASeqNotch_samples_decoder_lanes.tab \
#/home/student1/04.STAR/countTables/
