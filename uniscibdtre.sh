#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"

#-----------------------------------------

cd $uscitaosm

if [ -f merge.osm ]; then
    rm merge.osm
else
    echo "merge.osm NON esiste."
fi


lista=`ls *.osm`

for i in $lista
	 do
		
	#unisce i file osm
      if [ -f "merge.osm" ]
      then
           echo "unisce"
           osmosis --rx merge.osm --rx $i --merge --wx temp.osm
	   mv temp.osm	merge.osm
      else
           echo "crea merge.osm"
      cp $i merge.osm
fi
done
