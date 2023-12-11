out_path=../Results/Protscriber/Plots
mkdir "$out_path"
all_descriptions="$out_path/all_descriptions.tsv"
cat ../Results/Protscriber/*.protscriber.tsv | sort -u -k1,1 > "$all_descriptions"
OPENSSL_CONF=/dev/null Rscript prot-scriber-word-cloud.R "$all_descriptions" "../Results/protscriber.results"