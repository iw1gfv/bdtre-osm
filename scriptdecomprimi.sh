#unzip \*.zip
#rinomina tutti i files togliendo la scritta BDTRE_2015_RASTER_BN_10_
cd /home/michele/Scrivania/bdtrecmonte



for file in BDTRE_2015_RASTER_BN_10_*.*
do
echo "$file"
newname=`echo "$file" | cut -c 25-`
echo $newname
mv ./"$file" ./"$newname"
done


