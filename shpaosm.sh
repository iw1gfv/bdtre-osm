#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"




#trova e copia i files che parteciperanno alla creazione della mappa dopo aver eliminato quelli già presenti.
rm $shpusati/*
rm $uscitaosm/*



cd $sbdtre



for tipo in $sdu
do 

	find -name "*$tipo*" -exec cp {} ../$shpusati  \;
done


###################################### converte in OSM

cd ../$shpusati

#5817956
#3937111698
id=3937119999


for s in $(ls *.shp)
	 do
	 echo "converto $s"
	 #converte in osm
python $ogr2osm --positive-id --id=$id --add-version --add-timestamp --force "$s" -o "../$uscitaosm/$s.osm" 


id=`expr $id + 200000`
done

###################################### modifica i dile osm in modo da far apaprire le scritte <caption> di mapsforge.


# toponomastica
cd ../$uscitaosm
sed -i 's/NOME/name/g' *_toponomastica_*

#curve di livello rimuove anche gli zeri finali sulla quota
#sed -i 's/CV_LIV_Q/name/g' *_cv_liv_* 
#sed -i 's/.000000000000000"/"/g' *_cv_liv_*




#PROBABILMENTE QUESTA PARTE È DA RIMUOVERE
# ###################################### Unisce i file osm/
# cd ../$uscitaosm
# rm merge.osm
#
#
# filesdaunire=`ls *.osm`
# for osm in $filesdaunire
# do
#     arg="$arg --rx $osm"
# done
#
#
# filesdaunire=`ls *.osm | head -n -1`
#
# for osm in $filesdaunire
# do
#     arg="$arg --merge"
# done
#
#
# osmosis $arg --wx merge.osm
# #echo $arg





