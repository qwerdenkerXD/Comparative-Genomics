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
 - slurm-wlm: 21.08.5
 - augustus: 3.4.0
 - conda: 23.3.1

### Vorhersage der Gene
```sh
cd Methods
sbatch predict_genes.sh
```
Ausführung des Skripts am 20. November 2023

### Vergleich der vorhergesagten Gene mit denen aus den heruntergeladenen Daten
```sh
cd Methods
bash compare_prediction_results.sh
```

### Qualitätscheck mit BUSCO
```sh
cd Methods
sbatch busco.sh
```
Ausführung des Skripts am 20. November 2023