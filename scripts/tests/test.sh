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
  raster_string=$( ../gdal_get_region_string.sh ./data/N19W156.filled.3857.tif )
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
  ./grass_contours.sh ./tests/data/N19W156.filled.3857.tif ./tests/tmp/N19W156.shp 100 ./tests/tmp/N19W156.log 0000 > /dev/null 2>&1
  assertTrue "[ $? -eq 0 ]"
  cd - > /dev/null 2>&1
  

  assertTrue "[ -f ./tmp/N19W156.shp ]" 
  assertTrue "[ -f ./tmp/N19W156_simplified20.shp ]" 
  rm -r -f ./tmp
}

test_grass_contours_script_produces_not_empty_shp_file() {
  mkdir -p ./tmp
  cd ../
  ./grass_contours.sh ./tests/data/N19W156.filled.3857.tif ./tests/tmp/N19W156.shp 100 ./tests/tmp/N19W156.log 0000 > /dev/null 2>&1
  feature_count=$( ./ogr_feature_count.sh ./tests/tmp/N19W156.shp )

  assertTrue "[ $feature_count -gt 0 ]"
  cd - > /dev/null 2>&1
  rm -r -f ./tmp
}

test_grass_contours_script_produces_shp_file_that_is_geographiclly_correct() {
  mkdir -p ./tmp
  cd ../
  ./grass_contours.sh ./tests/data/N19W156.filled.3857.tif ./tests/tmp/N19W156.shp 100 ./tests/tmp/N19W156.log 0000 > /dev/null 2>&1
  
  raster_string=$( ./gdal_get_region_string.sh ./tests/data/N19W156.filled.3857.tif )
  raster_string=`echo $raster_string | sed -e 's/ /;/g'`
  eval $raster_string

  ext=`ogrinfo -al -geom=NO ./tests/tmp/N19W156.shp | grep -i Extent: | sed -e 's/ //g'`
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
  python ../create_vrt_files.py -i ./data/N19W156.filled.3857.tif -o ./tmp > /dev/null 2>&1
  assertTrue "[ `ls -l ./tmp/*.vrt | wc -l` -gt 0 ]"
  rm -r -f ./tmp
}

test_create_vrt_files_produces_vrt_file_that_is_geographiclly_correct() {
  mkdir -p ./tmp
  python ../create_vrt_files.py -i ./data/N19W156.filled.3857.tif -o ./tmp > /dev/null 2>&1
  file_path=`ls ./tmp/*.vrt`
  raster_string_1=$( ../gdal_get_region_string.sh ./data/N19W156.filled.3857.tif )
  raster_string_2=$( ../gdal_get_region_string.sh $file_path )
  assertEquals "$raster_string_1" "$raster_string_2"
  rm -r -f ./tmp
}

test_create_vrt_files_buffer_string_mask() {
  mkdir -p ./tmp
  python ../create_vrt_files.py -i ./data/N19W156.filled.3857.tif -o ./tmp > /dev/null 2>&1
  file_path=`ls ./tmp/*.vrt`
  base_name=`basename $file_path`
  assertEquals "${base_name:1:4}" "0000"
  rm -r -f ./tmp
}

. ./shunit2/shunit2