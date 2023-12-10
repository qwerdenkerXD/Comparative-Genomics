# Dies ist das Laborbuch der Übung im Modul Komparative Genomik

Was tragen wir hier ein?

Jeden Schritt, der Daten einliest und Daten verarbeitet und ein
(Zwischen)-Ergebnis produziert. Mit allen Parametern, mit der Version des Codes
(Skript), die den Schritt durchgeführt hat, und wo die Ausgabe zu finden ist.

## Material

Für unsere komparative Genomik der Bäckerhefe verwenden wir Genome von nahen
Verwandten:

- _S. cerevisiae_ - Bäckerhefe
- _E. gossypii_ - Schimmelpilz. Ein Pathogen bei Baumwolle und Zitrusfrüchten.
  wächst filamentös.
  Referenz-Genom: https://www.ncbi.nlm.nih.gov/datasets/taxonomy/284811/
- _K. lactis_ - Milchsäuregärung bei Kefir
- _N. clabratus_ - Symbiontischer Pilz des Menschen in den Schleimhäuten. Kann
  Krankheit bei Immunschwäche verursachen.
- _L. thermotolerans_ - Milchsäuregärung bei niedrigen und hohen Temperaturen.
  Kommt in natürlich fermentierten Lebensmitteln vor. Wird genannt im
  Zusammenhang mit Fruchtfliegen (nachlesen).
- _L. kluyveri_ - Verwandter der Bäckerhefe, fermentiert nur in klar anaeroben
  Bedingungen. Kommt vor in "slime flux" eine Erkrankung von Bäumen in Nordamerika
  und Europa.

### Download der Referenz-Genome

Siehe Skript `./Methods/download_genomes.sh`

- _S. cerevisiae_
- _E. gossypii_
- _K. lactis_
- _N. clabratus_
- _L. thermotolerans_
- _L. kluyveri_

Ausführung des Skripts am 20. November 2023
```sh
cd Methods
sbatch download_genomes.sh
```

## Methoden
Betriebssystem: Ubuntu 22.04.3 LTS

