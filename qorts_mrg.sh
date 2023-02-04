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

java -jar /home/ivashkin/hartleys-QoRTs-099881f/QoRTs.jar mergeAllCounts \
--noGzip \
/media/DATA1/ivashkin/bin/04.STAR/Results/OB_VIC \
/media/DATA1/ivashkin/bin/RNASeq_MSC_samples_decoder_lanes.tsv \
/media/DATA1/ivashkin/bin/04.STAR/Results/Counts

#chmod u=rwx,g=rwx,o=r-- /media/DATA1/ivashkin/bin/