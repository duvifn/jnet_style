test_execute_async_with_jobs_number() {
  # global  
  number_of_jobs=2
  . ../execute_async.sh
  execute_async sleep 2
  execute_async sleep 4
  execute_async sleep 2
  j=`jobs | grep -i -v "done" | wc -l`
  assertTrue "[ $j -eq 2 ]"
  unset number_of_jobs
  wait
}

test_execute_async_with_default_jobs_number() {
  . ../execute_async.sh
  execute_async sleep 2
  execute_async sleep 4
  execute_async sleep 4
  execute_async sleep 4
  execute_async sleep 4
  execute_async sleep 4
  execute_async sleep 2
  j=`jobs | grep -i -v "done" | wc -l`
  assertTrue "[ $j -eq 6 ]"
  wait
}

test_try_and_log_produces_log() {
  mkdir -p ./tmp
  # global  
  log_path=./tmp/log.txt
  . ../try_and_log.sh
  try_and_log fake command  > /dev/null 2>&1
  assertTrue "[ -f $log_path ]" 
  unset log_path
  rm -r -f ./tmp
}

test_try_and_log_produces_log_in_default_location() {
  . ../try_and_log.sh
  try_and_log fake command  > /dev/null 2>&1
  assertTrue "[ -f ./log.txt ]" 
  rm -f ./log.txt
}

test_try_and_log_exit_if_exit_on_error_set() {
   mkdir -p ./tmp
  # global  
  log_path=./tmp/log.txt
  global_exit_on_error=yes

  . ../try_and_log.sh
  $( try_and_log fake command > /dev/null 2>&1 )

  assertTrue "[ "$?" -eq 1 ]" 
  assertTrue "[ -f ./tmp/log.txt ]" 
  unset log_path
  unset global_exit_on_error
  rm -r -f ./tmp
}

test_gdal_get_region_string() {
  raster_string=$( ../gdal_get_region_string.sh ./data/a0000N19W156_filled_3857.tif )
  assertEquals "$raster_string" "n=2273047.380 s=2155069.648 e=-17254574.326 w=-17365856.025 res=318.858736133093544"
}

test_ogr_feature_count() {
  feature_count=$( ../ogr_feature_count.sh ./data/N19W156_simplified20_clipped_final.shp )
  assertEquals $feature_count 446
}

test_grass_contours_script_fail_invalid_number_of_arguments() {
  ../grass_contours.sh bla > /dev/null 2>&1
  assertTrue "[ $? -eq 1 ]"
}

test_grass_contours_script_produces_2_shp_files() {
  mkdir -p ./tmp
  cd ../
  ./grass_contours.sh ./tests/data/a0000N19W156_filled_3857.tif ./tests/tmp/shp 100 ./tests/tmp/logs > /dev/null 2>&1
  assertTrue "[ $? -eq 0 ]"
  cd - > /dev/null 2>&1
  

  assertTrue "[ -f ./tmp/shp/a0000N19W156_filled_3857.shp ]" 
  assertTrue "[ -f ./tmp/shp/a0000N19W156_filled_3857_simplified20.shp ]" 
  rm -r -f ./tmp
}

test_grass_contours_script_produces_not_empty_shp_file() {
  mkdir -p ./tmp
  cd ../
  ./grass_contours.sh ./tests/data/a0000N19W156_filled_3857.tif ./tests/tmp/shp 100 ./tests/tmp/logs > /dev/null 2>&1
  feature_count=$( ./ogr_feature_count.sh ./tests/tmp/shp/a0000N19W156_filled_3857.shp )

  assertTrue "[ $feature_count -gt 0 ]"
  cd - > /dev/null 2>&1
  rm -r -f ./tmp
}

test_grass_contours_script_produces_shp_file_that_is_geographically_correct() {
  mkdir -p ./tmp
  cd ../
  ./grass_contours.sh ./tests/data/a0000N19W156_filled_3857.tif ./tests/tmp/shp 100 ./tests/tmp/logs > /dev/null 2>&1
  
  raster_string=$( ./gdal_get_region_string.sh ./tests/data/a0000N19W156_filled_3857.tif )
  raster_string=`echo $raster_string | sed -e 's/ /;/g'`
  eval $raster_string

  ext=`ogrinfo -al -geom=NO ./tests/tmp/shp/a0000N19W156_filled_3857.shp | grep -i Extent: | sed -e 's/ //g'`
  v_n=`echo $ext | cut -d"(" -f 3 | sed -e 's/)//g'| cut -d"," -f2`
  v_e=`echo $ext | cut -d"(" -f 3 | sed -e 's/)//g'| cut -d"," -f1`
  v_w=`echo $ext | cut -d"(" -f 2 | sed -e 's/)-//g' | cut -d"," -f1`
  v_s=`echo $ext | cut -d"(" -f 2 | sed -e 's/)-//g' | cut -d"," -f2`
  
  assertTrue "west is equal" "[ `echo "$v_w == $w" | bc -l` -eq 1 ]"
  assertTrue "east is equal" "[ `echo "$v_e == $e" | bc -l` -eq 1 ]"
  assertTrue "south is equal" "[ `echo "$v_s == $s" | bc -l` -eq 1 ]"
  assertTrue "north is equal" "[ `echo "$v_n == $n" | bc -l` -eq 1 ]"

  cd - > /dev/null 2>&1
  rm -r -f ./tmp
}

