# see http://earth-info.nga.mil/GandG/coordsys/grids/mgrs_1km_polygon_dloads.html
# and https://en.wikipedia.org/wiki/Military_Grid_Reference_System
num_of_jobs=6
output_dir=/media/duvi/Extreme/mgrs_grid

mkdir -p $output_dir/tmp

log_path=$output_dir/log.txt

download() {
    # 1 = temp folder
    # 2 = url
    # 3 output folder

    base_name="${2##*/}"

    if [ ! -f $3/$base_name ] 
    then
        wget -P $1 $2
        echo $1 $2
        local status=$?
        if [ $status -ne 0 ]; then
            echo `date`": Error while excuting '$@'. Exit code was $status" >> $log_path
        else
            mv $1/$base_name $3/$base_name
        fi
    fi
}


for letter in {C..X}
do
    for number in {1..60}
    do
        while (( (( $(jobs | grep -i -v "done" | wc -l) )) >= $num_of_jobs )) 
        do 
            sleep 1      # check again after 1 seconds
        done

        padded="0"$number
        num=${padded: -2}
        url=http://earth-info.nga.mil/GandG/coordsys/zip/MGRS/MGRS_1km_polygons/MGRS_1km_${num}${letter}_unprojected.zip
        base_name="${url##*/}"
        echo $url
        ( download $output_dir/tmp $url $output_dir ) &
    done
done
wait