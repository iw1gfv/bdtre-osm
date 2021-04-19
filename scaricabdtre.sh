#!/bin/bash

#Questo script scarica i file BDTRE vettoriale


#carica il file di configuraione delle variabili
source "./configurazione"


#crea la cartella dei file ZIP del BDTRE se non è già esistente
if [ -d $sbdtrez ]; then
    echo "$sbdtrez esiste."
else
    mkdir $sbdtrez
fi


#rimuove i files eventualmente presenti nella cartella
echo
echo cancello i vecchi file
rm -r $sbdtrez/*


#si sposta nella cartella dei file zippati
cd $sbdtrez


#comincia il ciclo di scaricamento

#lista_comuni.txt scarica tutti i comuni della regione Piemonte, se desideri scaricare solo una delle province devi cambiare il file lista_comuni.txt con il file della provincia desiderata, i file relativi alle province sono all'interno della cartella comuni
#se desideri scaricare solo alcuni comuni puoi creare un file txt ad hoc e cambiare il file di scarico qui sotto

	#legge il file con i codici dei comuni
	cat ../Scarico/comuni/lista_comuni.txt | \
	while read riga; do
	echo $riga

	#prende il codice del comune
	codice=`echo $riga | cut -d " " -f 1`

	#scarica il file
	wget -nc http://www.datigeo-piem-download.it/static/regp01/BDTRE2021_VECTOR/BDTRE_DATABASE_GEOTOPOGRAFICO_2021-LIMI_COMUNI_10_GAIMSDWL-$codice-EPSG32632-SHP.zip

	done

 
#ritorna nella cartella principale
cd ..
