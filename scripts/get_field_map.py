from osgeo import ogr
import sys

file_name = sys.argv[1]
ds = ogr.Open(file_name)
lyr = ds.GetLayer()

field_names = ['-1' if field.name != 'MGRS' else '1' for field in lyr.schema]

print(','.join(field_names))
