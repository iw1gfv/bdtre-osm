#!/bin/bash
#Questo file scarica la bdtre

#carica il file di configuraione delle variabili
source "./configurazione"

cd $sbdtrez

#ciclo di scaricamento 
cat ../comuni/lista_comuni.txt | \
while read riga; do
echo $riga

#prende il codice del comune
codice=`echo $riga | cut -d " " -f 1`

#scarica il file
wget -nc http://www.datigeo-piem-download.it/static/regp01/BDTRE2015_VECTOR/BDTRE_DATABASE_GEOTOPOGRAFICO_2015-LIMI_COMUNI_10_GAIMSDWL-$codice-EPSG32632-SHP.zip -nv

done 