test_create_vrt_files_required_arguments() {
  python ../create_vrt_files.py > /dev/null 2>&1
  assertTrue "[ $? -ne 0 ]"
}

test_create_vrt_files_produces_vrt_file() {
  mkdir -p ./tmp
  python ../create_vrt_files.py -i ./data/a0000N19W156_filled_3857.tif -o ./tmp > /dev/null 2>&1
  assertTrue "[ `ls -l ./tmp/*.vrt | wc -l` -gt 0 ]"
  rm -r -f ./tmp
}

test_create_vrt_files_produces_vrt_file_that_is_geographically_correct() {
  mkdir -p ./tmp
  python ../create_vrt_files.py -i ./data/a0000N19W156_filled_3857.tif -o ./tmp > /dev/null 2>&1
  file_path=`ls ./tmp/*.vrt`
  raster_string_1=$( ../gdal_get_region_string.sh ./data/a0000N19W156_filled_3857.tif )
  raster_string_2=$( ../gdal_get_region_string.sh $file_path )
  assertEquals "$raster_string_1" "$raster_string_2"
  rm -r -f ./tmp
}

test_create_vrt_files_buffer_string_mask_zero() {
  mkdir -p ./tmp
  python ../create_vrt_files.py -i ./data/a0000N19W156_filled_3857.tif -o ./tmp > /dev/null 2>&1
  file_path=`ls ./tmp/*.vrt`
  base_name=`basename $file_path`
  assertEquals "${base_name:1:4}" "0000"
  rm -r -f ./tmp
}

test_create_vrt_files_correct_buffer_string_mask() {
  mkdir -p ./tmp
  data_file=./data/a0000N19W156_filled_3857.tif
  
  # Data file dimensions
  x_size=349
  x_size=370
  
  step=50
  buffer=5

  python ../create_vrt_files.py --step_x $step --step_y $step --buffer $buffer -i $data_file -o ./tmp > /dev/null 2>&1

  # Find a file that is at first row
  file_name=`ls -l ./tmp | grep -i a*_uly0 | head -n 1 | rev | cut -d" " -f1 | rev`
  base_name=`basename $file_name`
  
  #w_buffer, e_buffer, s_buffer, n_buffer
  assertEquals "Should ignore north buffer" "${base_name:4:1}" "0"
  assertEquals "Should add south buffer" "${base_name:3:1}" "1"

  # Find a file that is NOT at first row
  file_name=`ls -l ./tmp | grep -i a*_uly | grep -i -v a*_uly0 |  head -n 1 | rev | cut -d" " -f1 | rev`
  base_name=`basename $file_name`
  
  #w_buffer, e_buffer, s_buffer, n_buffer
  assertEquals "Should add north buffer" "${base_name:4:1}" "1"
  
  # Find a file that is at first column
  file_name=`ls -l ./tmp | grep -i "a*ulx0_*" | head -n 1 | rev | cut -d" " -f1 | rev`
  base_name=`basename $file_name`
  #echo ${base_name:1:4}
  
  #w_buffer, e_buffer, s_buffer, n_buffer
  assertEquals "Should ignore west buffer" "${base_name:1:1}" "0"
  assertEquals "Should add east buffer" "${base_name:2:1}" "1"
  
  # Find a file that is at last column
  last_col=`ls -l ./tmp | awk  '{ print $NF }' | awk  -F '_' '{ print $3 }' | awk -F 'x' '{ print $2 }' | sort -rn | head -n1`
  file_name=`ls -l ./tmp | grep -i "a*ulx${last_col}_*" | head -n 1 | rev | cut -d" " -f1 | rev`
  base_name=`basename $file_name`
  assertEquals "Should ignore east buffer" "${base_name:2:1}" "0"
  assertEquals "Should add west buffer" "${base_name:1:1}" "1"

  # Find a file that is at last row
  last_row=`ls -l ./tmp | awk  '{ print $NF }' | awk  -F '_' '{ print $2 }' | awk -F 'y' '{ print $2 }' | sort -rn | head -n1`
  file_name=`ls -l ./tmp | grep -i "a*uly${last_row}_*" | head -n 1 | rev | cut -d" " -f1 | rev`
  base_name=`basename $file_name`
  assertEquals "Should add north buffer" "${base_name:4:1}" "1"
  assertEquals "Should ignore south buffer" "${base_name:3:1}" "0"
  rm -r -f ./tmp
}

