# bulkRNA-seq
bulkRNA-seq data analysis  from fastq to counts.

This repository contain .sh and .r scripts for large numbers of samples analysis using GNU Parallel. 

### Steps:

1. Quality control and adaters trimming by FastQC, MultiQC, fastp
2. Building a genome index - STAR
3. Mapping - STAR,  pseudoalignment - SALMON
4. Summury statistics, counting and samples merging - QoRTs 
5. Gene expession analysis - DESeq2



