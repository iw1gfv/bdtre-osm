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
$uscitaosm/UNITO_cv_liv.pbf


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
    --draw-priority=18 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte i punti quotati in formato IMG

java $Xmx -jar $splitter \
--max-nodes=15000 \
--max-areas=300 \
--mapid=66121001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_pt_quo.pbf


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
    --draw-priority=21 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


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
    --draw-priority=17 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $uscitaosm/UNITO_edifici.pbf
rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte gli alberi isolati in formato IMG

java $Xmx -jar $splitter \
--max-nodes=20000 \
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
    --draw-priority=22 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


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
    --draw-priority=11 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte l'invaso  e sp_acq in formato IMG

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_invaso.pbf --rbf file=$uscitaosm/UNITO_sp_acq.pbf --merge --wb file=$uscitaosm/UNITO_laghi.pbf omitmetadata=true

java $Xmx -jar $splitter \
--max-nodes=30000 \
--max-areas=200 \
--mapid=66125001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_laghi.pbf


for infile in $BDTRE_IMG/66125*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Laghi" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=13 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $uscitaosm/UNITO_laghi.pbf
rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte i canali in formato IMG

java $Xmx -jar $splitter \
--max-nodes=200000 \
--max-areas=300 \
--mapid=66126001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_el_idr.pbf


for infile in $BDTRE_IMG/66126*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Canali" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=19 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte i fiumi in formato IMG

java $Xmx -jar $splitter \
--max-nodes=300000 \
--max-areas=300 \
--mapid=66127001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_ab_cda.pbf


for infile in $BDTRE_IMG/66127*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Fiumi" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=14 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte i sentieri in formato IMG

java $Xmx -jar $splitter \
--max-nodes=500000 \
--max-areas=300 \
--mapid=66128001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_ar_vms.pbf


for infile in $BDTRE_IMG/66128*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Sentieri" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=16 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte le strade in formato IMG

java $Xmx -jar $splitter \
--max-nodes=1600000 \
--max-areas=300 \
--mapid=66129001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_ac_vei.pbf


for infile in $BDTRE_IMG/66129*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Strade" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=15 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte i tralicci e le linee elettriche in formato IMG

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_tralic.pbf --rbf file=$uscitaosm/UNITO_tr_ele.pbf --merge --wb file=$uscitaosm/UNITO_elettrico.pbf omitmetadata=true

java $Xmx -jar $splitter \
--max-nodes=20000 \
--max-areas=300 \
--mapid=66130001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_elettrico.pbf


for infile in $BDTRE_IMG/66130*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Linee elettriche" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=20 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $uscitaosm/UNITO_elettrico.pbf
rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte la toponomastica in formato IMG

java $Xmx -jar $splitter \
--max-nodes=30000 \
--max-areas=300 \
--mapid=66131001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_toponomastica.pbf


for infile in $BDTRE_IMG/66131*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Toponimi" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=23 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
    --bounds=bounds \
    --location-autofill=is_in,nearest \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf

#divide e converte le coltivazioni in formato IMG

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_ps_inc.pbf --rbf file=$uscitaosm/UNITO_cl_agr.pbf --merge --wb file=$uscitaosm/UNITO_coltiva.pbf omitmetadata=true


java $Xmx -jar $splitter \
--max-nodes=2000000 \
--max-areas=300 \
--mapid=66132001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_coltiva.pbf


for infile in $BDTRE_IMG/66132*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Coltivazioni" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=12 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $uscitaosm/UNITO_coltiva.pbf
rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf

#divide e converte il comune in formato IMG

java $Xmx -jar $splitter \
--max-nodes=150000 \
--max-areas=300 \
--mapid=66133001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_comune.pbf


for infile in $BDTRE_IMG/66133*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Comune" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=10 \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf

#divide e converte il numero civico in formato IMG

java $Xmx -jar $splitter \
--max-nodes=150000 \
--max-areas=300 \
--mapid=66134001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_acc_pc.pbf


for infile in $BDTRE_IMG/66134*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE civico" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre \
    --show-profiles=1 \
    --draw-priority=10 \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf
