#!/bin/bash
ulimit -n 100000

conda activate salmon

paralleljobs=4

ResultsFolder="/media/DATA1/ivashkin/bin/04.STAR/Results/STAR_Transcriptome/"
LogsFolder="/media/DATA1/ivashkin/bin/04.STAR/Results/Logs"
TempFolder="/media/DATA1/ivashkin/bin/04.STAR/TEMP"
FastQFilesTable="/media/DATA1/ivashkin/bin/Sample_all_full.tsv"
WorkingFolder="/media/DATA1/ivashkin/bin/04.STAR/Working"
FastQProcessingFolder="/media/DATA1/ivashkin/bin/04.STAR/Working/FastQProcessing"
StarGenomeReference="/media/DATA1/ivashkin/bin/Stargenome_indexes"

parallel --lb --jobs $paralleljobs --plus --header : --colsep '\t' --verbose \
--joblog $LogsFolder/SALMON_paralelllog.txt salmon quant \
-t FastQProcessingFolder/{Unit}.filtered.R1.fastq.gz \
-l A \
-a $ResultsFolder/{Unit}Aligned.toTranscriptome.out.bam \
-o salmon_quant $ResultsFolder/SALMON/ \
--threads 12 \
--fldMean 73 \
:::: $FastQFilesTable \
2>&1 | tee $LogsFolder/SALMON_consolelog.txt

grep "^>" <(gunzip -c Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz) | cut -d " " -f 1 > decoys.txt sed -i.bak -e 's/>//g' decoys.txt

grep "^>" <(gunzip -c Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz) | cut -d " " -f 1 > decoys.txt

cat gencode.v39.transcripts.fa.gz Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz > gentrome.fa.gz

salmon index -t gentrome.fa.gz -d decoys.txt -p 12 -i salmon_index --gencode