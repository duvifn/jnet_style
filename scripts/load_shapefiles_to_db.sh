#!/bin/bash

if [ "$#" -lt 4 ]; then
    echo "Illegal number of parameters. The following parameters are required: input directory, postgres host, user and log path."
    exit 1
fi

input_dir=$1
host=$2
user=$3
log_path=$4
number_of_jobs=${5:-6}

# https://askubuntu.com/questions/811439/bash-set-x-logs-to-file
exec   > >(tee -ia $log_path.full)
exec  2> >(tee -ia $log_path.full >& 2)
exec 19> $log_path.full

export BASH_XTRACEFD="19"
set -x

echo $number_of_jobs
echo START `date` >> $log_path
# https://stackoverflow.com/questions/4774054/reliable-way-for-a-bash-script-to-get-the-full-path-to-itself
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
# define try_and_log function
. $SCRIPTPATH/try_and_log.sh

#input_dir=/media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/output_21/shp/

echo Postgres password:
read password

counter=0

for shp in `find $input_dir -not -iname *_simplified20_* -iname *.shp`;
do 
    # ogr version >= 2.0
    echo loading $shp
    try_and_log ogr2ogr -explodecollections -update -append -mapFieldType Real=Integer -fieldmap 1 -f PostgreSQL "PG:dbname=contours host=$host user=$user password=$password" $shp -nln planet_osm_line
    echo $(( counter++ ))
done

for shp in `find $input_dir -iname *_simplified20_*.shp`;
do 
    echo loading $shp
    #shp=/media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/output_21/shp/uly0_ulx14300_stpx2212_stpy7300_clipped.shp
    # ogr version >= 2.0
    try_and_log ogr2ogr -explodecollections -update -append -mapFieldType Real=Integer -fieldmap 1 -f PostgreSQL "PG:dbname=contours_20 host=$host user=$user password=$password" $shp -nln planet_osm_line
    echo $(( counter++ ))
    

done
echo END `date` >> $log_path