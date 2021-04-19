#!/bin/bash

#Questo script estrae i file BDTRE vettoriale nella cartella dei file sorgenti


#carica il file di configuraione delle variabili
source "./configurazione"


#verifica che sia presente la cartella con i file scaricati del BDTRE
if [[ ! -d $sbdtrez ]]
then
  echo "Non esiste la cartella $sbdtrez, fai girare lo script scaricabdtre.sh prima di questo"
  exit 1
fi


#crea la cartella dei file sorgenti del BDTRE se non è già esistente
if [ -d $sbdtre ]; then
    echo "$sbdtre esiste."
else
    mkdir $sbdtre
fi


#rimuove i files eventualmente presenti nella cartella
echo
echo cancello i vecchi file
rm -r $sbdtre/*


#si sposta nella cartella dei file sorgenti
cd $sbdtrez


#inizia il ciclo di unione e creazione dei file shp in base alla tipologia
	for i in $(find . -type f -name "*.zip")  
		do
		
		#prende il nome del tipo di shp, togliendo dal primo all'ultimo _   
		tmp2=${i#*_GAIMSDWL-}  
		tmp=`basename $tmp2`  
		#echo $tmp  
		codice=`echo "${tmp%\-EPSG32632*}"`  
		echo $codice
		
		#crea la cartella dei file da unzippare se non è già esistente
		if [ -d ../$sbdtre/$codice ]; then
			echo "../$sbdtre/$codice esiste."
		else
			mkdir ../$sbdtre/$codice
		fi
		
	#decomprime il file
	unzip BDTRE_DATABASE_GEOTOPOGRAFICO_2021-LIMI_COMUNI_10_GAIMSDWL-$codice-EPSG32632-SHP.zip -d ../$sbdtre/$codice
			
	done

 
#ritorna nella cartella principale
cd ..
