#!/bin/bash

#./shade_all.sh /media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/unpacked/filled_nodata/test/output_mercator_cubicspline.vrt /media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/test_shading2/hillshade_30.tif 2 6

if [ "$#" -lt 3 ]; then
    echo "Illegal number of parameters. The following parameters are required: input_file, output_file, zFactor. Optional parameter: number of jobs"
    exit 1
fi

echo `date` Started...
. ./execute_async.sh
input_file=$1
output_file=$2
zFactor=$3
number_of_jobs=${4:-6}

log_path=${output_file}.error.log

output_dir=`dirname $output_file`
mkdir -p ${output_dir}/tmp

buffer=3 #3 pixels overlap is good enough

. ./try_and_log.sh

echo Creating VRT files...
python create_vrt_files.py -i $input_file -o ${output_dir}/tmp -b $buffer

echo Creating hillshade files...
for vrt in $output_dir/tmp/*.vrt
do
    base_name=`basename $vrt`
    execute_async ./shade.sh $vrt ${vrt%%.vrt}.hillshade.tif $zFactor $buffer ${base_name:1:4}
done
wait

echo Creating unified hillshade file...
find $output_dir/tmp -iname *.hillshade.tif -exec echo {} >> $output_dir/tmp/file_list.txt \;
try_and_log gdalbuildvrt -srcnodata -32768 -vrtnodata -32768 -input_file_list $output_dir/tmp/file_list.txt $output_dir/tmp/unified_hillshade.vrt
./translate.sh $output_dir/tmp/unified_hillshade.vrt $output_file "-a_nodata none -co COMPRESS=JPEG -co TILED=YES -co BIGTIFF=YES"

. ./report_errors.sh
report_errors $output_dir/tmp
err1=$?
report_errors $output_dir
err2=$?

if [ "$err1" -eq "0" ] && [ "$err2" -eq "0" ]
then
    # no errors
    rm -r -f ${output_dir}/tmp
else
    echo "The tmp folder was not deleted: " ${output_dir}/tmp
fi
# gdaladdo -ro --config TILED_OVERVIEW yes --config COMPRESS_OVERVIEW JPEG --config BIGTIFF_OVERVIEW YES --config INTERLEAVE_OVERVIEW PIXEL $output_dir/unified_hillshade.tif 2 4 8 16
echo `date` Done.