#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"


#verifica che sia presente la cartella con i file sorgenti del Dtm5
if [[ ! -d $tif ]]
then
  echo "Non esiste la cartella $tif, fai girare lo script scaricadtm.sh prima di questo"
  exit 1
fi


#crea la cartella dei file SHP se non è già esistente
if [ -d $sbdtre ]; then
    echo "OK - $sbdtre esiste."
else
    mkdir $sbdtre
fi

#elimina i file vrt nella cartella
rm -r $tif/*.vrt

#elimina i file DTM5.SHP nella cartella
rm -r $sbdtre/DTM5*

cd $tif

#crea un file vrt per ogni sezione

for i in $(find -name "*.tif")  
	 do
	 echo "creo il file vrt per $i"
gdalbuildvrt $i.vrt $i -a_srs "EPSG:32632"

done

#rinomina i file vrt
rename 's/.tif.vrt/.vrt/g' *.tif.vrt

#crea le curve

for i in $(find -name "*.vrt")  
	 do
	 echo "creo le curve di livello per $i"
gdal_contour -a name -i 10.0 -f "ESRI Shapefile" "$i" "../$sbdtre/$i.shp"

done

cd ..
