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

for FID in 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026 2027 2028 2029
do
  cp $MASTER_TYPFILE stile_garmin/Typ/$FID.TYP
  $GMT -w -y $FID,1 stile_garmin/Typ/$FID.TYP
done


# ora creo i singoli livelli che comporranno la mappa
# e definisco i singoli file:

BDTRE_Curve=$(ls $BDTRE_IMG/66120*.img)
BDTRE_Impianti=$(ls $BDTRE_IMG/66121*.img)
BDTRE_Edifici=$(ls $BDTRE_IMG/66122*.img)
BDTRE_Alberi=$(ls $BDTRE_IMG/66123*.img)
BDTRE_Bosco=$(ls $BDTRE_IMG/66124*.img)
BDTRE_Laghi=$(ls $BDTRE_IMG/66125*.img)
BDTRE_Canali=$(ls $BDTRE_IMG/66126*.img)
BDTRE_Fiumi=$(ls $BDTRE_IMG/66127*.img)
BDTRE_Rete=$(ls $BDTRE_IMG/66128*.img)
BDTRE_Strade=$(ls $BDTRE_IMG/66129*.img)
BDTRE_Linee_ele=$(ls $BDTRE_IMG/66130*.img)
BDTRE_Toponimi=$(ls $BDTRE_IMG/66131*.img)
BDTRE_Coltiva=$(ls $BDTRE_IMG/66132*.img)
BDTRE_Comune=$(ls $BDTRE_IMG/66133*.img)
BDTRE_Civico=$(ls $BDTRE_IMG/66134*.img)
BDTRE_Verde=$(ls $BDTRE_IMG/66135*.img)
BDTRE_Cava=$(ls $BDTRE_IMG/66136*.img)
BDTRE_Divisioni=$(ls $BDTRE_IMG/66137*.img)
BDTRE_Terreno=$(ls $BDTRE_IMG/66138*.img)
OSM_Protette=$(ls $piemonteosm/66139*.img)
OSM_Militari=$(ls $piemonteosm/66140*.img)
OSM_Ferrovie=$(ls $piemonteosm/66141*.img)
OSM_Poi=$(ls $piemonteosm/66142*.img)
OSM_Viabilita=$(ls $piemonteosm/66143*.img)
OSM_Energie=$(ls $piemonteosm/66144*.img)
OSM_Risalita=$(ls $piemonteosm/66145*.img)
OSM_Traghetti=$(ls $piemonteosm/66146*.img)
OSM_Ciclovie=$(ls $piemonteosm/66147*.img)
OSM_Sentieri=$(ls $piemonteosm/66148*.img)
OSM_Idro=$(ls $piemonteosm/66149*.img)


# make the target directory

rm -r finale/
mkdir finale
mkdir finale/etrex
mkdir finale/64
mkdir finale/mappe

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

$GMT -j -o finale/64/Rete.img \
     -f 2006,1 -m "BDTRE Vertici di rete" $BDTRE_Rete ./stile_garmin/Typ/2006.TYP

$GMT -j -o finale/64/Edifici.img \
     -f 2007,1 -m "BDTRE Edifici" $BDTRE_Edifici ./stile_garmin/Typ/2007.TYP

$GMT -j -o finale/64/Curve.img \
     -f 2008,1 -m "BDTRE Curve di livello" $BDTRE_Curve ./stile_garmin/Typ/2008.TYP

$GMT -j -o finale/64/Canali.img \
     -f 2009,1 -m "BDTRE Canali" $BDTRE_Canali ./stile_garmin/Typ/2009.TYP

$GMT -j -o finale/64/Linee_ele.img \
     -f 2010,1 -m "BDTRE Linee elettriche" $BDTRE_Linee_ele ./stile_garmin/Typ/2010.TYP

$GMT -j -o finale/64/Impianti.img \
     -f 2011,1 -m "BDTRE Impianti sportivi" $BDTRE_Impianti ./stile_garmin/Typ/2011.TYP