Tools:
 - prot-scriber: [0.1.4](https://github.com/usadellab/prot-scriber/releases/tag/v0.1.4)
 - HMMER: 3.3.1
 - openjdk: 18.0.2-ea
 - DAGchainer: [dbf9f2f](https://github.com/kullrich/dagchainer/commit/dbf9f2face659794ee5ceaa560356f81c137fef9)
 - OrthoFinder: [2.5.5](https://github.com/davidemms/OrthoFinder/archive/refs/tags/2.5.5.tar.gz)
 - slurm-wlm: 21.08.5
 - perl: 5.34.0
 - blastp: 2.14.0
 - python3: 3.10.12
 - conda: 23.3.1
 - augustus: 3.4.0
 - syri: 1.6.5
 - plotsr: 1.1.3
 - curl: 7.81.0
 - pip: 22.3.1
   - scipy: 1.11.4
   - numpy: 1.26.2
   - pysam: 0.22.0
   - pandas: 2.1.3
   - Cython: 3.0.6
   - python-igraph: 0.11.3
   - psutil: 5.9.6
   - setuptools: 59.6.0
   - matplotlib: 3.8.2
 - tar: 1.34
 - R: 4.3.2
   - Rscript: 4.3.2
   - venn: 1.11
     - admisc: 0.33
   - RColorBrewer: 1.1-3
   - wordcloud: 2.6
   - wordcloud2: 0.2.1
   - htmlwidgets: 1.6.3
   - webshot: 0.5.5
 - minimap2: 2.26-r1175

### Vorhersage der Gene
```sh
# setzt erfolgreich abgeschlossene Ausführung von download_genomes.sh voraus
cd Methods
sbatch predict_genes.sh
# predicted genes in ../Results/Prediction
```
Ausführung des Skripts am 20. November 2023

### Vergleich der vorhergesagten Gene mit denen aus den heruntergeladenen Daten
```sh
# setzt erfolgreich abgeschlossene Ausführung von predict_genes.sh voraus
cd Methods
bash compare_prediction_results.sh > ../Results/compare_prediction_results_out.txt
```
Ausführung des Skripts am 21. November 2023

### Qualitätscheck mit BUSCO
```sh
# setzt erfolgreich abgeschlossene Ausführung von predict_genes.sh voraus
cd Methods
sbatch busco.sh
# BUSCO output in ../Results/Busco
```
Ausführung des Skripts am 20. November 2023

#### Auslesen der BUSCO-Ergebnisse
```sh
# setzt erfolgreich abgeschlossene Ausführung von busco.sh voraus
cd Methods
bash busco_results.sh > ../Results/busco_results_out.txt
```
Ausführung des Skripts am 4. Dezember 2023

### Erkennen von Transposons mit EDTA
```sh
# setzt erfolgreich abgeschlossene Ausführung von download_genomes.sh voraus
cd Methods
sbatch detect_transposables.sh
# EDTA output in ../Results/Detected_Transposons
```
Ausführung des Skripts am 20. November 2023

#### Auswerten der EDTA-Ergebnisse
```sh
# setzt erfolgreich abgeschlossene Ausführung von detect_transposables.sh voraus
cd Methods
bash transposables_results.sh > ../Results/transposables_results_out.txt
```
Ausführung des Skripts am 4. Dezember 2023

### Erkennen von Genfamilien mit OrthoFinder
```sh
# setzt erfolgreich abgeschlossene Ausführung von predict_genes.sh voraus
cd Methods
# das Argument für das Skript ist der Pfad zu 'orthofinder.py' vom OrthoFinder tool
sbatch find_orthologous_genes.sh /media/BioNAS/KOGE_WS_23_24/Methods/OrthoFinder-2.5.5/orthofinder.py
# OrthoFinder results in ../Results/Orthologous_Genes
```
Ausführung des Skripts am 22. November 2023

#### Mit _Schizosaccharomyces osmophilus_ als Outgroup
```sh
# setzt erfolgreich abgeschlossene Ausführung von predict_genes.sh voraus
cd Methods
# das Argument für das Skript ist der Pfad zu 'orthofinder.py' vom OrthoFinder tool
sbatch find_orthologous_genes_with_outgroup.sh /media/BioNAS/KOGE_WS_23_24/Methods/OrthoFinder-2.5.5/orthofinder.py
# OrthoFinder results in ../Results/Orthologous_Genes_With_Outgroup
```
Ausführung des Skripts am 28. November 2023

#### Auswerten der OrthoFinder-Ergebnisse
```sh
# setzt erfolgreich abgeschlossene Ausführung von find_orthologous_genes.sh und find_orthologous_genes_with_outgroup.sh voraus
cd Methods
bash evaluate_detected_orthologs.sh > ../Results/evaluate_detected_orthologs_out.txt
```
Ausführung des Skripts am 4. Dezember 2023

### Synthenie-Analyse mit SyRi
```sh
# setzt erfolgreich abgeschlossene Ausführung von download_genomes.sh voraus
cd Methods
sbatch analyze_syntheny_syri.sh
# SyRi results in ../Results/Syntheny_SyRi with corresponding plot ../Results/syntheny_syri.png
```
Ausführung des Skripts am 10. Dezember 2023

### Annotieren der Proteome mit HMMER
#### Vorbereiten der Pfam Datenbank
```sh
# setzt voraus, dass Material/HMMER/Pfam-A.hmm existiert
cd Methods
sbatch hmmpress.sh
```
Ausführung des Skripts am 10. Dezember 2023

#### Annotation
```sh
# setzt erfolgreich abgeschlossene Ausführung von predict_genes.sh voraus
cd Methods
sbatch annotate_proteomes.sh
```
Ausführung des Skripts am 10. Dezember 2023

### Generieren verständlicher Sequenzbeschreibungen mit prot-scriber
#### Vorbereiten der TrEMBL Datenbank
```sh
# setzt voraus, dass Material/Diamond/uniprot_trembl.fasta existiert (database release 2023-11-08)
cd Methods
sbatch diamond_makedb.sh
```
Ausführung des Skripts am 10. Dezember 2023

#### Generierung der Beschreibungen
```sh
# setzt erfolgreich abgeschlossene Ausführung von predict_genes.sh voraus
cd Methods
sbatch prot_scriber.sh
```
Ausführung des Skripts am 10. Dezember 2023