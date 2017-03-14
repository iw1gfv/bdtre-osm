#!/bin/bash
#Questo file scarica la bdtre

#carica il file di configuraione delle variabili
source "./configurazione"


#crea la cartella dei file del BDTRE se non è già esistente
if [ -d $sbdtrez ]; then
    echo "$sbdtrez esiste."
else
    mkdir $sbdtrez
fi

#crea la cartella dei file sorgenti del BDTRE se non è già esistente
if [ -d $sbdtre ]; then
    echo "$sbdtre esiste."
else
    mkdir $sbdtre
fi

#rimuove i files presenti nella cartella
rm $sbdtrez/*
rm $sbdtre/*

cd $sbdtrez

#ciclo di scaricamento 
cat ../comuni/lista_comuni.txt | \
while read riga; do
echo $riga

#prende il codice del comune
codice=`echo $riga | cut -d " " -f 1`

#scarica il file
wget -nc http://www.datigeo-piem-download.it/static/regp01/BDTRE2017_VECTOR/BDTRE_DATABASE_GEOTOPOGRAFICO_2017-LIMI_COMUNI_10_GAIMSDWL-$codice-EPSG32632-SHP.zip -nv

done 

cd ..

#entra nella directory dei files non zippati ed estrae li i files della bdtre
cd $sbdtre
unzip -o ../$sbdtrez/\*.zip
