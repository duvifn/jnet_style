num_of_jobs=6
output_dir=./

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
        echo $url
        #wget -P $output_dir $url &
    done
done