get_dataset_dimensions(){
  dataset=$1
  size_str=`gdalinfo $dataset | grep -i "Size is " | sed -e 's/Size is //g' | sed -e 's/ //g'`
  global_size_x=`echo $size_str | cut -d"," -f1`
  global_size_y=`echo $size_str | cut -d"," -f2`
}
test_create_vrt_files_correct_tile_size() {
  mkdir -p ./tmp
  data_file=./data/a0000N19W156_filled_3857.tif
  
  # Data file dimensions
  x_size=349
  x_size=370
  
  step=50
  buffer=5

  python ../create_vrt_files.py --step_x $step --step_y $step --buffer $buffer -i $data_file -o ./tmp > /dev/null 2>&1
  
  # find file in the first row
  #w_buffer, e_buffer, s_buffer, n_buffer
  file_name=`ls -l ./tmp/a1110_* |  head -n 1 | rev | cut -d" " -f1 | rev`
  get_dataset_dimensions $file_name
  assertEquals "File size should be with buffer * 2 on x" "${global_size_x}" $(( $step + $buffer * 2 ))
  assertEquals "File size should be with buffer * 1 on y" "${global_size_y}" $(( $step + $buffer ))

  # find file in the first col
  #w_buffer, e_buffer, s_buffer, n_buffer
  file_name=`ls -l ./tmp/a0111_* |  head -n 1 | rev | cut -d" " -f1 | rev`
  get_dataset_dimensions $file_name
  assertEquals "File size should be with buffer * 1 on x" "${global_size_x}" $(( $step + $buffer ))
  assertEquals "File size should be with buffer * 2 on y" "${global_size_y}" $(( $step + $buffer * 2 ))

   # Find a file that is at last column
  last_col=`ls -l ./tmp | awk  '{ print $NF }' | awk  -F '_' '{ print $3 }' | awk -F 'x' '{ print $2 }' | sort -rn | head -n1`
  file_name=`ls -l ./tmp | grep -i "a*ulx${last_col}_*" | head -n 1 | rev | cut -d" " -f1 | rev`
  base_name=`basename $file_name`
  get_dataset_dimensions ./tmp/$base_name
  assertTrue "[ ${global_size_x} -lt $(( $step + $buffer * 2 )) ]"

   # Find a file that is at last row
  last_row=`ls -l ./tmp | awk  '{ print $NF }' | awk  -F '_' '{ print $2 }' | awk -F 'y' '{ print $2 }' | sort -rn | head -n1`
  file_name=`ls -l ./tmp | grep -i "a*uly${last_row}_*" | head -n 1 | rev | cut -d" " -f1 | rev`
  base_name=`basename $file_name`
  get_dataset_dimensions ./tmp/$base_name
  assertTrue "[ ${global_size_y} -lt $(( $step + $buffer * 2 )) ]"
  
  unset global_size_x
  unset global_size_y
  rm -r -f ./tmp
}

test_compute_contours_script_produces_shp_file_that_is_geographically_correct() {
  mkdir -p ./tmp
  cd ../
  ./compute_contours.sh ./tests/data/a0000N19W156_filled_3857.tif ./tests/tmp/ 8 > /dev/null 2>&1
  
  raster_string=$( ./gdal_get_region_string.sh ./tests/data/a0000N19W156_filled_3857.tif )
  raster_string=`echo $raster_string | sed -e 's/ /;/g'`
  eval $raster_string

  file_name=`ls -l ./tests/tmp/shp/*.shp |  head -n 1 | rev | cut -d" " -f1 | rev`
  ext=`ogrinfo -al -geom=NO $file_name | grep -i Extent: | sed -e 's/ //g'`
  v_n=`echo $ext | cut -d"(" -f 3 | sed -e 's/)//g'| cut -d"," -f2`
  v_e=`echo $ext | cut -d"(" -f 3 | sed -e 's/)//g'| cut -d"," -f1`
  v_w=`echo $ext | cut -d"(" -f 2 | sed -e 's/)-//g' | cut -d"," -f1`
  v_s=`echo $ext | cut -d"(" -f 2 | sed -e 's/)-//g' | cut -d"," -f2`
  
  assertTrue "west is equal" "[ `echo "$v_w == $w" | bc -l` -eq 1 ]"
  assertTrue "east is equal" "[ `echo "$v_e == $e" | bc -l` -eq 1 ]"
  assertTrue "south is equal" "[ `echo "$v_s == $s" | bc -l` -eq 1 ]"
  assertTrue "north is equal" "[ `echo "$v_n == $n" | bc -l` -eq 1 ]"

  cd - > /dev/null 2>&1
  rm -r -f ./tmp

}

