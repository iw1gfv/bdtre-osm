#!/bin/bash

#Questo file scarica i file bdtre vettoriale e li decomprime nella cartella dei file sorgenti

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
#rm $sbdtrez/*
#rm $sbdtre/*


#si sposta nella cartella dei file zippati
cd $sbdtrez


#comincia il ciclo di scaricamento

	#legge il file con i codici
	cat ../comuni/Torino.txt | \
	while read riga; do
	echo $riga

	#prende il codice del comune
	codice=`echo $riga | cut -d " " -f 1`

	#scarica il file
	wget -nc http://www.datigeo-piem-download.it/static/regp01/BDTRE2018_VECTOR/BDTRE_DATABASE_GEOTOPOGRAFICO_2018-LIMI_COMUNI_10_GAIMSDWL-$codice-EPSG32632-SHP.zip

	done

 
#entra nella directory dei files non zippati ed estrae i files della bdtre
cd ../$sbdtre
unzip -o ../$sbdtrez/\*.zip
