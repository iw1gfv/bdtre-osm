#!/bin/bash
# #file per unire gli shp in modo da poterli vewdere facilmente con qgis

#
cd /home/michele/Scrivania/bdtre-osm/sorgenti-bdtre





for i in $(find . -type f -name "*loc_sg*.shp")
	 do
	
	 #prende il nome del tipo di shp, togliendo dal primo all'ultimo _ 
	 tmp2=${i#*_}
	 tmp=`basename $tmp2`
	 echo $tmp
	 tmp3=${tmp#*_}
	 tipodishp=`echo "${tmp3%\_*}"`
         


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