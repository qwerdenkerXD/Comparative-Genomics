out=../Results/evaluate_annotated_proteomes_out.txt
echo "" > $out

merge_results="column -t -s $'\t' -o ' | ' -N \""

for file in ../Results/Annotated_Proteomes/*.tsv
do
    grouped_annotations_by_count=$(cut -d ' ' -f1,1 "$file" | sort | sed "/^#/d" | uniq -c | sort -nr | head -25)
    species_table=$(echo "$grouped_annotations_by_count" | sed "s/^ *//" | awk '{ print $2 " " $1 }' | column -t -N annotation,occurency)

    echo "$(echo "$species_table" | paste -d $'\t' $out -)" > $out

    merge_results+="$(basename "${file%.*}"),"
done

sed -i "s/^\t//" $out
echo "$(eval "${merge_results%,}\" $out")" > $out
