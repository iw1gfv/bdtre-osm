#!/bin/bash
# #file per unire gli shp in modo da poterli vewdere facilmente con qgis
# file=”merge.shp”
#
cd /home/michele/Scrivania/bdtre-osm/sorgenti-bdtre
# for i in $(find . -type f -name "*.shp")
# do
#
#       if [ -f “$file” ]
#       then
#            echo “creating final/merge.shp”
#            ogr2ogr -f ‘ESRI Shapefile’ -update -append $file $i
#       else
#            echo “merging……”
#       ogr2ogr -f ‘ESRI Shapefile’ $file $i
# fi
# done




for i in $(find . -type f -name "*bosco*.shp")
	 do
	
	 #prende il nome del tipo di shp, togliendo dal primo all'ultimo _ 
	 tmp2=${i#*_}
	 tmp=`basename $tmp2`
	 echo $tmp
	 tmp3=${tmp#*_}
	 echo $tmp3
	 tipodishp=`echo "${tmp3%\_*}"`
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