input=$1
base_name=`basename $input`
vec_basename=${base_name%.*}
feature_count=$( ogrinfo $input -sql "SELECT COUNT(*) FROM ${vec_basename}" | grep -i 'COUNT_\* (Integer) =' | sed -e 's/ //g' | cut -d "=" -f2 )
echo $feature_count