#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Illegal number of parameters. The following parameters are required: input_file, output_dir, z value, buffer size "
    exit 1
fi

input_file=$1
output_dir=$2
z=$3
buffer=$4

base_name=`basename $input_file`
output_file=${output_dir}/${base_name%.*}.hillshade.tif

log_dir=${output_dir}/logs
mkdir -p $log_dir
log_path=${log_dir}/${base_name}.error.log
buffer_mask_string=${base_name:1:4}

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
# define try_and_log function
. $SCRIPTPATH/try_and_log.sh


try_and_log gdaldem hillshade -z $z -compute_edges $input_file ${output_file}.tmp.tif
size_in_pixels_x=`gdalinfo ${output_file}.tmp.tif | grep -i "Size is" | cut -d" " -f3 | sed -e 's/,//g'`
size_in_pixels_y=`gdalinfo ${output_file}.tmp.tif | grep -i "Size is" | cut -d" " -f4`

if [ "$size_in_pixels_x" = "" ];then
    echo `date`": Error while executing gdalinfo. Input file: $input_file" >> $log_path
fi

src_x=`echo "${buffer} * ${buffer_mask_string:0:1}" | bc`
buffer_x=`echo "${buffer} * ${buffer_mask_string:1:1}" | bc`
buffer_y=`echo "${buffer} * ${buffer_mask_string:2:1}" | bc`
src_y=`echo "${buffer} * ${buffer_mask_string:3:1}" | bc`

xsize=$(( $size_in_pixels_x - $src_x - $buffer_x ))
ysize=$(( $size_in_pixels_y - $src_y - $buffer_y ))

try_and_log gdal_translate -srcwin $src_x $src_y $xsize $ysize ${output_file}.tmp.tif $output_file
try_and_log rm -f ${output_file}.tmp.tif