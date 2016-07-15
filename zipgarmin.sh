#!/bin/bash
#questo file crea il file .zip pronto da pubblicare, con all'interno mappa, licenza, documentazione ecc


#carica il file di configuraione delle variabili
source "./configurazione"

#crea il nome del file partendo dalla data
data=`date +%Y-%m`



#cancella i file zip esistenti
cd $dirzip
rm *.zip

cd ..



#prepara il file zip con le mappe della versione PC

cd $dirzip
cd Garmin

#aggiunge la documentazione
zip -r "../bdtre-osm-pc-$data.zip" *

#aggiunge la mappa
cd ../../finale
zip -r ../"$dirzip"/bdtre-osm-pc-$data.zip ./mappe

cd ..



#prepara il file zip con le mappe della versione GPS tutto insieme

cd $dirzip
cd GPS

#aggiunge la documentazione
zip -r "../bdtre-osm-gps-$data.zip" *

#aggiunge la mappa
cd ../../finale/etrex
zip -r ../../"$dirzip"/bdtre-osm-gps-$data.zip gmapsupp.img

cd ..
cd ..

#prepara il file zip con le mappe della versione GPS con file separati

cd $dirzip
cd GPS_separato

#aggiunge la documentazione
zip -r "../bdtre-osm-gps_separato-$data.zip" *

#aggiunge la mappa
cd ../../finale
zip -r ../"$dirzip"/bdtre-osm-gps_separato-$data.zip ./64
