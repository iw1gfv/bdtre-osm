#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"

###################################### Unisce i file osm/
cd $uscitaosm
osmosis --rx merge.osm --rx ../$filepiemonteosm --merge --wx bdtre-osm.osm





