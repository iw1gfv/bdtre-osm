#! /bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"


#verifica che sia presente Gmaptool
if [[ ! -e $GMT ]]
then
  echo "Non trovo gmt, se non lo hai già scaricato lo trovi qui:"
  echo "http://www.gmaptool.eu"
  echo "oppure controlla di averlo messo nel percorso giusto"
  exit 2
fi

#verifica che sia presente la cartella con i file del BDTRE convertiti in OSM
if [[ ! -d $BDTRE_IMG ]]
then
  echo "Non esiste la cartella $BDTRE_IMG, fai girare lo script bdtre2img.sh prima di questo"
  exit 1
fi

#crea la cartella per i file IMG se non è già esistente
if [ -d $BDTRE_IMG ]; then
    echo "finale esiste."
fi


#cancella i file nella directory
rm -r finale/*

#cancella i file TYP nella directory stile_garmin/Typ
rm stile_garmin/Typ/*.TYP
rm stile_garmin/Typ/*.typ


# compilo il file typ dal formato testo

     java -jar $mkgmap \
     --family-id=2000 \
     stile_garmin/Typ/${TYPFILE_VERSION}.txt

mv ${TYPFILE_VERSION}.typ stile_garmin/Typ

MASTER_TYPFILE=stile_garmin/Typ/${TYPFILE_VERSION}.typ


# creo le varianti del file master TYP file con le differenze
# cambia solamente il family ID:

for FID in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014
do
  cp $MASTER_TYPFILE stile_garmin/Typ/$FID.TYP
  $GMT -w -y $FID,1 stile_garmin/Typ/$FID.TYP
done


# ora creo i singoli livelli che comporranno la mappa
# e definisco i singoli file:

BDTRE_Curve=$(ls $BDTRE_IMG/66120*.img)
BDTRE_Punti_quotati=$(ls $BDTRE_IMG/66121*.img)
BDTRE_Edifici=$(ls $BDTRE_IMG/66122*.img)
BDTRE_Albero=$(ls $BDTRE_IMG/66123*.img)
BDTRE_Bosco=$(ls $BDTRE_IMG/66124*.img)
BDTRE_Laghi=$(ls $BDTRE_IMG/66125*.img)
BDTRE_Canali=$(ls $BDTRE_IMG/66126*.img)
BDTRE_Fiumi=$(ls $BDTRE_IMG/66127*.img)
BDTRE_Sentieri=$(ls $BDTRE_IMG/66128*.img)
BDTRE_Strade=$(ls $BDTRE_IMG/66129*.img)
BDTRE_Linee_ele=$(ls $BDTRE_IMG/66130*.img)
BDTRE_Toponimi=$(ls $BDTRE_IMG/66131*.img)
BDTRE_Coltiva=$(ls $BDTRE_IMG/66132*.img)
BDTRE_Comune=$(ls $BDTRE_IMG/66133*.img)
OSM=$(ls $piemonteosm/66134*.img)


# make the target directory

rm -r finale/
mkdir finale
mkdir finale/etrex
mkdir finale/64
mkdir finale/mapsource

# unisco il file di ogni strato in un file IMG separato per i nuovi disposistivi come ad es. il gps64

$GMT -j -o finale/64/Comune.img \
     -f 2000,1 -m "BDTRE Comune" $BDTRE_Comune ./stile_garmin/Typ/2000.TYP

$GMT -j -o finale/64/Bosco.img \
     -f 2001,1 -m "BDTRE Bosco" $BDTRE_Bosco ./stile_garmin/Typ/2001.TYP

$GMT -j -o finale/64/Coltiva.img \
     -f 2002,1 -m "BDTRE Coltivaziomi" $BDTRE_Coltiva ./stile_garmin/Typ/2002.TYP

$GMT -j -o finale/64/Laghi.img \
     -f 2003,1 -m "BDTRE Laghi" $BDTRE_Laghi ./stile_garmin/Typ/2003.TYP

$GMT -j -o finale/64/Fiumi.img \
     -f 2004,1 -m "BDTRE Fiumi" $BDTRE_Fiumi ./stile_garmin/Typ/2004.TYP

$GMT -j -o finale/64/Strade.img \
     -f 2005,1 -m "BDTRE Strade" $BDTRE_Strade ./stile_garmin/Typ/2005.TYP

$GMT -j -o finale/64/Sentieri.img \
     -f 2006,1 -m "BDTRE Sentieri" $BDTRE_Sentieri ./stile_garmin/Typ/2006.TYP

$GMT -j -o finale/64/Edifici.img \
     -f 2007,1 -m "BDTRE Edifici" $BDTRE_Edifici ./stile_garmin/Typ/2007.TYP

$GMT -j -o finale/64/Curve.img \
     -f 2008,1 -m "BDTRE Curve di livello" $BDTRE_Curve ./stile_garmin/Typ/2008.TYP

$GMT -j -o finale/64/Canali.img \
     -f 2009,1 -m "BDTRE Canali" $BDTRE_Canali ./stile_garmin/Typ/2009.TYP

$GMT -j -o finale/64/Linee_ele.img \
     -f 2010,1 -m "BDTRE Linee elettriche" $BDTRE_Linee_ele ./stile_garmin/Typ/2010.TYP

$GMT -j -o finale/64/Punti_quo.img \
     -f 2011,1 -m "BDTRE Punti quotati" $BDTRE_Punti_quotati ./stile_garmin/Typ/2011.TYP

$GMT -j -o finale/64/Albero.img \
     -f 2012,1 -m "BDTRE Albero isolato" $BDTRE_Albero ./stile_garmin/Typ/2012.TYP

$GMT -j -o finale/64/Toponimi.img \
     -f 2013,1 -m "BDTRE Toponimi" $BDTRE_Toponimi ./stile_garmin/Typ/2013.TYP

$GMT -j -o finale/64/OSM.img \
     -f 2014,1 -m "OSM" $OSM ./stile_garmin/Typ/2014.TYP

    
# gli strati ora vengono uniti in un unico gmapsupp.img per i vecchi dispositivi:

$GMT -j -o finale/etrex/gmapsupp.img -m "BDTRE-OSM-GPS (GPS)" \
     finale/64/Comune.img    \
     finale/64/Bosco.img     \
     finale/64/Coltiva.img   \
     finale/64/Laghi.img     \
     finale/64/Fiumi.img     \
     finale/64/Strade.img    \
     finale/64/Sentieri.img  \
     finale/64/Edifici.img   \
     finale/64/Curve.img     \
     finale/64/Canali.img    \
     finale/64/Linee_ele.img \
     finale/64/Punti_quo.img \
     finale/64/Albero.img    \
     finale/64/Toponimi.img  \
     finale/64/OSM.img


# Ora creo versioni di divisione della mappa per l'utilizzo con Basecamp

# Questo cciclo di mkgmap è usato per fare una mappa panoramica mapset.img
# Che viene utilizzato da Basecamp:

java -jar $mkgmap \
  --series-name="BDTRE-OSM-GPS Map (PC version)" \
  --overview-mapname="mapset"   \
  --country-name="Italia"       \
  --region-name="Piemonte"      \
  --output-dir=finale/mapsource \
  --family-id=2000              \
  --draw-priority=10            \
  --family-name="BDTRE Comune"  \
  --product-id=1                \
  $BDTRE_Comune                 \
  --draw-priority=10            \
  --family-name="BDTRE Bosco"   \
  --product-id=2                \
  $BDTRE_Bosco                  \
  --draw-priority=10            \
  --family-name="BDTRE Coltivazioni"   \
  --product-id=3                \
  $BDTRE_Coltiva                \
  --draw-priority=10            \
  --family-name="BDTRE Laghi"   \
  --product-id=4                \
  $BDTRE_Laghi                  \
  --draw-priority=10            \
  --family-name="BDTRE Fiumi"   \
  --product-id=5                \
  $BDTRE_Fiumi                  \
  --draw-priority=10            \
  --family-name="BDTRE Strade"  \
  --product-id=6                \
  $BDTRE_Strade                 \
  --draw-priority=10            \
  --family-name="BDTRE Sentieri"\
  --product-id=7                \
  $BDTRE_Sentieri               \
  --draw-priority=10            \
  --family-name="BDTRE Edifici" \
  --product-id=8                \
  $BDTRE_Edifici                \
  --draw-priority=12            \
  --family-name="BDTRE Curve di livello"   \
  --product-id=9                \
  $BDTRE_Curve                  \
  --draw-priority=14            \
  --family-name="BDTRE Canali"  \
  --product-id=10               \
  $BDTRE_Canali                 \
  --draw-priority=14            \
  --family-name="BDTRE Linee elettriche"  \
  --product-id=11               \
  $BDTRE_Linee_ele              \
  --draw-priority=20            \
  --family-name="BDTRE Punti quotati"  \
  --product-id=12               \
  $BDTRE_Punti_quotati          \
  --draw-priority=20            \
  --family-name="BDTRE Albero isolato"  \
  --product-id=13               \
  $BDTRE_Albero                 \
  --draw-priority=20            \
  --family-name="BDTRE Toponimi"\
  --product-id=14               \
  $BDTRE_Toponimi               \
  --draw-priority=18            \
  --family-name="OSM"   	\
  --product-id=15               \
  $OSM                          \
  $MASTER_TYPFILE


# Il file tdb che è stato creato nel processo non funziona
# E non ne abbiamo bisogno, quindi provvedo ad eliminarlo:

rm finale/mapsource/mapset.tdb


# Facio un gmapsupp.img intermedio, lo utilizziamo per poi dividerlo
# nella creazione dei file per Basecamp:

$GMT -j -o finale/mapsource/gmapsupp.img \
     -m "BDTRE-OSM-GPS Map (PC version)" \
     -f 2000,1              \
     $BDTRE_Comune          \
     $BDTRE_Bosco           \
     $BDTRE_Coltiva         \
     $BDTRE_Laghi           \
     $BDTRE_Fiumi           \
     $BDTRE_Strade          \
     $BDTRE_Sentieri        \
     $BDTRE_Edifici         \
     $BDTRE_Curve           \
     $BDTRE_Canali          \
     $BDTRE_Linee_ele       \
     $BDTRE_Punti_quotati   \
     $BDTRE_Albero          \
     $BDTRE_Toponimi        \
     $OSM                   \
     $MASTER_TYPFILE


# E divido il file per Basecamp, che genera alcuni file aggiuntivi necessari
# Per l'installazione su Windows, tra cui il file tdb

$GMT -S \
     -f 2000,1 \
     -o finale/mapsource \
     finale/mapsource/gmapsupp.img

# cancello il file intermedio gmapsupp.img

rm finale/mapsource/gmapsupp.img

# E adesso bisogna patchare il file TDB affinchè contenga le corrette informazioni sul copyright
# Per tutte le parti della mappa BDTRE - OSM- GPS

python stile_garmin/tdbfile.py finale/mapsource/mapset.tdb

#cancella i file
rm stile_garmin/Typ/x*.typ
rm osmmap.tdb
