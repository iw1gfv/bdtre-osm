#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"




#trova e copia i files che parteciperanno alla creazione della mappa dopo aver eliminato quelli già presenti.
rm $shpusati/*
rm $shpuniti/*
rm $uscitaosm/*



cd $sbdtre


for tipo in $sdu
do 

	find -name "*$tipo*" -exec cp {} ../$shpusati  \;
done






#unconverte i files shp on osm
# cd ../$shpusati
#
#
# for i in $(ls *.shp)
# 	 do
# 	
# 	 #prende il nome del tipo di shp, togliendo dal primo all'ultimo _ 
# 	 tmp=${i#*_}
# 	 tipodishp=`echo "${tmp%\_*}"`
#          echo $tipodishp
#
#
# 	#unisce i file shp
#       if [ -f "../$shpuniti/$tipodishp.shp" ]
#       then
#            echo "creating shp"
#            ogr2ogr -f 'ESRI Shapefile' -update -append ../$shpuniti/$tipodishp.shp $i 
# 	 
#       else
#            echo "merging……"
#       ogr2ogr -f 'ESRI Shapefile' "../$shpuniti/$tipodishp.shp" $i
# fi
# done



###################################### converte in OSM

cd ../$shpusati


id=5000


for s in $(ls *.shp)
	 do
	 echo "converto $s"
	 #converte in osm
python /home/michele/ogr2osm/ogr2osm.py --positive-id --id=$id --add-version --add-timestamp --force "$s" -o "../$uscitaosm/$s.osm" 


id=`expr $id + 500000`
done





###################################### Unisce i file osm/
cd ../$uscitaosm
rm merge.osm


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




