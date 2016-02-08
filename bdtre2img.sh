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
rm -r $BDTRE_IMG/*


#divide e converte le curve di livello in formato IMG

java $Xmx -jar $splitter \
--max-nodes=1600000 \
--max-areas=300 \
--mapid=66120001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_l_altim.pbf


for infile in $BDTRE_IMG/66120*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Curve di livello" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=12 \
    --transparent \
    --license-file=bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/66*.osm.pbf


#divide e converte i punti quotati in formato IMG

java $Xmx -jar $splitter \
--max-nodes=15000 \
--max-areas=300 \
--mapid=66121001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_p_altim.pbf


for infile in $BDTRE_IMG/66121*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Punti quotati" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=20 \
    --transparent \
    --license-file=bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/66*.osm.pbf


#divide e converte gli edifici in formato IMG

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_edifc.pbf --rbf file=$uscitaosm/UNITO_edi_min.pbf --merge --wb file=$uscitaosm/UNITO_edifici.pbf omitmetadata=true

java $Xmx -jar $splitter \
--max-nodes=1600000 \
--max-areas=300 \
--mapid=66122001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_edifici.pbf


for infile in $BDTRE_IMG/66122*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Edifici" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=10 \
    --transparent \
    --license-file=bdtre_licenza.txt \
  $infile
done

rm $uscitaosm/UNITO_edifici.pbf
rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/66*.osm.pbf


#divide e converte gli alberi isolati in formato IMG

java $Xmx -jar $splitter \
--max-nodes=15000 \
--max-areas=300 \
--mapid=66123001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_albero.pbf


for infile in $BDTRE_IMG/66123*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Albero isolato" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=20 \
    --transparent \
    --license-file=bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/66*.osm.pbf


#divide e converte il bosco in formato IMG

java $Xmx -jar $splitter \
--max-nodes=1600000 \
--max-areas=300 \
--mapid=66124001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_bosco.pbf


for infile in $BDTRE_IMG/66124*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Bosco" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=10 \
    --transparent \
    --license-file=bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/66*.osm.pbf
