#!/bin/bash -l

# name
#SBATCH --job-name=analyze_syntheny_dagchainer

# cpu
#SBATCH --ntasks=10

#SBATCH --mem-per-cpu=10GB

#SBATCH --output=./logs/%x_%j_slurm.out
#SBATCH --error=./logs/%x_%j_slurm.err

out_path=../Results/Syntheny_DAGchainer
mkdir $out_path
cd $out_path

for file in ../Prediction/*.faa
do
    combined+="$(sed "s/^>/>$(basename "${file%.*}")./; s/ /_/g" "$file")
"
done
query="combined.faa"
echo "$combined" > "$query"

diamond makedb --db "$query"

blast_result="all_vs_all.match_file"
                                                        # later, output will be changed to: chr_id seqid  end  start  chr_id seqid  end  start  evalue
diamond blastp --threads 10 --query "$query" --db "$query" --out "$blast_result" --outfmt 6 sstart qseqid qend qstart sstart sseqid send sstart evalue

for file in ../Prediction/*.gff
do
    filebase="$(basename "${file%.*}")"
    echo "$filebase"
    awk -v filebase="$filebase" -v blast_result="$blast_result" '
    BEGIN { FS=OFS="\t" }
    $3 == "transcript" {
        gsub(/ /, "_", filebase)
        id = $9
        gff[filebase"."id"chr"] = filebase"."$1
        gff[filebase"."id"end"] = $5 
        gff[filebase"."id"start"] = $4
    }
    END {
        while ((getline line < blast_result) > 0) {
            len=split(line, fields, "\t")
            id = fields[2]
            if (id"chr" in gff) {
                fields[1] = gff[id"chr"]
                fields[3] = gff[id"end"]
                fields[4] = gff[id"start"]
            }
            id = fields[6]
            if (id"chr" in gff) {
                fields[5] = gff[id"chr"]
                fields[7] = gff[id"end"]
                fields[8] = gff[id"start"]
            }
            new_line = fields[1]
            for (i=2; i <= 9; i++) {
                new_line = new_line "\t" fields[i]
            }
            print new_line > blast_result ".tmp"
        }
        close(blast_result)
        system("mv " blast_result ".tmp " blast_result)
    }' "$file"
done

dagchainer=../../Methods/dagchainer
dagchainer_in="${blast_result}.filtered"


# see https://dagchainer.sourceforge.net/
perl "$dagchainer/accessory_scripts/filter_repetitive_matches.pl" 5 < "$blast_result" > "$dagchainer_in"

perl "$dagchainer/run_DAG_chainer.pl" -i "$dagchainer_in"

perl "$dagchainer/accessory_scripts/extract_only_chromo_pairs_with_dups.pl" "$dagchainer_in" "${dagchainer_in}.aligncoords" > "${dagchainer_in}.syntheny"