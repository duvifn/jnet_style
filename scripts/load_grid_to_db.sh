shp_dir=/media/duvi/Extreme/temp

for zip_file in $shp_dir/*.zip
do
    base_name=`basename $zip_file`
    output_folder=${shp_dir}/${base_name%.zip}
    unzip $zip_file -d $output_folder
    $output_folder
done