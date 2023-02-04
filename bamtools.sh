chmod#!/bin/bash
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
--joblog $LogsFolder/bamtools_paralelllog.txt \
conda install -c bioconda bamtools index \
-in $ResultsFolder/{Unit}Aligned.sortedByCoord.out.bam \
:::: $FastQFilesTable \
2>&1 | tee $LogsFolder/bamtools_consolelog.txt

