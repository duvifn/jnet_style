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
  ./grass_contours.sh ./tests/data/N19W156.filled.3857.tif ./tests/tmp/N19W156.shp 100 ./tests/tmp/N19W156.log > /dev/null 2>&1
  assertTrue "[ $? -eq 0 ]"
  cd - > /dev/null 2>&1
  

  assertTrue "[ -f ./tmp/N19W156.shp ]" 
  assertTrue "[ -f ./tmp/N19W156_simplified20.shp ]" 
  rm -r -f ./tmp
}

test_grass_contours_script_produces_not_empty_shp_file() {
  mkdir -p ./tmp
  cd ../
  ./grass_contours.sh ./tests/data/N19W156.filled.3857.tif ./tests/tmp/N19W156.shp 100 ./tests/tmp/N19W156.log > /dev/null 2>&1
  feature_count=$( ./ogr_feature_count.sh ./tests/tmp/N19W156.shp )

  assertTrue "[ $feature_count -gt 0 ]"
  cd - > /dev/null 2>&1
  rm -r -f ./tmp
}

. ./shunit2/shunit2