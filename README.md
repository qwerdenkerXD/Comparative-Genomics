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
 - OrthoFinder: [2.5.5](https://github.com/davidemms/OrthoFinder/archive/refs/tags/2.5.5.tar.gz)
 - slurm-wlm: 21.08.5
 - python3: 3.10.12
 - augustus: 3.4.0
 - conda: 23.3.1
 - scipy: 1.11.4
 - numpy: 1.26.2
 - curl: 7.81.0
 - pip: 22.0.2
 - tar: 1.34

### Vorhersage der Gene
```sh
# setzt erfolgreich abgeschlossene Ausführung von download_genomes.sh voraus
cd Methods
sbatch predict_genes.sh
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
```
Ausführung des Skripts am 22. November 2023

#### Mit _Schizosaccharomyces osmophilus_ als Outgroup
```sh
# setzt erfolgreich abgeschlossene Ausführung von predict_genes.sh voraus
cd Methods
# das Argument für das Skript ist der Pfad zu 'orthofinder.py' vom OrthoFinder tool
sbatch find_orthologous_genes_with_outgroup.sh /media/BioNAS/KOGE_WS_23_24/Methods/OrthoFinder-2.5.5/orthofinder.py
```
Ausführung des Skripts am 28. November 2023

#### Auswerten der OrthoFinder-Ergebnisse
```sh
# setzt erfolgreich abgeschlossene Ausführung von find_orthologous_genes.sh und find_orthologous_genes_with_outgroup.sh voraus
cd Methods
bash evaluate_detected_orthologs.sh > ../Results/evaluate_detected_orthologs_out.txt
```
Ausführung des Skripts am 4. Dezember 2023