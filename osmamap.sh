#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"


#trasforma la mappa .osm in .map aggiungendo la bounding box
/home/michele/osmosis/bin/osmosis  --rx file=$uscitaosm/bdtre-osm.osm  --mw file=$uscitamap/bdtre-osm.map tag-conf-file=tag-mapping.xml bbox=45.313529,7.5997925,45.4851692,7.9266357