test_compute_contours_script_produces_error_log_file() {
  mkdir -p ./tmp/shp
  # make it read only
  chmod -R 0444 ./tmp/shp
  cd ../
  ./compute_contours.sh ./tests/data/a0000N19W156_filled_3857.tif ./tests/tmp/ 8 > /dev/null 2>&1
  log_number_of_lines=`cat ./tests/tmp/logs/log.txt | grep -i "Error" | wc -l`
  assertTrue "log file number of error_lines bigger than 0" "[ $log_number_of_lines -gt 0 ]"
  cd - > /dev/null 2>&1
  rm -r -f ./tmp
}

test_shade_script_produces_output_that_is_geographically_correct() {
  mkdir -p ./tmp
  ../shade.sh ./data/a0000N19W156_filled_3857.tif ./tmp 2 3 > /dev/null 2>&1
  file_path=`ls ./tmp/*.hillshade.tif`
  raster_string_1=$( ../gdal_get_region_string.sh ./data/a0000N19W156_filled_3857.tif )
  raster_string_2=$( ../gdal_get_region_string.sh $file_path )
  assertEquals "$raster_string_1" "$raster_string_2"
  rm -r -f ./tmp
}

test_shade_script_produces_output_that_its_size_is_correct_when_buffer_applied() {
  mkdir -p ./tmp
  cp ./data/a0000N19W156_filled_3857.tif ./tmp/a1111N19W156_filled_3857.tif
  buffer=4
  ../shade.sh ./tmp/a1111N19W156_filled_3857.tif ./tmp 2 $buffer > /dev/null 2>&1
  file_path=`ls ./tmp/*.hillshade.tif`
  
  get_dataset_dimensions ./tmp/a1111N19W156_filled_3857.tif
  src_size_in_pixels_x=${global_size_x}
  src_size_in_pixels_y=${global_size_y}

  unset global_size_x
  unset global_size_y
  get_dataset_dimensions $file_path
  target_size_in_pixels_x=${global_size_x}
  target_size_in_pixels_y=${global_size_y}

  unset global_size_x
  unset global_size_y

  assertEquals "target file was cropped according to supllied buffer size x" $(( $src_size_in_pixels_x - $target_size_in_pixels_x )) $(( $buffer * 2 ))
  assertEquals "target file was cropped according to supllied buffer size y" $(( $src_size_in_pixels_y - $target_size_in_pixels_y )) $(( $buffer * 2 ))
  rm -r -f ./tmp
}

test_shade_script_produces_output_that_its_size_is_correct_when_buffer_at_south_and_east_is_applied() {
  mkdir -p ./tmp

  #w_buffer, e_buffer, s_buffer, n_buffer
  input_file=./tmp/a0110N19W156_filled_3857.tif
  cp ./data/a0000N19W156_filled_3857.tif $input_file
  buffer=4
  ../shade.sh $input_file ./tmp 2 $buffer > /dev/null 2>&1
  file_path=`ls ./tmp/*.hillshade.tif`
  
  get_dataset_dimensions $input_file
  src_size_in_pixels_x=${global_size_x}
  src_size_in_pixels_y=${global_size_y}

  unset global_size_x
  unset global_size_y
  get_dataset_dimensions $file_path
  target_size_in_pixels_x=${global_size_x}
  target_size_in_pixels_y=${global_size_y}

  unset global_size_x
  unset global_size_y
  assertTrue "target file was cropped according to supllied buffer size x" "[ $(( $src_size_in_pixels_x - $target_size_in_pixels_x )) -eq $(( $buffer )) ]"
  assertTrue "target file was cropped according to supllied buffer size y" "[ $(( $src_size_in_pixels_y - $target_size_in_pixels_y )) -eq $(( $buffer )) ]"
  rm -r -f ./tmp
}

test_shade_all_script_produces_output_that_is_geographically_correct() {
  mkdir -p ./tmp
  output_file=./tmp/output.shade.tif
  ../shade_all.sh ./data/a0000N19W156_filled_3857.tif $output_file 2 3 > /dev/null 2>&1
  raster_string_1=$( ../gdal_get_region_string.sh ./data/a0000N19W156_filled_3857.tif )
  raster_string_2=$( ../gdal_get_region_string.sh $output_file )
  assertEquals "$raster_string_1" "$raster_string_2"
  rm -r -f ./tmp
}

. ./shunit2/shunit2