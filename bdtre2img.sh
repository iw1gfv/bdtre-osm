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

java $Xmx -jar $splitter \
--max-nodes=1600000 \
--max-areas=300 \
--mapid=66120001 \
--output-dir=../$BDTRE_IMG \
UNITO_cv_liv.osm

cd ..

cd $BDTRE_IMG

for infile in 66120*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
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
    --gmapsupp \
  $infile
done

rm areas.*
rm temp*.*


#divide e converte i punti quotati in formato IMG

cd ..

cd $uscitaosm

java $Xmx -jar $splitter \
--max-nodes=15000 \
--max-areas=50 \
--mapid=66121001 \
--output-dir=../$BDTRE_IMG \
UNITO_p_altim.osm

cd ..

cd $BDTRE_IMG

for infile in 66121*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE punti quotati" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --style-file=../stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=22 \
    --transparent \
    --license-file=../bdtre_licenza.txt \
  $infile
done

rm areas.*
rm temp*.*


#divide e converte gli edifici in formato IMG

cd $uscitaosm

java $Xmx -jar $splitter \
--max-nodes=1600000 \
--max-areas=300 \
--mapid=66122001 \
--output-dir=../$BDTRE_IMG \
UNITO_edifc.osm
UNITO_edi_min.osm

cd ..

cd $BDTRE_IMG

for infile in 66122*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Edifici" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --style-file=../stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=12 \
    --transparent \
    --license-file=../bdtre_licenza.txt \
    --gmapsupp \
  $infile
done

rm areas.*
rm temp*.*
