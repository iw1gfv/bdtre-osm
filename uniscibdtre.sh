#!/bin/bash

#Questo script crea un unico file PBF per ogni tipo di elemento inserito nella variabile sdu ed il file bdtre.pbf (serve per la mappa android).
#I file per tipo verranno presi successivamente per la creazione delle parti che compongo la mappa


#carica il file di configuraione delle variabili
source "./configurazione"


#verifica che sia presente la cartella con i file in formato PBF
if [[ ! -d $sbdtre ]]
then
  echo "Non esiste la cartella $uscitaosm, fai girare lo script shpaosm.sh prima di questo"
  exit 1
fi

#si sposta nella cartella dei file PBF
cd $uscitaosm


#elimina i file uniti eventualmente presenti
rm bdtre.pbf
rm UNITO_*.pbf


#Unisce i file PBF per tiopologia di elementi

#crea la lista dei tipi di file
echo $sdu | tr ' ' '\n' >/tmp/tipi

cat /tmp/tipi | \
while read tipo; do
echo $tipo

#crea gli argomenti per osmosis, con tutti i files e tutti i --merge, in --merge in meno dei files
listafiles=`ls *$tipo*.shp.pbf`
numfiles=`echo $listafiles | wc -w`
arg=""

let "nummerge = $numfiles - 1"
argmerge=`yes " --merge" | head -n $nummerge`

#crea gli argomenti con i files 
for osm in $listafiles
	do
	arg="$arg --rbf $osm"
done 

#crea gli argomenti con --merge
argmerge=`yes " --merge" | head -n $nummerge`
echo "$numfiles files da unire"


#converte
$osmosis $arg $argmerge  --wb file=UNITO_$tipo.pbf omitmetadata=true

done


#######


#Unisce i tipi di files in uno solo
listafiles=`ls UNITO_*.pbf`
numfiles=`echo $listafiles | wc -w`
echo $listafiles
arg=""

let "nummerge = $numfiles - 1"
argmerge=`yes " --merge" | head -n $nummerge`

#crea gli argomenti con i files 
for osm in $listafiles
	do
	arg="$arg --rbf $osm"
done

#crea gli argomenti con --merge
argmerge=`yes " --merge" | head -n $nummerge`
echo "$numfiles da unire"

#converte
$osmosis $arg $argmerge  --wb file=../$uscitaosm/bdtre.pbf omitmetadata=true
date