$GMT -j -o finale/64/Alberi.img \
     -f 2012,1 -m "BDTRE Alberi/siepi" $BDTRE_Alberi ./stile_garmin/Typ/2012.TYP

$GMT -j -o finale/64/Toponimi.img \
     -f 2013,1 -m "BDTRE Toponimi" $BDTRE_Toponimi ./stile_garmin/Typ/2013.TYP

$GMT -j -o finale/64/Civico.img \
     -f 2014,1 -m "BDTRE Numero civico" $BDTRE_Civico ./stile_garmin/Typ/2014.TYP

$GMT -j -o finale/64/Verde.img \
     -f 2015,1 -m "BDTRE Giardino cittadino" $BDTRE_Verde ./stile_garmin/Typ/2015.TYP

$GMT -j -o finale/64/Cava.img \
     -f 2016,1 -m "BDTRE Cava" $BDTRE_Cava ./stile_garmin/Typ/2016.TYP

$GMT -j -o finale/64/Divisioni.img \
     -f 2017,1 -m "BDTRE Divisioni del terreno" $BDTRE_Divisioni ./stile_garmin/Typ/2017.TYP

$GMT -j -o finale/64/Terreno.img \
     -f 2018,1 -m "BDTRE Forme del terreno" $BDTRE_Terreno ./stile_garmin/Typ/2018.TYP

$GMT -j -o finale/64/Protette.img \
     -f 2019,1 -m "OSM Aree protette" $OSM_Protette ./stile_garmin/Typ/2019.TYP

$GMT -j -o finale/64/Militari.img \
     -f 2020,1 -m "OSM Aree militari" $OSM_Militari ./stile_garmin/Typ/2020.TYP

$GMT -j -o finale/64/Ferrovie.img \
     -f 2021,1 -m "OSM Ferrovie" $OSM_Ferrovie ./stile_garmin/Typ/2021.TYP

$GMT -j -o finale/64/Poi.img \
     -f 2022,1 -m "OSM Poi" $OSM_Poi ./stile_garmin/Typ/2022.TYP

$GMT -j -o finale/64/Viabilita.img \
     -f 2023,1 -m "OSM Viabilità" $OSM_Viabilita ./stile_garmin/Typ/2023.TYP

$GMT -j -o finale/64/Energie.img \
     -f 2024,1 -m "OSM Energie" $OSM_Energie ./stile_garmin/Typ/2024.TYP

$GMT -j -o finale/64/Risalita.img \
     -f 2025,1 -m "OSM Impianti di risalita" $OSM_Risalita ./stile_garmin/Typ/2025.TYP

$GMT -j -o finale/64/Traghetti.img \
     -f 2026,1 -m "OSM Linee traghetti" $OSM_Traghetti ./stile_garmin/Typ/2026.TYP

$GMT -j -o finale/64/Ciclovie.img \
     -f 2027,1 -m "OSM Ciclovie" $OSM_Ciclovie ./stile_garmin/Typ/2027.TYP

$GMT -j -o finale/64/Sentieri.img \
     -f 2028,1 -m "OSM Sentieri" $OSM_Sentieri ./stile_garmin/Typ/2028.TYP

$GMT -j -o finale/64/Idro.img \
     -f 2029,1 -m "OSM Idrografia" $OSM_Idro ./stile_garmin/Typ/2029.TYP

    
# gli strati ora vengono uniti in un unico gmapsupp.img per i vecchi dispositivi:

