import subprocess
import re
import os
from os import path
import glob
import errno
import argparse
import sys

# input_file = '/media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/unpacked/filled_nodata/test/output.vrt'
# step_x = 7200
# step_y = 7200
# buffer = 100
# output_dir = '/media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/unpacked/filled_nodata/test/output'

parser = argparse.ArgumentParser(description='Takes an input file and produces a bunch of output files')
parser.add_argument('-i' ,'--input_file', metavar='INPUT_FILE', type=str,
                    help='a path to input file', required=True)
parser.add_argument('-o', '--output_dir', metavar='OTUPUT_DIR', type=str,
                    help='a path to output folder', required=True)
parser.add_argument('-x', '--step_x', metavar='STEP_X', type=int, default=7200,
                    help='How many pixels on the X axis the file should contain')
parser.add_argument('-y' ,'--step_y', metavar='STEP_Y', type=int, default=7200,
                    help='How many pixels on the Y axis the file should contain')
parser.add_argument('-b', '--buffer', metavar='BUFFER', type=int, default=100,
                    help='How many pixels of overlap between tiles')                 
args = parser.parse_args()

input_file = args.input_file
step_x = args.step_x
step_y = args.step_y
buffer = args.buffer
output_dir = args.output_dir

def mkdir_p(path):
    try:
        os.makedirs(path)
    except OSError as exc:  # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise

regex_max_id = r'.*max_id \(Integer\)[^\d]*(\d+)'
def get_max_way_node_ids(pbf_path):
    script_path = path.realpath(__file__)
    dir_path = path.dirname(script_path)

    info_nodes = subprocess.check_output(["ogrinfo", pbf_path, "-dialect", "sqlite","-sql", "select max(cast(osm_id as int)) AS max_id from points", "-oo", "CONFIG_FILE=%s/osmconf.ini" % dir_path])
    info_ways = subprocess.check_output(["ogrinfo", pbf_path, "-dialect", "sqlite","-sql", "select max(cast(osm_id as int)) AS max_id from lines", "-oo", "CONFIG_FILE=%s/osmconf.ini" % dir_path])

    node_max_id = re.search(regex_max_id, info_nodes).group(1)
    way_max_id = re.search(regex_max_id, info_ways).group(1)
    
    return (int(way_max_id), int(node_max_id))


regex_rows_cols = r'Size is (\d+)[, ]+(\d+)'
def get_cols_rows(input_file):
    info = subprocess.check_output(["gdalinfo", input_file])
    rows_cols = re.search(regex_rows_cols,info.decode('ascii'), re.MULTILINE)
    cols = int(rows_cols.group(1))
    rows = int(rows_cols.group(2))
    return (cols, rows)

def process_tile(input_file, ulx, uly, cur_step_x, cur_step_y, buffer, rows, cols, output_prefix, node_start_id, way_start_id):
   
    # Make small vrt
    u_lx = max(ulx - buffer, 0)
    u_ly =  max(uly - buffer, 0)
    x_multiplyer = 1 if u_lx == 0 else 2
    y_multiplyer = 1 if u_ly == 0 else 2
    s_x = min(cur_step_x + buffer * x_multiplyer, cols - u_lx)
    s_y = min(cur_step_y + buffer * y_multiplyer, rows - u_ly)

    clipped_vrt_file_name = output_prefix + 'uly' + str(u_ly) + '_ulx' + str(u_lx) + '_stpx' + str(s_x) + '_stpy' + str(s_y) + '.vrt'
    subprocess.check_call(["gdal_translate", "-of", "VRT", "-srcwin", str(u_lx), str(u_ly), str(s_x), str(s_y), input_file, clipped_vrt_file_name])


ulx = 0
uly = 0
index = 0
node_start_id = 0
way_start_id = 0
cols, rows = get_cols_rows(input_file)
cur_step_x = min(step_x, cols)
cur_step_y = min(step_y, rows)

mkdir_p(output_dir)

while uly < rows:
    while ulx < cols:
        output_prefix = path.join(output_dir,str(ulx) + '_' + str(uly))
        process_tile(input_file, ulx, uly, cur_step_x, cur_step_y, buffer, rows, cols, output_dir + '/', node_start_id, way_start_id)

        ulx += cur_step_x
        cur_step_x = min(step_x, cols - ulx)
    
    ulx = 0
    cur_step_x = min(step_x, cols - ulx)
    
    uly += cur_step_y
    cur_step_y = min(step_y, rows - uly)

