args <- commandArgs(trailingOnly = TRUE)

families <- read.table(args[1], sep="\t", header=TRUE)
families.rows <- families[, -1]
families.sizes <- apply(families.rows, 1, function(family) sum(family!=""))

png("../Results/gene_family_sizes.png", 1000, 1000)
families.sizes.dist <- table(families.sizes)
families.sizes.plot <- barplot(families.sizes.dist, ylim=c(0, max(families.sizes.dist) + 500), xlab="sizes", ylab="frequency", main="gene family sizes")
text(x = families.sizes.plot, y = families.sizes.dist, labels = families.sizes.dist, pos = 3, cex = 0.8, col = "red")
dev.off()

install.packages("venn")
library(venn)

# Convert the data to a list of vectors
data_list <- lapply(families.rows, function(x) unlist(strsplit(as.character(x), ", ")))

# Create the Venn diagram
png("../Results/gene_families_venn.png", 1000, 1000)
venn(data_list, zcolor = "style", box = FALSE)
dev.off()