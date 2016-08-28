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
--max-nodes=2000000 \
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
    --style-file=stile_garmin/bdtre_curve \
    --show-profiles=1 \
    --draw-priority=24 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte i impianti sportivi in formato IMG

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_attr_sp.pbf --rbf file=$uscitaosm/UNITO_pe_uins.pbf --merge --wb file=$uscitaosm/UNITO_sport.pbf omitmetadata=true

java $Xmx -jar $splitter \
--max-nodes=20000 \
--max-areas=300 \
--mapid=66121001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_sport.pbf


for infile in $BDTRE_IMG/66121*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Impianti sportivi" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre_impianti \
    --show-profiles=1 \
    --add-pois-to-areas \
    --draw-priority=18 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
    --bounds=bounds \
    --location-autofill=is_in,nearest \
  $infile
done

rm $uscitaosm/UNITO_sport.pbf
rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte gli edifici in formato IMG

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_edifc.pbf --rbf file=$uscitaosm/UNITO_edi_min.pbf --rbf file=$uscitaosm/UNITO_ele_cp.pbf --rbf file=$uscitaosm/UNITO_mn_ind.pbf --rbf file=$uscitaosm/UNITO_par_ar.pbf --rbf file=$uscitaosm/UNITO_aatt.pbf --merge --merge --merge --merge --merge --wb file=$uscitaosm/UNITO_edifici.pbf omitmetadata=true

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
    --style-file=stile_garmin/bdtre_edifici \
    --show-profiles=1 \
    --add-pois-to-areas \
    --draw-priority=20 \
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

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_albero.pbf --rbf file=$uscitaosm/UNITO_fil_al.pbf --merge --wb file=$uscitaosm/UNITO_alberi.pbf omitmetadata=true

java $Xmx -jar $splitter \
--max-nodes=20000 \
--max-areas=300 \
--mapid=66123001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_alberi.pbf


for infile in $BDTRE_IMG/66123*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Alberi/siepi" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre_alberi \
    --show-profiles=1 \
    --draw-priority=25 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $uscitaosm/UNITO_alberi.pbf
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
    --style-file=stile_garmin/bdtre_bosco \
    --show-profiles=1 \
    --draw-priority=12 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte l'invaso  e sp_acq in formato IMG

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_invaso.pbf --rbf file=$uscitaosm/UNITO_sp_acq.pbf --rbf file=$uscitaosm/UNITO_diga.pbf --merge --merge --wb file=$uscitaosm/UNITO_laghi.pbf omitmetadata=true

java $Xmx -jar $splitter \
--max-nodes=30000 \
--max-areas=300 \
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
    --style-file=stile_garmin/bdtre_laghi \
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
    --style-file=stile_garmin/bdtre_canali \
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


#divide e converte i fiumi in formato IMG

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_ab_cda.pbf --rbf file=$uscitaosm/UNITO_op_reg.pbf --merge --wb file=$uscitaosm/UNITO_fiumi.pbf omitmetadata=true


java $Xmx -jar $splitter \
--max-nodes=300000 \
--max-areas=300 \
--mapid=66127001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_fiumi.pbf


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
    --style-file=stile_garmin/bdtre_fiumi \
    --show-profiles=1 \
    --draw-priority=14 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $uscitaosm/UNITO_fiumi.pbf
rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte i punti quotati in formato IMG

java $Xmx -jar $splitter \
--max-nodes=30000 \
--max-areas=300 \
--mapid=66128001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_p_altim.pbf


for infile in $BDTRE_IMG/66128*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Pumti quotati" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre_quota \
    --show-profiles=1 \
    --draw-priority=26 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte le strade in formato IMG

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_ac_vei.pbf --rbf file=$uscitaosm/UNITO_ac_ped.pbf --rbf file=$uscitaosm/UNITO_ar_vms.pbf --rbf file=$uscitaosm/UNITO_man_tr.pbf --rbf file=$uscitaosm/UNITO_ponte.pbf --rbf file=$uscitaosm/UNITO_aatt.pbf --merge --merge --merge --merge --merge --wb file=$uscitaosm/UNITO_strade.pbf omitmetadata=true

java $Xmx -jar $splitter \
--max-nodes=1600000 \
--max-areas=300 \
--mapid=66129001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_strade.pbf


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
    --style-file=stile_garmin/bdtre_strade \
    --show-profiles=1 \
    --add-pois-to-areas \
    --draw-priority=19 \
    --transparent \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $uscitaosm/UNITO_strade.pbf
rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte i tralicci e le linee elettriche in formato IMG

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_nd_ele.pbf --rbf file=$uscitaosm/UNITO_tr_ele.pbf --merge --wb file=$uscitaosm/UNITO_elettrico.pbf omitmetadata=true

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
    --style-file=stile_garmin/bdtre_ele \
    --show-profiles=1 \
    --draw-priority=23 \
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
    --style-file=stile_garmin/bdtre_topo \
    --show-profiles=1 \
    --draw-priority=27 \
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
    --style-file=stile_garmin/bdtre_coltiv \
    --show-profiles=1 \
    --draw-priority=11 \
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
$uscitaosm/UNITO_comuni.pbf


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
    --style-file=stile_garmin/bdtre_comune \
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

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_acc_int.pbf --rbf file=$uscitaosm/UNITO_acc_pc.pbf --merge --wb file=$uscitaosm/UNITO_civico.pbf omitmetadata=true

java $Xmx -jar $splitter \
--max-nodes=30000 \
--max-areas=300 \
--mapid=66134001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_civico.pbf


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
    --style-file=stile_garmin/bdtre_civico \
    --show-profiles=1 \
    --draw-priority=28 \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $uscitaosm/UNITO_civico.pbf
rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte l'area verde in formato IMG

java $Xmx -jar $splitter \
--max-nodes=30000 \
--max-areas=300 \
--mapid=66135001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_ar_vrd.pbf


for infile in $BDTRE_IMG/66135*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Giardino cittadino" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre_verde \
    --show-profiles=1 \
    --draw-priority=17 \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte la cava in formato IMG

java $Xmx -jar $splitter \
--max-nodes=30000 \
--max-areas=300 \
--mapid=66136001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_cv_aes.pbf


for infile in $BDTRE_IMG/66136*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Cava" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre_cava \
    --show-profiles=1 \
    --draw-priority=15 \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte le divisioni del terreno in formato IMG

java $Xmx -jar $splitter \
--max-nodes=30000 \
--max-areas=300 \
--mapid=66137001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_el_div.pbf


for infile in $BDTRE_IMG/66137*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Divisioni del terreno" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre_divisioni \
    --show-profiles=1 \
    --add-pois-to-areas \
    --draw-priority=22 \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf


#divide e converte le forme del terreno in formato IMG

$osmosis -v --read-pbf-fast file=$uscitaosm/UNITO_f_nter.pbf --rbf file=$uscitaosm/UNITO_for_pc.pbf --rbf file=$uscitaosm/UNITO_scarpt.pbf --rbf file=$uscitaosm/UNITO_argine.pbf --rbf file=$uscitaosm/UNITO_ghi_nv.pbf --rbf file=$uscitaosm/UNITO_man_tr.pbf --rbf file=$uscitaosm/UNITO_pe_uins.pbf --rbf file=$uscitaosm/UNITO_sc_dis.pbf --merge --merge --merge --merge --merge --merge --merge --wb file=$uscitaosm/UNITO_formter.pbf omitmetadata=true

java $Xmx -jar $splitter \
--max-nodes=1600000 \
--max-areas=300 \
--mapid=66138001 \
--output-dir=$BDTRE_IMG \
$uscitaosm/UNITO_formter.pbf


for infile in $BDTRE_IMG/66138*.osm.pbf
  do
  MAPNAME=$(basename $infile .osm.pbf)
  echo processing $MAPNAME

  java $Xmx -jar $mkgmap --code-page=1252 \
    --mapname=$MAPNAME \
    --description="BDTRE Forme del terreno" \
    --country-name="Italia" \
    --region-name="Piemonte" \
    --copyright-message="$copyright" \
    --output-dir=$BDTRE_IMG \
    --style-file=stile_garmin/bdtre_terreno \
    --show-profiles=1 \
    --add-pois-to-areas \
    --draw-priority=16 \
    --license-file=stile_garmin/bdtre_licenza.txt \
  $infile
done

rm $uscitaosm/UNITO_formter.pbf
rm $BDTRE_IMG/areas.*
rm $BDTRE_IMG/densities-out.txt
rm $BDTRE_IMG/temp*.*
rm $BDTRE_IMG/*.pbf
