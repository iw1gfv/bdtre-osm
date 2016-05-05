#!/bin/bash
#questo file crea il file .zip pronto da pubblicare, con all'interno mappa, licenza, documentazione ecc


#carica il file di configuraione delle variabili
source "./configurazione"

#crea il nome del file partendo dalla data
data=`date +%Y-%m`


cd $dirzip
cd Garmin
#rimuove il vecchio file se presente
rm ../bdtre-osm-pc-$data.zip

#aggiunge la documentazione
zip -r "../bdtre-osm-pc-$data.zip" *

#aggiunge la mappa
cd ../../finale
zip -r ../"$dirzip"/bdtre-osm-pc-$data.zip ./mappe

cd ..


cd $dirzip
cd GPS
#rimuove il vecchio file se presente
rm ../bdtre-osm-gps-$data.zip

#aggiunge la documentazione
zip -r "../bdtre-osm-gps-$data.zip" *

#aggiunge la mappa
cd ../../finale/etrex
zip -r ../../"$dirzip"/bdtre-osm-gps-$data.zip gmapsupp.img
