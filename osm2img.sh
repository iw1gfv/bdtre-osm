#! /bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"


# Verifica che sia presente mkgmap.jar per convertire in formato garmin i file OSM

if [[ ! -e $mkgmap ]]
then
  echo "Non trovo $mkgmap, assicurati di averlo scaricato o di"
  echo "aver seguito il percorso giusto"
  exit 2
fi

# Verifica che sia presente splitter.jar per convertire in formato garmin i file OSM
if [[ ! -e $splitter ]]
then
  echo "Non trovo $splitter, assicurati di averlo scaricato o di"
  echo "aver seguito il percorso giusto"
  exit 1
fi

#crea la cartella per i file IMG se non è già esistente
if [ -d $piemonteosm ]; then
    echo "$piemonteosm esiste."
else
    mkdir $piemonteosm
fi

#rimuove i file all'interno della cartella
rm $piemonteosm/*

cd $piemonteosm

#scarica il file OSM
wget $urlpiemonte

cd ..

#crea e converte le aree protette ed i parchi nazionali

java $Xmx -jar $splitter \
--max-nodes=1000000 \
--max-areas=300 \
--mapid=66139001 \
--output-dir=$piemonteosm \
$piemonteosm/piemonte.pbf


for infile in $piemonteosm/*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo converto $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
      --mapname=$MAPNAME \
      --description="OSM Aree protette" \
      --country-name="Italia" \
      --region-name="Piemonte" \
      --copyright-message="$copyrightosm" \
      --output-dir=$piemonteosm \
      --style-file=stile_garmin/osm_protette \
      --show-profiles=1 \
      --draw-priority=24 \
      --transparent \
      --license-file=stile_garmin/osm_licenza.txt \
      --remove-short-arcs \
      --keep-going \
      $infile 
  done

rm $piemonteosm/areas.*
rm $piemonteosm/densities-out.txt
rm $piemonteosm/temp*.*
rm $piemonteosm/*osm.pbf


#crea e converte le aree militari

java $Xmx -jar $splitter \
--max-nodes=1000000 \
--max-areas=300 \
--mapid=66140001 \
--output-dir=$piemonteosm \
$piemonteosm/piemonte.pbf


for infile in $piemonteosm/*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo converto $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
      --mapname=$MAPNAME \
      --description="OSM Aree militari" \
      --country-name="Italia" \
      --region-name="Piemonte" \
      --copyright-message="$copyrightosm" \
      --output-dir=$piemonteosm \
      --style-file=stile_garmin/osm_militari \
      --show-profiles=1 \
      --draw-priority=24 \
      --transparent \
      --license-file=stile_garmin/osm_licenza.txt \
      --remove-short-arcs \
      --keep-going \
      $infile 
  done

rm $piemonteosm/areas.*
rm $piemonteosm/densities-out.txt
rm $piemonteosm/temp*.*
rm $piemonteosm/*osm.pbf


#crea e converte le ferrovie

java $Xmx -jar $splitter \
--max-nodes=1000000 \
--max-areas=300 \
--mapid=66141001 \
--output-dir=$piemonteosm \
$piemonteosm/piemonte.pbf


for infile in $piemonteosm/*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo converto $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
      --mapname=$MAPNAME \
      --description="OSM Ferrovie" \
      --country-name="Italia" \
      --region-name="Piemonte" \
      --copyright-message="$copyrightosm" \
      --output-dir=$piemonteosm \
      --style-file=stile_garmin/osm_ferrovie \
      --show-profiles=1 \
      --draw-priority=24 \
      --transparent \
      --license-file=stile_garmin/osm_licenza.txt \
      --remove-short-arcs \
      --keep-going \
      $infile 
  done

rm $piemonteosm/areas.*
rm $piemonteosm/densities-out.txt
rm $piemonteosm/temp*.*
rm $piemonteosm/*osm.pbf


#crea e converte i poi

java $Xmx -jar $splitter \
--max-nodes=800000 \
--max-areas=300 \
--mapid=66142001 \
--output-dir=$piemonteosm \
$piemonteosm/piemonte.pbf


for infile in $piemonteosm/*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo converto $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
      --mapname=$MAPNAME \
      --description="OSM Poi" \
      --country-name="Italia" \
      --region-name="Piemonte" \
      --copyright-message="$copyrightosm" \
      --output-dir=$piemonteosm \
      --style-file=stile_garmin/osm_poi \
      --show-profiles=1 \
      --add-pois-to-areas \
      --draw-priority=24 \
      --transparent \
      --license-file=stile_garmin/osm_licenza.txt \
      --remove-short-arcs \
      --keep-going \
      --bounds=bounds \
      --location-autofill=is_in,nearest \
      $infile 
  done

rm $piemonteosm/areas.*
rm $piemonteosm/densities-out.txt
rm $piemonteosm/temp*.*
rm $piemonteosm/*osm.pbf


#crea e converte la viabilità

java $Xmx -jar $splitter \
--max-nodes=1600000 \
--max-areas=300 \
--mapid=66143001 \
--output-dir=$piemonteosm \
$piemonteosm/piemonte.pbf


for infile in $piemonteosm/*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo converto $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
      --mapname=$MAPNAME \
      --description="OSM Viabilità" \
      --country-name="Italia" \
      --region-name="Piemonte" \
      --copyright-message="$copyrightosm" \
      --output-dir=$piemonteosm \
      --style-file=stile_garmin/osm_viabilita \
      --show-profiles=1 \
      --draw-priority=24 \
      --transparent \
      --license-file=stile_garmin/osm_licenza.txt \
      --remove-short-arcs \
      --keep-going \
      --bounds=bounds \
      --location-autofill=is_in,nearest \
      $infile 
  done

rm $piemonteosm/areas.*
rm $piemonteosm/densities-out.txt
rm $piemonteosm/temp*.*
rm $piemonteosm/*osm.pbf


#crea e converte le energie rinnovabili

java $Xmx -jar $splitter \
--max-nodes=800000 \
--max-areas=300 \
--mapid=66144001 \
--output-dir=$piemonteosm \
$piemonteosm/piemonte.pbf


for infile in $piemonteosm/*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo converto $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
      --mapname=$MAPNAME \
      --description="OSM Energie" \
      --country-name="Italia" \
      --region-name="Piemonte" \
      --copyright-message="$copyrightosm" \
      --output-dir=$piemonteosm \
      --style-file=stile_garmin/osm_energie \
      --show-profiles=1 \
      --add-pois-to-areas \
      --draw-priority=24 \
      --transparent \
      --license-file=stile_garmin/osm_licenza.txt \
      --remove-short-arcs \
      --keep-going \
      $infile 
  done

rm $piemonteosm/areas.*
rm $piemonteosm/densities-out.txt
rm $piemonteosm/temp*.*
rm $piemonteosm/*osm.pbf
