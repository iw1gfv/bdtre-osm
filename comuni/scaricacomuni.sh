#!/bin/bash
cd ../BDTRE


for i in {001001..001316} 
do
echo $i
wget http://www.datigeo-piem-download.it/static/regp01/BDTRE2016_VECTOR/BDTRE_DATABASE_GEOTOPOGRAFICO_2016-LIMI_COMUNI_10_GAIMSDWL-$i-EPSG32632-SHP.zip

done

