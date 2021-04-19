#!/bin/bash

#Questo script unisce i singoli file shp in un unico file shp (un file per tipo di shp) in modo da poterli vedere facilmente con Qgis


#carica il file di configuraione delle variabili
source "./configurazione"


#verifica che sia presente la cartella con i file sorgenti del BDTRE
if [[ ! -d $sbdtre ]]
then
  echo "Non esiste la cartella $sbdtre, fai girare lo script unzipbdtre.sh prima di questo"
  exit 1
fi


#crea la cartella per i file uniti se non è già esistente
if [ -d $shpuniti ]; then
    echo "$shpuniti esiste."
else
    mkdir $shpuniti
fi


#cancella i file eventualmente presenti nella cartella
echo
echo cancello i vecchi file
rm -r $shpuniti/*


#si sposta nella cartella dei file sorgenti
cd $sbdtre


#inizia il ciclo di unione e creazione dei file shp in base alla tipologia
for i in $(find . -type f -name "*.shp")  
	 do  
	  
	 #prende il nome del tipo di shp, togliendo dal primo all'ultimo _   
	 tmp2=${i#*}  
	 tmp=`basename $tmp2`  
	 echo $tmp  
	 tipodishp=`echo "${tmp%\_*}"`  
         echo $tipodishp  
  

   #unisce i file shp  
      if [ -f "../$shpuniti/$tipodishp.shp" ]  
      then  
           echo "unisce"  
           ogr2ogr -f 'ESRI Shapefile' -update -explodecollections -skipfailures -append ../$shpuniti/$tipodishp.shp $i	   
      else  
           echo "crea shp"  
           ogr2ogr -f 'ESRI Shapefile' "../$shpuniti/$tipodishp.shp" $i
fi

done


#ritorna nella cartella principale
cd ..
