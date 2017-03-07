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

#scarica i file Bdtre
for i in {001001..103090} 
do
echo $i
wget http://www.datigeo-piem-download.it/static/regp01/BDTRE2017_VECTOR/BDTRE_DATABASE_GEOTOPOGRAFICO_2017-LIMI_COMUNI_10_GAIMSDWL-$i-EPSG32632-SHP.zip

done

cd ..

#entra nella directory dei files non zippati ed estrae li i files della bdtre
cd $sbdtre
unzip -o ../$sbdtrez/\*.zip
