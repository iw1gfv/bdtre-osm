#!/bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"

#file per unire gli shp in modo da poterli vedere facilmente con qgis

#verifica che sia presente la cartella con i file sorgenti del BDTRE
if [[ ! -d $sbdtre ]]
then
  echo "Non esiste la cartella $sbdtre, fai girare lo script unzipbdtre.sh prima di questo"
  exit 1
fi


#crea la cartella per i file uniti se non è già esistente
if [ -d ~/bdtre-osm-piemonte/shp-uniti ]; then
    echo "~/bdtre-osm-piemonte/shp-uniti esiste."
else
    mkdir ~/bdtre-osm-piemonte/shp-uniti
fi


#cancella i file nella directory
rm -r ~/bdtre-osm-piemonte/shp-uniti/*


cd $sbdtre  

for i in $(find . -type f -name "*.shp")  
	 do  
	  
	 #prende il nome del tipo di shp, togliendo dal primo all'ultimo _   
	 tmp2=${i#*_}  
	 tmp=`basename $tmp2`  
	 echo $tmp  
#	 tmp3=${tmp#*_}  
#	 echo $tmp3  
	 tipodishp=`echo "${tmp%\_*}"`  
         echo $tipodishp  
  

   #unisce i file shp  
      if [ -f "../shp-uniti/$tipodishp.shp" ]  
      then  
           echo "unisce"  
           ogr2ogr -f 'ESRI Shapefile' -update -append ../shp-uniti/$tipodishp.shp $i	   
      else  
            echo "crea shp"  
      ogr2ogr -f 'ESRI Shapefile' "../shp-uniti/$tipodishp.shp" $i
fi
done
