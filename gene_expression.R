suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(QoRTs))
suppressPackageStartupMessages(library(DESeq2))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(png))
suppressPackageStartupMessages(library(org.Hs.eg.db))
suppressPackageStartupMessages(library(rUtils))
suppressPackageStartupMessages(library(EnhancedVolcano))
suppressPackageStartupMessages(library(fgsea))
suppressPackageStartupMessages(library(BiocParallel))
suppressPackageStartupMessages(library(vidger))
suppressPackageStartupMessages(library(msigdbr))
suppressPackageStartupMessages(library("erer"))
#suppressPackageStartupMessages(library(cmapR))


working_directory <- "C:/User/andrey.ivashkin/Counts/Counts"
setwd(working_directory)
qortsqc_directory <- "Counts_all/"
decoder_lanes.file <- "RNASeq_MSC_samples_decoder_lanes_all.tsv"
decoder_DE.file <- "RNASeq_MSC_samples_decoder_DE_all.tsv"
qortsqc_counttables_directory <- "QORTS_all/"

#decoder_DE.file$unique

read.table(decoder_lanes.file)
read.table(decoder_DE.file)

res <- read.qc.results.data(qortsqc_directory, decoder.file = decoder_lanes.file, calc.DESeq2 = TRUE, calc.edgeR = TRUE)

print(res)

#makeMultiPlot.all(res, outfile.dir = "./")
#makeMultiPlot.basic(res, outfile.dir = "./", separatePlots = TRUE)

decoder_DE.bySample <- read.table(decoder_DE.file, header = T, stringsAsFactors = T)
analysis_name <- "All.48"
DE_name <- "Diff10dVSUndiff_OB"

DE_dir <- paste0(getwd(),"/",analysis_name,"/",DE_name,"/")
dir.create(DE_dir, showWarnings = TRUE, recursive = TRUE, mode = "0777")



DE.DE_name <- paste0("DE.",DE_name)
DE_table <- na.omit(data.table(decoder_DE.bySample), cols=DE.DE_name, invert=FALSE)

sampleFiles <- paste0(DE_table$sample, "/QC.geneCounts.formatted.for.DESeq.txt")

sampleCondition <- DE_table[, ..DE.DE_name][[1]]

sampleBatch <- DE_table$batch

sampleName <- DE_table$sample

sampleTable <- data.frame(sampleName = sampleName, fileName = sampleFiles, condition = sampleCondition)

dds <- DESeqDataSetFromHTSeqCount(sampleTable = sampleTable, directory = qortsqc_counttables_directory, design = ~condition)

dds <- estimateSizeFactors(dds)
#dds <-collapseReplicates(dds, DE_table$unique)

idx <- rowSums(counts(dds, normalized=TRUE) >= 5 ) >= 3

dds <- dds[idx,]
#dds <-collapseReplicates(dds, DE_table$tissue)
dds <- DESeq(dds)

#dds <- collapseReplicates(dds, DE_table$unique)

vsd <- varianceStabilizingTransformation(dds, blind=FALSE)

saveRDS(dds, file = paste0(DE_dir,DE_name,"_dds.rds"))

write.table(sampleTable, file = paste0(DE_dir,DE_name,"_samples_for_DE.tab"))

res <- data.frame(results(dds, format = "DataFrame"))
rownames(res) <- gsub("\\..*$","", rownames(res))

es <- ExpressionSet(counts(dds, normalized=T))

featureNames(es) <- gsub("\\..*$", "", featureNames(es))
head(fData(es))

es$condition <- sampleCondition
head(fData(es))

fData(es)$symbol <- mapIds(org.Hs.eg.db, sub("\\..*$", "", rownames(es)), "SYMBOL", "ENSEMBL")
fData(es)$entrez <- mapIds(org.Hs.eg.db, sub("\\..*$", "", rownames(es)), "ENTREZID", "ENSEMBL")
fData(es) <- merge(fData(es), res, by=0, all=T)
fData(es)$Row.names <- NULL

head(fData(es))

write.gct(es, paste0(DE_dir,DE_name,".gct"))
#write.csv(es@featureData@data,"ES.csv")

scatter <- vsScatterPlot(
  x = levels(as.factor(dds$condition))[1], y = levels(as.factor(dds$condition))[2], 
  data = dds, type = 'deseq', d.factor = 'condition', 
  title = TRUE, grid = TRUE)

png(filename=paste0(DE_dir,DE_name,"_scatter.png"), width = 800, height = 800)
plot(scatter)
dev.off()

PCA <- plotPCA(vsd, "condition") + geom_text(aes(label=''),vjust=2)
png(filename=paste0(DE_dir,DE_name,"_pca.png"), width = 800, height = 600)
plot(PCA)
dev.off()

res <- results(dds)
res$symbol <- mapIds(org.Hs.eg.db, sub("\\..*$", "", rownames(res)), "SYMBOL", "ENSEMBL")

Volk <-   EnhancedVolcano(res,
                          title = DE_name,
                          lab = res$symbol,
                          x = 'log2FoldChange',
                          y = 'pvalue',
                          xlim = c(-9,9),
                          xlab = bquote(~Log[2]~ 'fold change'),
                          pCutoff = 0.05,
                          FCcutoff = 1.5)

png(filename=paste0(DE_dir,DE_name,"_Volkanoplot.png"), width = 800, height = 800)
plot(Volk)  
dev.off()

res <- data.table(as.data.frame(results(dds)), keep.rownames = T)
res[, ensgene := gsub("\\..*$", "", rn)]
res[, symbol := mapIds(org.Hs.eg.db, ensgene, "SYMBOL", "ENSEMBL")]
res <- res[order(stat),]
head(res)


expression <- res[,c("symbol", "stat")]
expression <- expression[!duplicated(expression$symbol),]
expression <- subset(expression, symbol!= "<NA>")
head(expression)

ranks <- setNames(expression$stat, expression$symbol)
head(ranks)

write.csv(expression,"expression.csv")
write.csv(res,"res.csv")
write.csv(es@featureData@data,"es_featureData_data.csv")
write.csv(ranks,"ranks.csv")

