#! /bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"


#verifica che sia presente Gmaptool
if [[ ! -e $GMT ]]
then
  echo "Non trovo gmt, se non lo hai già scaricato lo trovi qui:"
  echo "http://www.gmaptool.eu"
  echo "oppure controlla di averlo messo nel percorso giusto"
  exit 1
fi

# compilo il file typ dal formato testo al fotmato .typ

java -jar $mkgmap \
     --family-id=2000 \
     stile_garmin/Typ/${TYPFILE_VERSION}.txt

mv ${TYPFILE_VERSION}.typ stile_garmin/Typ

MASTER_TYPFILE=stile_garmin/Typ/${TYPFILE_VERSION}.typ

# creo le varianti del file master TYP file con le differenze
# cambia solamente il family ID:

for FID in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009
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


# make the target directory

rm -r finale/
mkdir finale
mkdir finale/etrex
mkdir finale/64
mkdir finale/mapsource

# unisco il file di ogni strato in un file IMG separato per i nuovi disposistivi come ad es. il gps64

$GMT -j -o finale/64/curve.img \
     -f 2000,1 -m "BDTRE Curve di livello" $BDTRE_Curve ./stile_garmin/Typ/2000.TYP
    
$GMT -j -o finale/64/puntiquo.img \
     -f 2001,1 -m "BDTRE Punti quotati" $BDTRE_Punti_quotati ./stile_garmin/Typ/2001.TYP
    
$GMT -j -o finale/64/edifici.img \
     -f 2002,1 -m "BDTRE Edifici" $BDTRE_Edifici ./stile_garmin/Typ/2002.TYP
    
$GMT -j -o finale/64/albero.img \
     -f 2003,1 -m "BDTRE Albero" $BDTRE_Albero ./stile_garmin/Typ/2003.TYP
    
$GMT -j -o finale/64/bosco.img \
     -f 2004,1 -m "BDTRE Bosco" $BDTRE_Bosco ./stile_garmin/Typ/2004.TYP

    
# gli strati ora vengono uniti in un unico gmapsupp.img per i vecchi dispositivi:

$GMT -j -o finale/etrex/gmapsupp.img -m "BDTRE-OSM-GPS (GPS vecchia versione)" \
     finale/64/curve.img     \
     finale/64/puntiquo.img  \
     finale/64/edifici.img   \
     finale/64/albero.img    \
     finale/64/bosco.img


# Ora creo versioni di divisione della mappa per l'utilizzo con Basecamp

# Questo cciclo di mkgmap è usato per fare una mappa panoramica mapset.img
# Che viene utilizzato Basecamp:

java -jar $mkgmap \
  --series-name="BDTRE-OSM-GPS Map (PC version)" \
  --overview-mapname="mapset"   \
  --country-name="Italia"       \
  --region-name="Piemonte"      \
  --output-dir=finale/mapsource \
  --family-id=2000              \
  --draw-priority=12            \
  --family-name="BDTRE Curve"   \
  --product-id=1                \
  $BDTRE_Curve                  \
  --draw-priority=20            \
  --family-name="BDTRE Puntiquo"\
  --product-id=2                \
  $BDTRE_Punti_quotati          \
  --draw-priority=10            \
  --family-name="BDTRE Edifici" \
  --product-id=3                \
  $BDTRE_Edifici                \
  --draw-priority=20            \
  --family-name="BDTRE Albero"  \
  --product-id=4                \
  $BDTRE_Albero                 \
  --draw-priority=10            \
  --family-name="BDTRE Bosco"   \
  --product-id=5                \
  $BDTRE_Bosco                  \
  $MASTER_TYPFILE


# Il file tdb che è stato creato nel processo non funziona
# E non ne abbiamo bisogno, quindi provvedo ad eliminarlo:

rm finale/mapsource/mapset.tdb


# Facio un gmapsupp.img intermedio, lo utilizziamo per poi dividerlo
# nella creazione dei file per Basecamp:

$GMT -j -o finale/mapsource/gmapsupp.img \
     -m "BDTRE-OSM-GPS Map (PC version)" \
     -f 2000,1              \
     $BDTRE_Curve           \
     $BDTRE_Punti_quotati   \
     $BDTRE_Edifici         \
     $BDTRE_Albero          \
     $BDTRE_Bosco           \
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

python stile_garmin/Typ/tdbfile.py finale/mapsource/mapset.tdb
