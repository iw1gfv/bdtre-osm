#! /bin/bash
#carica il file di configuraione delle variabili
source "./configurazione"


#crea la cartella per i file DTM5 se non è già esistente
if [ -d $sdtm ]; then
    echo "$sdtm esiste."
else
    mkdir $sdtm
fi

#crea la cartella per i file TIF se non è già esistente
if [ -d $tif ]; then
    echo "$tif esiste."
else
    mkdir $tif
fi


#rimuove i file all'interno della cartella che contiene gli zip del Dtm5
rm -r $sdtm/*

#rimuove i file all'interno della cartella che contiene i file raster del Dtm5
rm -r $tif/*

cd $sdtm

#scarica i file Dtm5
for i in {19..245} 
do
echo $i
wget http://www.datigeo-piem-download.it/static/regp01/DTM5_ICE/RIPRESA_AEREA_ICE_2009_2011_DTM-SDO_CTR_FOGLI50-$i-EPSG32632-TIF.zip

done

cd ../$tif

#scompatta il file hillshading
unzip -o ../$sdtm/\*.zip

cd ..
