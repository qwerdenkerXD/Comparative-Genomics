# view plots related to the given species
# no args -> all vs all species
# one arg -> arg vs all other species
# two args -> arg1 vs arg2

first=$(echo "$1" | sed "s/ /_/g")
second=$(echo "$2" | sed "s/ /_/g")
perl dagchainer/Java_XY_plotter/run_XYplot.pl \
    <(grep -P "$first.*$first.*$second|$second.*$second.*$first|$first.* vs\. .*$second|$second.* vs\. .*$first" ../Results/Syntheny_DAGchainer/all_vs_all.match_file.filtered.syntheny) \
    <(grep -P "$first.*$first.*$second|$second.*$second.*$first|$first.* vs\. .*$second|$second.* vs\. .*$first" ../Results/Syntheny_DAGchainer/all_vs_all.match_file.filtered.aligncoords) >/dev/null 2>&1