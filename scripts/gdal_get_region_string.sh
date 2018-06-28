input=$1
pixel_size=`gdalinfo $input | grep -i "pixel size" | cut -d" " -f4 | sed -e 's/(//g' | cut -d "," -f1`
upper_left_line=`gdalinfo $input | grep -i "Upper Left" | sed -e 's/ //g'`
west=`echo $upper_left_line | cut -d "(" -f2 | cut -d "," -f1`
north=`echo $upper_left_line | cut -d "(" -f2 | cut -d "," -f2 | sed -e 's/)//g'`
lower_right_line=`gdalinfo $input | grep -i "Lower Right" | sed -e 's/ //g'`
east=`echo $lower_right_line | cut -d "(" -f2 | cut -d "," -f1`
south=`echo $lower_right_line | cut -d "(" -f2 | cut -d "," -f2 | sed -e 's/)//g'`
echo n=$north s=$south e=$east w=$west res=$pixel_size