$GMT -j -o finale/etrex/gmapsupp.img -m "BDTRE-OSM-GPS (GPS)" \
     finale/64/Comune.img    \
     finale/64/Bosco.img     \
     finale/64/Coltiva.img   \
     finale/64/Laghi.img     \
     finale/64/Fiumi.img     \
     finale/64/Strade.img    \
     finale/64/Rete.img      \
     finale/64/Edifici.img   \
     finale/64/Curve.img     \
     finale/64/Canali.img    \
     finale/64/Linee_ele.img \
     finale/64/Impianti.img  \
     finale/64/Alberi.img    \
     finale/64/Toponimi.img  \
     finale/64/Civico.img    \
     finale/64/Verde.img     \
     finale/64/Cava.img      \
     finale/64/Divisioni.img \
     finale/64/Terreno.img   \
     finale/64/Protette.img  \
     finale/64/Militari.img  \
     finale/64/Ferrovie.img  \
     finale/64/Poi.img       \
     finale/64/Viabilita.img \
     finale/64/Energie.img   \
     finale/64/Risalita.img  \
     finale/64/Traghetti.img \
     finale/64/Ciclovie.img  \
     finale/64/Sentieri.img  \
     finale/64/Idro.img


# Ora creo versioni di divisione della mappa per l'utilizzo con Basecamp

# Questo cciclo di mkgmap è usato per fare una mappa panoramica mapset.img
# Che viene utilizzato da Basecamp:

java -jar $mkgmap \
  --series-name="BDTRE-OSM-GPS Map (PC version)" \
  --overview-mapname="mapset"   \
  --country-name="Italia"       \
  --region-name="Piemonte"      \
  --output-dir=finale/mappe     \
  --family-id=2000              \
  --draw-priority=10            \
  --family-name="BDTRE Comune"  \
  --product-id=1                \
  $BDTRE_Comune                 \
  --draw-priority=12            \
  --family-name="BDTRE Bosco"   \
  --product-id=2                \
  $BDTRE_Bosco                  \
  --draw-priority=11            \
  --family-name="BDTRE Coltivazioni" \
  --product-id=3                \
  $BDTRE_Coltiva                \
  --draw-priority=13            \
  --family-name="BDTRE Laghi"   \
  --product-id=4                \
  $BDTRE_Laghi                  \
  --draw-priority=14            \
  --family-name="BDTRE Fiumi"   \
  --product-id=5                \
  $BDTRE_Fiumi                  \
  --draw-priority=19            \
  --family-name="BDTRE Strade"  \
  --product-id=6                \
  $BDTRE_Strade                 \
  --draw-priority=26            \
  --family-name="BDTRE Vertici di rete" \
  --product-id=7                \
  $BDTRE_Sentieri               \
  --draw-priority=20            \
  --family-name="BDTRE Edifici" \
  --product-id=8                \
  $BDTRE_Edifici                \
  --draw-priority=24            \
  --family-name="BDTRE Curve di livello" \
  --product-id=9                \
  $BDTRE_Curve                  \
  --draw-priority=21            \
  --family-name="BDTRE Canali"  \
  --product-id=10               \
  $BDTRE_Canali                 \
  --draw-priority=23            \
  --family-name="BDTRE Linee elettriche" \
  --product-id=11               \
  $BDTRE_Linee_ele              \
  --draw-priority=18            \
  --family-name="BDTRE Impianti sportivi" \
  --product-id=12               \
  $BDTRE_Impianti               \
  --draw-priority=25            \
  --family-name="BDTRE Alberi/siepi" \
  --product-id=13               \
  $BDTRE_Albero                 \
  --draw-priority=27            \
  --family-name="BDTRE Toponimi"\
  --product-id=14               \
  $BDTRE_Toponimi               \
  --draw-priority=28            \
  --family-name="BDTRE Numero civico" \
  --product-id=15               \
  $BDTRE_Civico                 \
  --draw-priority=17            \
  --family-name="BDTRE Giardino cittadino" \
  --product-id=16               \
  $BDTRE_Verde                  \
  --draw-priority=15            \
  --family-name="BDTRE Cava"   	\
  --product-id=17               \
  $BDTRE_Cava                   \
  --draw-priority=22            \
  --family-name="BDTRE Divisioni del terreno" \
  --product-id=18               \
  $BDTRE_Divisioni              \
  --draw-priority=16            \
  --family-name="BDTRE Forme del terreno" \
  --product-id=19               \
  $BDTRE_Terreno                \
  --draw-priority=29            \
  --family-name="OSM Aree protette" \
  --product-id=20               \
  $OSM_Protette                 \
  --draw-priority=30            \
  --family-name="OSM Aree militari" \
  --product-id=21               \
  $OSM_Militari                 \
  --draw-priority=32            \
  --family-name="OSM Ferrovie"  \
  --product-id=22               \
  $OSM_Ferrovie                 \
  --draw-priority=33            \
  --family-name="OSM Poi"       \
  --product-id=23               \
  $OSM_Poi                      \
  --draw-priority=34            \
  --family-name="OSM Viabilità" \
  --product-id=24               \
  $OSM_Viabilita                \
  --draw-priority=31            \
  --family-name="OSM Energie"   \
  --product-id=25               \
  $OSM_Energie                  \
  --draw-priority=35            \
  --family-name="OSM Impianti di risalita"   \
  --product-id=26               \
  $OSM_Risalita                 \
  --draw-priority=36            \
  --family-name="OSM Linee traghetti"   \
  --product-id=27               \
  $OSM_Traghetti                \
  --draw-priority=37            \
  --family-name="OSM Ciclovie"  \
  --product-id=28               \
  $OSM_Ciclovie                 \
  --draw-priority=38            \
  --family-name="OSM Sentieri"  \
  --product-id=29               \
  $OSM_Sentieri                 \
  --draw-priority=39            \
  --family-name="OSM Idrografia"\
  --product-id=30               \
  $OSM_Idro                     \
  $MASTER_TYPFILE


