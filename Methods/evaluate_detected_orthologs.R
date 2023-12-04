args <- commandArgs(trailingOnly = TRUE)

families <- read.table(args[1], sep="\t", header=TRUE)
families.species <- families[, -1]  # without the Orthogroup name column: "OG00..."
families.sizes <- apply(families.species, 1, function(family) sum(length(unlist(strsplit(as.character(family), ", ")))))

png("../Results/gene_family_sizes.png", 1000, 1000)
families.sizes.dist <- table(families.sizes)
families.sizes.plot <- barplot(families.sizes.dist, ylim=c(0, max(families.sizes.dist) + 500), xlab="size", ylab="frequency", main="gene family sizes")
text(x = families.sizes.plot, y = families.sizes.dist, labels = families.sizes.dist, pos = 3, cex = 0.8, col = "red")
dev.off()

install.packages("venn")
library(venn)

# create an associative list {species_name: [gene_family_index, ...], ...} -> all species are associated to
# a vector of the indices of the gene families they are related to (starting from 1), or NA if not related
data_list <- lapply(families.species, function(x) ifelse(x != "", seq_along(x), NA))

# create the venn diagram -> the species group together if they share the index of a gene family
# -> because they share the NA for non-related families, there is one mismatch in the final diagram
png("../Results/gene_families_venn.png", 1000, 1000)
venn(data_list, zcolor = "style", box = FALSE)
dev.off()