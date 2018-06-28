#!/bin/bash

if [ "$#" -lt 4 ]; then
    echo "Illegal number of parameters. The following parameters are required: input_file, output_file, z value and buffer size."
    exit 1
fi

input_file=$1
output_file=$2
z=$3
buffer=$4

log_path=`dirname $output_file`/log.txt
. ./try_and_log.sh

try_and_log gdaldem hillshade -z $z -compute_edges $input_file ${output_file}.tmp.tif
size_in_pixels_x=`gdalinfo ${output_file}.tmp.tif | grep -i "Size is" | cut -d" " -f3 | sed -e 's/,//g'`
size_in_pixels_y=`gdalinfo ${output_file}.tmp.tif | grep -i "Size is" | cut -d" " -f4`

if [ "$size_in_pixels_x" = "" ];then 
    echo `date`": Error while executing gdalinfo. Input file: $input_file" >> $log_path
fi
xsize=$(( $size_in_pixels_x - $buffer ))
ysize=$(( $size_in_pixels_y - $buffer ))

try_and_log gdal_translate -srcwin $buffer $buffer $xsize $ysize ${output_file}.tmp.tif $output_file
try_and_log rm -f ${output_file}.tmp.tif