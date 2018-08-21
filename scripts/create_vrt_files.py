import subprocess
import re
import os
from os import path
import glob
import errno
import argparse
import sys


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
    except OSError as exc: 
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
    if ulx - buffer <  0:
        u_lx = 0
        w_buffer = 0
    else:
        u_lx = ulx - buffer
        w_buffer = 1
    
    if uly - buffer <  0:
        u_ly = 0
        n_buffer = 0
    else:
        u_ly = uly - buffer
        n_buffer = 1

    x_multiplyer = 1 if u_lx == 0 else 2
    y_multiplyer = 1 if u_ly == 0 else 2
    step = cur_step_x + buffer * x_multiplyer
    if cols - u_lx < step:
        s_x = cols - u_lx
        e_buffer = 0
    else:
        s_x = step
        e_buffer = 1

    step = cur_step_y + buffer * y_multiplyer
    if rows - u_ly < step:
        s_y = rows - u_ly
        s_buffer = 0
    else:
        s_y = step
        s_buffer = 1
    
    # Create a name that indicates if a buffer was added or not, for each side
    # Some file types (vector for example) must start with a letter, since otherwise it's not SQL compliant
    str_buffer = 'a'+''.join(str(i) for i in [w_buffer, e_buffer, s_buffer, n_buffer]) + '_'
    clipped_vrt_file_name = output_prefix + str_buffer + 'uly' + str(u_ly) + '_ulx' + str(u_lx) + '_stpx' + str(s_x) + '_stpy' + str(s_y) + '.vrt'
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

