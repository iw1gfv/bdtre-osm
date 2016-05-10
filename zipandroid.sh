#!/bin/bash
#questo file crea il file .zip pronto da pubblicare, con all'interno mappa, licenza, documentazione ecc


#carica il file di configuraione delle variabili
source "./configurazione"

#crea il nome del file partendo dalla data
data=`date +%Y-%m`


cd $dirzip
cd Android
#rimuove il vecchio file se presente
rm ../bdtre-osm-android-*.zip

#Copia la mappa nella directory dello zip
cp ../../$uscitamap/bdtre-osm.map bdtre-osm-$data.map

#aggiunge la documentazione
zip -r "../bdtre-osm-android-$data.zip" ./

