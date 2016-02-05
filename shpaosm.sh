#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"


#verifica che sia presente la cartella con i file sorgenti del BDTRE
if [[ ! -d $sbdtre ]]
then
  echo "Non esiste la cartella $sbdtre, fai girare lo script unzipbdtre.sh prima di questo"
  exit 1
fi


#crea la cartella dei file uscita osm se non è già esistente
if [ -d $uscitaosm ]; then
    echo "OK - $uscitaosm esiste."
else
    mkdir $uscitaosm
fi



#rimuove i files in uscita
rm $uscitaosm/*

#id massimo preso dalla history di osm con 99 davanti, in modo che sia motlo superiore per parecchio tempo
id=993937119999


###################################### converte in OSM

cd $sbdtre


for tipo in $sdu
do 


for s in $(find -name "*$tipo*.shp" | cut -c3-)
	 do
	 echo "converto $s"
	 #converte in osm
nomeuscita=`basename $s`
python $ogr2osm --positive-id --id=$id --add-version --add-timestamp --force ./$s -o "../$uscitaosm/$nomeuscita.osm" 



# modifica i file osm in modo da far apaprire le scritte <caption> di mapsforge.

cd ../$uscitaosm
sed -i 's/NOME/name/g' *_toponomastica_*

#curve di livello rimuove anche gli zeri finali sulla quota
sed -i 's/QUOTA/name/g' *_l_altim_* 
sed -i 's/.0000"\/><tag k/"\/><tag k/g' *_l_altim_*



#Punti quotati
sed -i 's/QUOTA/name/g' *_p_altim_* 
sed -i 's/[0-9][0-9][0-9]"\/>/"\/>/g' *_p_altim_*

cd ../$sbdtre

#converte in pbf
$osmosis --rx ../$uscitaosm/$nomeuscita.osm --wb ../$uscitaosm/$nomeuscita.pbf omitmetadata=true
rm ../$uscitaosm/$nomeuscita.osm


id=`expr $id + 9000000`
done
done

#####################################

# toponomastica









