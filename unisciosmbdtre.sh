#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"


#scarica il file piemonte.bz2, se il download non riesce ferma lo script
cd $piemonteosm
#wget -O piemonte.osm.bz2 $urlpiemonte || { echo 'Download non riuscito' ; exit 1; }



#decomprime il file e sovrascrive quello precedente 
bzip2 -dkf piemonte.osm.bz2 || { echo 'Decompressione non riuscita' ; exit 1; }





###################################### Unisce i file osm/
cd ../$uscitaosm
$osmosis --rx merge.osm --rx ../$piemonteosm/piemonte.osm --merge --wx bdtre-osm.osm
