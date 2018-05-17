#!/bin/bash

#Questo script converte i file dal formato SHP al formato OSM


#carica il file di configuraione delle variabili
source "./configurazione"


#verifica che sia presente la cartella con i file sorgenti del BDTRE
if [[ ! -d $sbdtre ]]
then
  echo "Non esiste la cartella $sbdtre, fai girare lo script scaricabdtre.sh prima di questo"
  exit 1
fi


#crea la cartella dei file uscita osm se non è già esistente
if [ -d $uscitaosm ]; then
    echo "OK - $uscitaosm esiste."
else
    mkdir $uscitaosm
fi



#rimuove i files eventualmente presenti nella cartella dei file in formato OSM
rm $uscitaosm/*


#id massimo preso dalla history di osm con 99 davanti, in modo che sia motlo superiore per parecchio tempo
id=993937119999


#si sposta nella cartella dei file SHP
cd $sbdtre


#inizia il ciclo

#prende i tipi di file che deve convertire, i tipi di file sono specificati nella variabile sdu presente nel file configurazione
for tipo in $sdu
do
#prende uno ad uno i file da convertire tra quelli specificati
for s in $(find -name "*$tipo*.shp" | cut -c3-)
	 do
	 echo "converto $s"
	 #converte il file in formato OSM
nomeuscita=`basename $s`
python $ogr2osm --positive-id --id=$id --add-version --add-timestamp --force ./$s -o "../$uscitaosm/$nomeuscita.osm" 


# modifica le etichette dei file OSM in modo da far apaprire le scritte <caption> di mapsforge.
#si sposta nella cartella dei file OSM
cd ../$uscitaosm

#Toponomastica, cambia l'etichetta NOME in name
#sed -i 's/NOME/name/g' *_toponomastica_*

#Curve di livello, cambia l'etichetta CV_LIV_Q in name e rimuove anche gli zeri dopo la virgola sulla quota
sed -i 's/CV_LIV_Q/name/g' *_cv_liv_* 
sed -i 's/.0000"\/><tag k/"\/><tag k/g' *_cv_liv_*

#Punti quotati, cambia l'etichetta Quota in name e rimuove anche i numeri dopo la virgola sul valore della quota
sed -i 's/PT_QUO_Q/name/g' *_pt_quo_* 
sed -i 's/[0-9][0-9][0-9][0-9][0-9][0-9]"\/>/"\/>/g' *_pt_quo_*

#Area bagnata da corso d'acqua, cambia l'etichetta S.N.
sed -i 's/S.N.//g' *_ab_cda_* 


#si sposta nella cartella 
cd ../$sbdtre

#converte in PBF per occupare meno spazio e rimuove il file in formato OSM
$osmosis --rx ../$uscitaosm/$nomeuscita.osm --wb ../$uscitaosm/$nomeuscita.pbf omitmetadata=true
rm ../$uscitaosm/$nomeuscita.osm


id=`expr $id + 9000000`
done
done
