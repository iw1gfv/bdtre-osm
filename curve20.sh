#!/bin/bash

#Questo script scarica i file del DTM della regione e crea le curve a 20 metri in alternativa a quelle 10 metri


#carica il file di configuraione delle variabili
source "./configurazione"


#crea la cartella per i file zippati del DTM5 se non è già esistente
if [ -d $sdtm ]; then
    echo "$sdtm esiste."
else
    mkdir $sdtm
fi


#crea la cartella per i file TIF se non è già esistente
if [ -d $tif ]; then
    echo "$tif esiste."
else
    mkdir $tif
fi


#crea la cartella delle curve a 20 metri se non è già esistente
if [ -d $curve20 ]; then
    echo "OK - $curve20 esiste."
else
    mkdir $curve20
fi


#rimuove i files eventualmente presenti nelle cartelle
echo
echo cancello i vecchi file
rm -r $sdtm/*
rm -r $tif/*
rm -r $curve20/*


#si sposta nella cartella in cui saranno scaricati i file zippati
cd $sdtm


#inizia il ciclo di scaricamento e lo ripete finchè ci sono sezioni indicate nel file di scarico
#puoi cambiare il file di scarico con uno di quelli presenti nella cartella oppure crearne uno tuo e salvarlo nella cartella "Scarico", per far leggere il tuo oppure un'altro file cambia la scritta Regione.txt qui sotto con quello che ti interessa

#legge il codice della sezione da scaricare indicato nel file di scarico
cat ../Scarico/Dtm/Regione.txt | \
while read riga; do
echo $riga

#prende il codice della sezione
codice=`echo $riga | cut -d " " -f 1`

#scarica il file selezionato
wget -nc http://www.datigeo-piem-download.it/static/regp01/DTM5_ICE/RIPRESA_AEREA_ICE_2009_2011_DTM-SDO_CTR_FOGLI50-$codice-EPSG32632-TIF.zip

done 


#passa nella cartella dei file scompattati
cd ../$tif


#scompatta il file hillshading
unzip -o ../$sdtm/\*.zip


#torna nella cartella principale
cd ..


#copia i file tif
echo
echo "Copio i file Dtm5 nella cartella $curve20"
cp ./$tif/*.tif ./$curve20


#crea le curve
	#crea il file vrt unico per tutti i file
	echo
	echo "Creo il file vrt"
	gdalbuildvrt ./$curve20/curve.vrt ./$curve20/*.tif -a_srs "EPSG:32632"
	#crea le curve
	echo
	echo "Creo le curve"
	gdal_contour -b 1 -a name -i 20.0 -f "ESRI Shapefile" ./$curve20/curve.vrt "./$curve20/curve.shp"
	#cancella i file tif
	echo
	echo "cancello i file superflui"
	rm ./$curve20/*.tif
	rm ./$curve20/*.vrt

#parte il ciclo che taglia le curve sui confini dei comuni
	#si sposta nella cartella dei file sorgenti
	cd $sbdtre
	for i in $(ls)
	do
		#ritaglia le curve sul confine del comune
		echo
		echo "Taglio le curve del comune $i"
		ogr2ogr -f 'ESRI Shapefile' -clipsrc $i/AMM/limi_comuni_piem_2021.shp $i/ORO/cv_liv_class_2021.shp ../$curve20/curve.shp
	done


#torna nella cartella principale
cd ..
