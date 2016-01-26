#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"


#unisce la bdtre con osm e trasforma in .map aggiungendo la bounding box
#$osmosis -v --rx file=$uscitaosm/bdtre-osm.osm  --mw file=$uscitamap/bdtre-osm.map tag-conf-file=tag-mapping.xml bbox=44,6,47,10 type=hd

$osmosis -v --rx file=$uscitaosm/bdtre.osm  --rx file=$piemonteosm/piemonte.osm --merge --mw file=$uscitamap/bdtre-osm.map tag-conf-file=tag-mapping.xml bbox=44,6,47,10 type=hd

