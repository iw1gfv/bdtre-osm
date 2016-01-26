#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"

#-----------------------------------------

cd $uscitaosm
rm bdtre.osm
rm UNITO_*.osm

###################################### Unisce i file osm/

#crea la lista dei tipi di files
echo $sdu | tr ' ' '\n' >/tmp/tipi


cat /tmp/tipi | \
while read tipo; do
echo $tipo
#crea gli argomenti per osmosis, con tutti i files e tutti i --merge, in --merge in meno dei files
listafiles=`ls *$tipo*.shp.osm`
numfiles=`echo $listafiles | wc -w`
arg=""

let "nummerge = $numfiles - 1"
argmerge=`yes " --merge" | head -n $nummerge`

#crea gli argomenti con i files 
for osm in $listafiles
	do
	arg="$arg --rx $osm"
done 


#crea gli argomenti con --merge
argmerge=`yes " --merge" | head -n $nummerge`
echo "$numfiles files da unire"


#converte
$osmosis $arg $argmerge  --wx file=UNITO_$tipo.osm

done
################################################################ seconda parte

#Unisce i tipi di files in uno solo
listafiles=`ls UNITO_*.osm`
numfiles=`echo $listafiles | wc -w`
echo $listafiles
arg=""

let "nummerge = $numfiles - 1"
argmerge=`yes " --merge" | head -n $nummerge`

#crea gli argomenti con i files 
for osm in $listafiles
	do
	arg="$arg --rx $osm"
done 


#crea gli argomenti con --merge
argmerge=`yes " --merge" | head -n $nummerge`
echo $numfiles
echo $nummerge
echo $tipo

#converte
$osmosis $arg $argmerge  --wx file=bdtre.osm




