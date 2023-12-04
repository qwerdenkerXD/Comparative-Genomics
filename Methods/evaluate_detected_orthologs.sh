echo gene families: $(grep -c "^OG" ../Results/Orthologous_Genes/Results*/Orthogroups/Orthogroups.tsv)
echo

/usr/bin/Rscript evaluate_detected_orthologs.R ../Results/Orthologous_Genes/Results*/Orthogroups/Orthogroups.tsv > /dev/null
echo gene family plots written to:
echo     ../Results/gene_family_sizes.png
echo     ../Results/gene_families_venn.png
echo

python3 plot_species_tree.py "$(cat ../Results/Orthologous_Genes/Results*/Species_Tree/SpeciesTree_rooted_node_labels.txt)" ../Results/species_tree.png
python3 plot_species_tree.py "$(cat ../Results/Orthologous_Genes_With_Outgroup/Results*/Species_Tree/SpeciesTree_rooted_node_labels.txt)" ../Results/species_tree_with_outgroup.png
echo species trees written to:
echo     ../Results/species_tree.png
echo     ../Results/species_tree_with_outgroup.png