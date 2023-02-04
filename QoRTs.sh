
#!/bin/bash
ulimit -n 100000

paralleljobs=20

ResultsFolder="/media/DATA1/ivashkin/bin/04.STAR/Results"
LogsFolder="/media/DATA1/ivashkin/bin/04.STAR/Results/Logs"
TempFolder="/media/DATA1/ivashkin/bin/04.STAR/TEMP"
FastQFilesTable="/media/DATA1/ivashkin/bin/Sample_all.tsv"
WorkingFolder="/media/DATA1/ivashkin/bin/04.STAR/Working"
FastQProcessingFolder="/media/DATA1/ivashkin/bin/04.STAR/Working/FastQProcessing"
StarGenomeReference="/media/DATA1/ivashkin/bin/Stargenome_indexes"


parallel --lb --jobs $paralleljobs --plus --header : --colsep '\t' --verbose \
--joblog $LogsFolder/QORTS_paralelllog.txt  \
java -Xmx10G -jar /home/ivashkin/hartleys-QoRTs-099881f/QoRTs.jar QC \
--singleEnded \
--stranded \
--maxReadLength 73 \
--generateMultiPlot \
--noGzipOutput \
--verbose \
$ResultsFolder/{Unit}Aligned.sortedByCoord.out.bam \
/media/DATA1/ivashkin/bin/references/gencode.v39.annotation.gtf \
$ResultsFolder/{Unit}/ \
:::: $FastQFilesTable \
2>&1 | tee $LogsFolder/QORTS_consolelog.txt