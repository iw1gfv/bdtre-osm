#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"





###################################### Unisce i file osm/
cd $uscitaosm
rm merge.osm
#osmconvert *.osm  -o=merge.osm




filesdaunire=`ls *.osm`
for osm in $filesdaunire
do
    arg="$arg --rx $osm"
done


filesdaunire=`ls *.osm | head -n -1`

for osm in $filesdaunire
do
    arg="$arg --merge"
done


osmosis $arg --wx merge.osm


#echo $arg



#../$filepiemonteosm




# #punti
# python /home/michele/ogr2osm/ogr2osm.py --positive-id --add-version --add-timestamp --force /home/michele/Scrivania/BDTRE/sorgenti-bdtre/001066_bdtre2015/001066_ac_vei_2015.shp -o /home/michele/Scrivania/BDTRE/uscita-osm/ac_vei.osm
#
#
# #poligoni
# python /home/michele/ogr2osm/ogr2osm.py --id=20000 --positive-id --add-version --add-timestamp --force /home/michele/Scrivania/BDTRE/sorgenti-bdtre/001066_bdtre2015/001066_edifc_2015.shp -o /home/michele/Scrivania/BDTRE/uscita-osm/edfc.osm
#
# #edifici
# python /home/michele/ogr2osm/ogr2osm.py --id=990000 --positive-id --add-version --add-timestamp --force /home/michele/Scrivania/BDTRE/sorgenti-bdtre/001066_bdtre2015/001066_el_idr_2015.shp -o /home/michele/Scrivania/BDTRE/uscita-osm/el_idr.osm
#
#
# #
# cd /home/michele/Scrivania/BDTRE/uscita-osm
# unisce

#
#
#
#
#
# #awk "NR==5{print \"<bounds minlat='44.0' minlon='6.0' maxlat='47.0' maxlon='10.0' origin='CGImap 0.4.0 (5218 thorn-01.openstreetmap.org)' /'>"}7\" merge.osm
#
# #awk 'NR==3{print "Exp1"}1' merge.osm
#
#
# #prova



