import os
from os import path
import argparse


parser = argparse.ArgumentParser(description='Takes a mapnik xml file and replaces paths and configs')
parser.add_argument('-i' ,'--input_file', metavar='INPUT_FILE', type=str,
                    help='a path to input mapnik.xml file', required=True)
parser.add_argument('-d', '--db_name', metavar='DB_NAME', type=str,
                    help='db name for osm data', required=True)
parser.add_argument('-u', '--user_name', metavar='USER_NAME', type=str, required=True,
                    help='user name')
parser.add_argument('-p' ,'--password', metavar='PASSWORD', type=str, required=True,
                    help='password')
parser.add_argument('-s', '--host', metavar='HOST', type=str, required=True,
                    help='''host for thh postgis db.
                            On this host should be 3 databases:
                            Osm data (the name for this db is configurable)
                            contours
                            contours_20
                            All the 3 databases should have a scheme of osm2pgsql rendering db
                    ''') 
parser.add_argument('-e', '--external_layers_folder', metavar='EXTERNAL_LAYER_FOLDER', type=str, required=True,
                    help='''A path that contains the following files: 
                    ne_places/ne_10m_populated_places.shp
                    hillshade_30.tif
                    hillshade_90.tif
                    hillshade_700.tif
                    hillshade_1000.tif
                    hillshade_5000.tif
                    ''')
parser.add_argument('-k' ,'--simplified_land_polygons', metavar='SIMPLIFIED_LAND_POLYGONS', type=str, required=True,
                    help='A path to simplified_land_polygons.shp')
parser.add_argument('-b' ,'--land_polygons', metavar='LAND_POLYGONS', type=str, required=True,
                    help='A path to land_polygons.shp')
parser.add_argument('-l' ,'--language', metavar='LANGUAGE', type=str, default='en',
                    help='A prefered language code in which to title places')                  
args = parser.parse_args()

# python replace_mapnik_style.py -i general_test.xml -d fake_dbname -u fake_user_name -p fake_password -s fake_host -e /fake_path/to/external/layers -k /media/duvi/Extreme/temp/openstreetmap-carto/data/simplified-land-polygons-complete-3857/simplified_land_polygons.shp -b /media/duvi/Extreme/temp/openstreetmap-carto/data/land-polygons-split-3857/land_polygons.shp
input_file=open(args.input_file).read()
input_file = input_file.replace('<Parameter name="dbname"><![CDATA[fake_db_name]]></Parameter>','<Parameter name="dbname"><![CDATA[' + args.db_name +']]></Parameter>')
input_file = input_file.replace('<Parameter name="user"><![CDATA[fake_user_name]]></Parameter>', '<Parameter name="user"><![CDATA[' +  args.user_name + ']]></Parameter>')
input_file = input_file.replace('<Parameter name="password"><![CDATA[fake_password]]></Parameter>', '<Parameter name="password"><![CDATA[' + args.password + ']]></Parameter>')
input_file = input_file.replace('<Parameter name="host"><![CDATA[fake_host]]></Parameter>', '<Parameter name="host"><![CDATA[' + args.host + ']]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/hillshade_30.tif]]></Parameter>', ' <Parameter name="file"><![CDATA[' + args.external_layers_folder + '/hillshade_30.tif]]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/hillshade_90.tif]]></Parameter>', '<Parameter name="file"><![CDATA[' + args.external_layers_folder + '/hillshade_90.tif]]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/hillshade_700.tif]]></Parameter>', '<Parameter name="file"><![CDATA[' + args.external_layers_folder + '/hillshade_700.tif]]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/hillshade_1000.tif]]></Parameter>', '<Parameter name="file"><![CDATA[' + args.external_layers_folder + '/hillshade_1000.tif]]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/hillshade_5000.tif]]></Parameter>', '<Parameter name="file"><![CDATA[' + args.external_layers_folder + '/hillshade_5000.tif]]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/ne_places/ne_10m_populated_places.shp]]></Parameter>', '<Parameter name="file"><![CDATA['  + args.external_layers_folder + '/ne_places/ne_10m_populated_places.shp]]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/land-low/simplified_land_polygons.shp]]></Parameter>', '<Parameter name="file"><![CDATA['  + args.simplified_land_polygons + ']]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/land-high/land_polygons.shp]]></Parameter>', '<Parameter name="file"><![CDATA[' + args.land_polygons  + ']]></Parameter>')
input_file = input_file.replace('tags -> \'name:en\'', 'tags -> \'name:' + args.language  + '\'')

       

with open(args.input_file, 'w') as of:
    of.write(input_file)