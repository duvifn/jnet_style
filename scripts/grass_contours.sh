#!/bin/bash

# ./grass_contours.sh /media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/output9/file_vrt/uly0_ulx0_stpx7300_stpy7300.vrt /media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/output23/shp/uly0_ulx0_stpx7300_stpy7300.shp 100 /media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/output23/logs
# https://grasswiki.osgeo.org/wiki/GRASS_and_Shell


if [ "$#" -ne 4 ]; then
    echo "Illegal number of parameters. There should be input, output dir, buffer, log dir parameters"
    exit 1
fi


input=$1
output_dir=$2
buffer=$3
log_dir=$4

base_name=`basename $input`
output=${output_dir}/${base_name%.*}.shp

mkdir -p $log_dir
log_path=${log_dir}/${base_name}.error.log
buffer_mask_string=${base_name:1:4}
# https://askubuntu.com/questions/811439/bash-set-x-logs-to-file
#exec {FD}>>$log_path.full

# exec   > >(tee -ia $log_path.full)
# exec  2> >(tee -ia $log_path.full >& 2)
# exec {FD}> $log_path.full
# set -x
export BASH_XTRACEFD=$FD


SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
# define try_and_log function
. $SCRIPTPATH/try_and_log.sh

region_string=`$SCRIPTPATH/gdal_get_region_string.sh $input`

output_dir=`dirname $output`

out_basename=`basename $output`
vec_basename="${out_basename%.*}"

tmp_folder="${output_dir}/${vec_basename}/grassdata/"
try_and_log_func_dec=`cat $SCRIPTPATH/try_and_log.sh`
# create a directory (may be elsewhere) to hold the location used for processing
mkdir -p ${tmp_folder}

echo "export GRASS_MESSAGE_FORMAT=plain
log_path=${log_path}
global_exit_on_error=yes
$try_and_log_func_dec
try_and_log g.proj -c epsg=3857
try_and_log r.external input=$input band=1 output=$base_name.grass.tmp1 --overwrite -o
try_and_log g.region -a $region_string
try_and_log r.neighbors input=$base_name.grass.tmp1 method=average size=\"3\" output=$base_name.grass.tmp2 --overwrite
try_and_log g.region raster=$base_name.grass.tmp2
try_and_log r.contour input=$base_name.grass.tmp2 minlevel=\"-500\" maxlevel=\"10000\" step=\"10\" cut=\"7\" output=${vec_basename}_tmp --overwrite
line_str=\$( v.info -get map=${vec_basename}_tmp | grep \"lines=\" )
eval \$line_str
try_and_log v.out.ogr -s -e input=${vec_basename}_tmp type=line output=$tmp_folder/${vec_basename}.shp format=ESRI_Shapefile output_layer=output --overwrite
if [ \"\$lines\" -gt \"0\" ]
then
    try_and_log g.region -a $region_string
    try_and_log v.generalize input=${vec_basename}_tmp method=douglas threshold=\"20\" look_ahead=\"7\" reduction=\"50\" slide=\"0.5\" angle_thresh=\"3\" degree_thresh=\"0\" closeness_thresh=\"0\" betweeness_thresh=\"0\" alpha=\"1\" beta=\"1\" iterations=\"1\" -l output=${vec_basename}_simplified20 --overwrite
    # v.generalize input=${vec_basename}_tmp method=douglas threshold=\"10\" look_ahead=\"7\" reduction=\"50\" slide=\"0.5\" angle_thresh=\"3\" degree_thresh=\"0\" closeness_thresh=\"0\" betweeness_thresh=\"0\" alpha=\"1\" beta=\"1\" iterations=\"1\" -l output=${vec_basename}_simplified10 --overwrite
    try_and_log v.out.ogr -s -e input=${vec_basename}_simplified20 type=line output=$tmp_folder/${vec_basename}_simplified20.shp format=ESRI_Shapefile output_layer=output --overwrite
else
    rm -f $tmp_folder/${vec_basename}.shp
fi" > ${tmp_folder}/my_grassjob.sh

# make it user executable (this is important, use 'chmod' or via file manager)
try_and_log chmod u+x ${tmp_folder}/my_grassjob.sh

# create new temporary location for the job, exit after creation of this location
try_and_log grass -text -c $input ${tmp_folder}/mytemploc -e

#### 2) USING THE BATCH JOB
# define job file as environmental variable
export GRASS_BATCH_JOB="${tmp_folder}/my_grassjob.sh"

# now we can use this new location and run the job defined via GRASS_BATCH_JOB
try_and_log grass -text ${tmp_folder}/mytemploc/PERMANENT

#### 3) CLEANUP
# switch back to interactive mode, for the next GRASS GIS session
unset GRASS_BATCH_JOB


cut_buffer=$buffer
shp_output=`dirname $output`
base_name=`basename $input`
raster_string=`echo $region_string | sed -e 's/ /;/g'`

# set variables found in raster_string
# Example:  n=4028820.676;s=3375633.722;e=4230165.998;w=3673527.735;res=33.71113508425514
eval $raster_string
buffer_src_coords=`echo "$res * $cut_buffer" | bc`


west=`echo "${w} + ${buffer_src_coords} * ${buffer_mask_string:0:1}" | bc`
east=`echo "${e} - ${buffer_src_coords} * ${buffer_mask_string:1:1} " | bc`
south=`echo "${s} + ${buffer_src_coords} * ${buffer_mask_string:2:1} " | bc`
north=`echo "${n} - ${buffer_src_coords} * ${buffer_mask_string:3:1} " | bc`

# https://epsg.io/3857
xmin=`python -c "print max($west ,-20026376.39)"`
ymin=`python -c "print max($south ,-20048966.10)"`
xmax=`python -c "print max($east , $xmin)"`
ymax=`python -c "print max($north ,$ymin)"`

# Cut shape file
if [ -f $tmp_folder/${vec_basename}.shp ]; then
    # http://osgeo-org.1560.x6.nabble.com/Multipart-to-singlepart-td3746767.html
    try_and_log ogr2ogr -explodecollections -clipsrc $xmin $ymin $xmax $ymax -f "ESRI Shapefile" $output $tmp_folder/${vec_basename}.shp
fi

if [ -f $tmp_folder/${vec_basename}_simplified20.shp ]; then
    try_and_log ogr2ogr -explodecollections -clipsrc $xmin $ymin $xmax $ymax -f "ESRI Shapefile" $shp_output/${vec_basename}_simplified20.shp $tmp_folder/${vec_basename}_simplified20.shp
fi

try_and_log rm -rf ${tmp_folder}
