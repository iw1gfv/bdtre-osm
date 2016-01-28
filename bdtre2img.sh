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


#verifica che sia presente la cartella con i file del BDTRE convertiti in OSM
if [[ ! -d $uscitaosm ]]
then
  echo "Non esiste la cartella $uscitaosm, fai girare lo script shpaosm.sh e uniscibdtre.sh prima di questo"
  exit 1
fi


#crea la cartella per i file IMG se non è già esistente
if [ -d $BDTRE_IMG ]; then
    echo "$BDTRE_IMG esiste."
else
    mkdir $BDTRE_IMG
fi

#cancella i file nella directory
rm $BDTRE_IMG/*


#divide e converte le curve di livello in formato IMG

cd $uscitaosm

java -Xmx3000m -jar $splitter \
--max-nodes=1600000 \
--max-areas=200 \
--mapid=66121001 \
--output-dir=../$BDTRE_IMG \
UNITO_cv_liv.osm

cd ..

cd $BDTRE_IMG

for infile in *.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java -Xmx3000M -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Piemonte curve di livello" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --style-file=../stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=12 \
    --transparent \
    --license-file=../bdtre_licenza.txt \
  $infile
done

rm *.osm.pbf
