#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"

#-----------------------------------------

cd $uscitaosm
 rm bdtre.osm
 rm UNITO_*.pbf

##################################### Unisce i file osm/

#crea la lista dei tipi di files
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
############################################################### seconda parte

#Unisce i tipi di files in uno solo
#listafiles=`ls UNITO_*.pbf`
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
#$osmosis $arg $argmerge  --wb file=bdtre.pbf
$osmosis $arg $argmerge  --wb file=../$uscitaosm/bdtre.pbf omitmetadata=true
date



