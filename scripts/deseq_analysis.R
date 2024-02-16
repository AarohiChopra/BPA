library(DESeq2)
library(ggplot2)

# Load the count data, correct the variable name to match the print statement
countsData <- as.matrix(read.table("/home/achopra/BPA_Alt_Human/BPA/Feature_counts/combined_feature_counts.txt", header = TRUE, row.names = 1, sep = "\t", skip = 1, check.names = FALSE))

# Print the first few rows of countsData to verify it's loaded correctly
print(head(countsData))

# Read sample names directly, assuming they match the order of columns in countsData
sample_names <- readLines("/home/achopra/BPA_Alt_Human/BPA/Fastq_dump/input/test.txt")

# Extract sample names from countsData column names, assuming they are paths and sample names are at the end
#sample_names_from_counts <- gsub(".*/([^/]+)\\.bam$", "\\1", colnames(countsData)[-(1:6)])
sample_names_from_counts <- colnames(countsData)[-(1:6)]

# Verify extracted sample names
print(sample_names_from_counts)
print(length(sample_names_from_counts))

# Define the conditions for each sample, ensure this matches the order of columns in countsData
sample_conditions <- c("DMSO 0.1% [0]", "Pergafast 201 [10]", "Bisphenol S [10]", "BPS-MAE [0.5]", "2,4-BPF (BPF Analog) [0.5]", "BPS-MAE [0.0005]")
print(sample_conditions)

# Create the colData dataframe with conditions, correcting the variable to 'sample_conditions'
colData <- DataFrame(condition = factor(sample_conditions))
rownames(colData) <- sample_names_from_counts

# Check if the samples in colData match the column names in countsData
if (!all(rownames(colData) %in% colnames(countsData)[-(1:6)])) {
  print(colnames(countsData)[-(1:6)])
  print(rownames(colData))
  stop("Sample names in colData do not match the column names in countsData.")
}

# Proceed with DESeq2 analysis, ensuring to use 'countsData' correctly and specifying the design formula appropriately
dds <- DESeqDataSetFromMatrix(countData = countsData[, -(1:6)], colData = colData, design = ~ condition)
dds <- DESeq(dds)

# Example: Save results
res <- results(dds)
write.csv(as.data.frame(res), file="/home/achopra/BPA_Alt_Human/BPA/DESeq2_results.csv")

# Other analyses and plots can follow
