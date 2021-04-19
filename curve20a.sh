#!/bin/bash

#Questo script crea le curve a 20 metri in alternativa a quelle 10 metri
#ATTENZIONE, questo script non scarica i file del Dtm
#Questo script va fatto girare solo per ripristinare i file comunali con le curve di livello


#carica il file di configuraione delle variabili
source "./configurazione"


#verifica che sia presente la cartella con i file sorgenti del Dtm5
if [[ ! -d $sdtm ]]
then
  echo "Non esiste la cartella $sdtm, fai girare lo script scaricadtm.sh prima di questo"
  exit 2
fi

if [[ ! -d $tif ]]
then
  echo "Non esiste la cartella $tif, fai girare lo script scaricadtm.sh prima di questo"
  exit 1
fi


#verifica la presenza delle cartella dei file SHP e la crea se non è già esistente
if [ -d $curve20 ]; then
    echo "OK - $curve20 esiste."
else
    mkdir $curve20
fi


#rimuove i files eventualmente presenti nella cartella
echo
echo cancello i vecchi file
rm -r $curve20/*


#sposta i file tif
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

