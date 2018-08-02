#!/bin/bash

#./compute_contours.sh /media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/unpacked/filled_nodata/test/output_mercator.vrt /media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/output34 8 /media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/output34/log.txt

if [ "$#" -ne 4 ]; then
    echo "Illegal number of parameters. The following parameters are required: input file, output dir, number of jobs and log path."
    exit 1
fi



input=$1
output_dir=$2
number_of_jobs=$3
log_path=$4
mkdir -p `dirname $log_path`

echo START `date` >> $log_path
# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
# define try_and_log function
. $SCRIPTPATH/try_and_log.sh
. $SCRIPTPATH/execute_async.sh

buffer=100
vrt_output=$output_dir/file_vrt
shp_output=$output_dir/shp
try_and_log python ./create_vrt_files.py --input_file $input --output_dir $vrt_output --buffer $buffer

for vrt in $vrt_output/*.vrt
do
    base_name=`basename $vrt`
    execute_async ./grass_contours.sh $vrt $shp_output/${base_name%%.vrt}.shp $buffer ${log_path}.${base_name}.error.log
done

wait

. $SCRIPTPATH/report_errors.sh
report_errors `dirname ${log_path}`
echo END `date` >> $log_path
