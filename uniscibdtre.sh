#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"

#-----------------------------------------

cd $uscitaosm
rm merge.osm


# for f in *.osm
#
# do
#osmconvert *.pbf >merge.pbf
# done




# lista=`ls *.pbf`
#
# for i in $lista
# 	 do
# 		
# 	#unisce i file osm
#       if [ -f "merge.pbf" ]
#       then
#            echo "unisce"
#            $osmosis --rx merge.osm --rx $i --merge --wx temp.osm
# 	   mv temp.osm	merge.osm
#       else
#            echo "crea merge.osm"
#       cp $i merge.osm
# fi
# done


###################################### Unisce i file osm/


echo $sdu | tr ' ' '\n' >/tmp/tipi


cat /tmp/tipi | \
while read tipo; do
echo $tipo

listafiles=`ls *$tipo*.osm`
numfiles=`echo $listafiles | wc -w`
arg=""

let "nummerge = $numfiles - 1"
argmerge=`yes " --merge" | head -n $nummerge`

#crea gli argomenti di 
for osm in $listafiles
	do
	arg="$arg --rx $osm"
done 


#crea gli argomenti merge
argmerge=`yes " --merge" | head -n $nummerge`
echo $numfiles
echo $nummerge
echo $tipo
#osmconvert $arg >$tipo.pbf
 
$osmosis $arg $argmerge  --wx file=UNITO_$tipo.osm

done


