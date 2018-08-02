#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Illegal number of parameters. The following parameters are required: input_file and output_file."
    exit 1
fi

input_file=$1
output_file=$2
additional_parameters=" ${3:-""} "

log_path=${output_file}.error.log
. ./try_and_log.sh

try_and_log gdal_translate $additional_parameters -of GTiff $input_file $output_file