# Il file tdb che è stato creato nel processo non funziona
# E non ne abbiamo bisogno, quindi provvedo ad eliminarlo:

rm finale/mappe/mapset.tdb


# Facio un gmapsupp.img intermedio, lo utilizziamo per poi dividerlo
# nella creazione dei file per Basecamp:

$GMT -j -o finale/mappe/gmapsupp.img \
     -m "BDTRE-OSM-GPS Map (PC version)" \
     -f 2000,1              \
     $BDTRE_Comune          \
     $BDTRE_Bosco           \
     $BDTRE_Coltiva         \
     $BDTRE_Laghi           \
     $BDTRE_Fiumi           \
     $BDTRE_Strade          \
     $BDTRE_Rete            \
     $BDTRE_Edifici         \
     $BDTRE_Curve           \
     $BDTRE_Canali          \
     $BDTRE_Linee_ele       \
     $BDTRE_Impianti        \
     $BDTRE_Alberi          \
     $BDTRE_Toponimi        \
     $BDTRE_Civico          \
     $BDTRE_Verde           \
     $BDTRE_Cava            \
     $BDTRE_Divisioni       \
     $BDTRE_Terreno         \
     $OSM_Protette          \
     $OSM_Militari          \
     $OSM_Ferrovie          \
     $OSM_Poi               \
     $OSM_Viabilita         \
     $OSM_Energie           \
     $OSM_Risalita          \
     $OSM_Traghetti         \
     $OSM_Ciclovie          \
     $OSM_Sentieri          \
     $OSM_Idro              \
     $MASTER_TYPFILE


# E divido il file per Basecamp, che genera alcuni file aggiuntivi necessari
# Per l'installazione su Windows, tra cui il file tdb

$GMT -S \
     -f 2000,1 \
     -o finale/mappe \
     finale/mappe/gmapsupp.img

# cancello il file intermedio gmapsupp.img

rm finale/mappe/gmapsupp.img

# E adesso bisogna patchare il file TDB affinchè contenga le corrette informazioni sul copyright
# Per tutte le parti della mappa BDTRE - OSM- GPS

python stile_garmin/tdbfile.py finale/mappe/mapset.tdb

#cancella i file
rm stile_garmin/Typ/*x*.typ
rm osmmap.tdb
