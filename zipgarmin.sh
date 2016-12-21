#!/bin/bash
#questo file crea il file .zip pronto da pubblicare, con all'interno mappa, licenza, documentazione ecc


#carica il file di configuraione delle variabili
source "./configurazione"

#crea il nome del file partendo dalla data
data=`date +%Y-%m`


#cancella i file zip esistenti
cd $dirzip
rm *$data.zip

cd ..



#prepara la cartella con le mappe e la documentazione della versione per PC

cp -r $dirzip/Garmin $dirzip/Bdtre-osm-PC

cp -r finale/mappe $dirzip/Bdtre-osm-PC/

#esegue lo zip e cancella la cartella precedentemente creata

cd $dirzip

zip -r "Bdtre-osm-PC-$data.zip" Bdtre-osm-PC

rm -r Bdtre-osm-PC

cd ..



#prepara la cartella con le mappe e la documentazione della versione per GPS

cp -r $dirzip/GPS $dirzip/Bdtre-osm-GPS

cp -r finale/etrex/* $dirzip/Bdtre-osm-GPS/

#esegue lo zip e cancella la cartella precedentemente creata

cd $dirzip

zip -r "Bdtre-osm-GPS-$data.zip" Bdtre-osm-GPS

rm -r Bdtre-osm-GPS

cd ..



#prepara la cartella con le mappe e la documentazione della versione per GPS

cp -r $dirzip/GPS_separato $dirzip/Bdtre-osm-GPS_separato

cp -r finale/64 $dirzip/Bdtre-osm-GPS_separato/

#esegue lo zip e cancella la cartella precedentemente creata

cd $dirzip

zip -r "Bdtre-osm-GPS_separato-$data.zip" Bdtre-osm-GPS_separato

rm -r Bdtre-osm-GPS_separato

cd ..
