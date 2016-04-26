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

java $Xmx -jar $splitter \
--max-nodes=1600000 \
--max-areas=300 \
--mapid=66134001 \
--output-dir=$piemonteosm \
$piemonteosm/piemonte.pbf


for infile in $piemonteosm/*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo converto $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
      --mapname=$MAPNAME \
      --description="Dati OSM" \
      --country-name="Italia" \
      --region-name="Piemonte" \
      --copyright-message="$copyrightosm" \
      --output-dir=$piemonteosm \
      --style-file=stile_garmin/osm \
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
