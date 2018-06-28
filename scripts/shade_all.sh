#!/bin/bash

#./shade_all.sh /media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/unpacked/filled_nodata/test/output_mercator_cubicspline.vrt /media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/test_shading2

if [ "$#" -lt 2 ]; then
    echo "Illegal number of parameters. The following parameters are required: input_file and output_dir."
    exit 1
fi

echo `date` Started...
. ./execute_async.sh
input_file=$1
output_dir=$2

mkdir -p $output_dir

buffer=3

echo Creating VRT files...
python create_vrt_files.py -i $input_file -o $output_dir -b $buffer

echo Creating hillshade files...
for vrt in $output_dir/*.vrt
do
    execute_async ./shade.sh $vrt ${vrt%%.vrt}.hillshade.tif 2 $buffer
done
wait

echo Creating unified hillshade file...
find $output_dir -iname *.hillshade.tif -exec echo {} >> $output_dir/file_list.txt \;
gdalbuildvrt -srcnodata -32768 -vrtnodata -32768 -input_file_list $output_dir/file_list.txt $output_dir/unified_hillshade.vrt
./translate.sh $output_dir/unified_hillshade.vrt $output_dir/unified_hillshade.tif "-a_nodata none -co COMPRESS=JPEG -co TILED=YES -co BIGTIFF=YES"
gdaladdo -ro --config TILED_OVERVIEW yes --config COMPRESS_OVERVIEW JPEG --config BIGTIFF_OVERVIEW YES --config INTERLEAVE_OVERVIEW PIXEL $output_dir/unified_hillshade.tif 2 4 8 16
echo `date` Done.