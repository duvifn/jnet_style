#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Illegal number of parameters. The following parameters are required: input file, output dir, and number of jobs"
    exit 1
fi



input=$1
output_dir=$2
number_of_jobs=$3
log_dir=$output_dir/logs
mkdir -p $log_dir
log_path=${log_dir}/log.txt

echo START `date` >> $log_path
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
# define try_and_log function
. $SCRIPTPATH/try_and_log.sh

buffer=100
vrt_output=$output_dir/file_vrt
shp_output=$output_dir/shp
try_and_log python ./create_vrt_files.py --input_file $input --output_dir $vrt_output --buffer $buffer > /dev/null 2>&1

ls $vrt_output/*.vrt | parallel -j${number_of_jobs} --eta "./grass_contours.sh {} $shp_output $buffer $log_dir > /dev/null 2>&1"

. $SCRIPTPATH/report_errors.sh
report_errors `dirname ${log_path}` >> $log_path

echo END `date`
echo END `date` >> $log_path
