import os
from os import path
import argparse


parser = argparse.ArgumentParser(description='Takes a mapnik xml file and replaces paths and configs')
parser.add_argument('-i' ,'--input_file', metavar='INPUT_FILE', type=str,
                    help='a path to input mapnik.xml file', required=True)
parser.add_argument('-m' ,'--input_project_file', metavar='INPUT_FILE', type=str,
                    help='a path to input project mml  file')
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
parser.add_argument('-j' ,'--ne_places', metavar='NE_PLACES', type=str, required=True,
                    help='A path to ne_10m_populated_places.shp')
parser.add_argument('-l' ,'--language', metavar='LANGUAGE', type=str, default='en',
                    help='A prefered language code in which to title places')                  
args = parser.parse_args()

# python replace_mapnik_style.py -i mapnik.xml -d fake_dbname -u fake_user_name -p fake_password -s fake_host -e /fake_path/to/external/layers -k /media/duvi/Extreme/temp/openstreetmap-carto/data/simplified-land-polygons-complete-3857/simplified_land_polygons.shp -b /media/duvi/Extreme/temp/openstreetmap-carto/data/land-polygons-split-3857/land_polygons.shp
input_file=open(args.input_file).read()
input_file = input_file.replace('<Parameter name="dbname"><![CDATA[$db_name]]></Parameter>','<Parameter name="dbname"><![CDATA[' + args.db_name +']]></Parameter>')
input_file = input_file.replace('<Parameter name="user"><![CDATA[$user_name]]></Parameter>', '<Parameter name="user"><![CDATA[' +  args.user_name + ']]></Parameter>')
input_file = input_file.replace('<Parameter name="password"><![CDATA[$password]]></Parameter>', '<Parameter name="password"><![CDATA[' + args.password + ']]></Parameter>')
input_file = input_file.replace('<Parameter name="host"><![CDATA[$host]]></Parameter>', '<Parameter name="host"><![CDATA[' + args.host + ']]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/hillshade_30.tif]]></Parameter>', ' <Parameter name="file"><![CDATA[' + args.external_layers_folder + '/hillshade_30.tif]]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/hillshade_90.tif]]></Parameter>', '<Parameter name="file"><![CDATA[' + args.external_layers_folder + '/hillshade_90.tif]]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/hillshade_700.tif]]></Parameter>', '<Parameter name="file"><![CDATA[' + args.external_layers_folder + '/hillshade_700.tif]]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/hillshade_1000.tif]]></Parameter>', '<Parameter name="file"><![CDATA[' + args.external_layers_folder + '/hillshade_1000.tif]]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/hillshade_5000.tif]]></Parameter>', '<Parameter name="file"><![CDATA[' + args.external_layers_folder + '/hillshade_5000.tif]]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/ne_places/ne_10m_populated_places.shp]]></Parameter>', '<Parameter name="file"><![CDATA['  + args.ne_places + ']]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/land-low/simplified_land_polygons.shp]]></Parameter>', '<Parameter name="file"><![CDATA['  + args.simplified_land_polygons + ']]></Parameter>')
input_file = input_file.replace('<Parameter name="file"><![CDATA[/home/duvi/Documents/MapBox/project/general/layers/land-high/land_polygons.shp]]></Parameter>', '<Parameter name="file"><![CDATA[' + args.land_polygons  + ']]></Parameter>')
input_file = input_file.replace('tags -> \'name:en\'', 'tags -> \'name:' + args.language  + '\'')

       

with open(args.input_file, 'w') as of:
    of.write(input_file)

if args.input_project_file:
    input_file=open(args.input_project_file).read()
    input_file.replace('"dbname": "fake_db_name"','"dbname": "' + args.db_name +'"')
    input_file = input_file.replace('"user": "fake_user_name"', '"user": "' +  args.user_name + '"')
    input_file = input_file.replace('"password": "fake_password"', '"password": "' + args.password + '"')
    input_file = input_file.replace('"host": "fake_host"', '"host": "' + args.host + '"')
    input_file = input_file.replace('/media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/hillshade_30.tif', args.external_layers_folder + '/hillshade_30.tif')
    input_file = input_file.replace('/media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/hillshade_90.tif', args.external_layers_folder + '/hillshade_90.tif')
    input_file = input_file.replace('/media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/hillshade_700.tif', args.external_layers_folder + '/hillshade_700.tif')
    input_file = input_file.replace('/media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/hillshade_1000.tif', args.external_layers_folder + '/hillshade_1000.tif')
    input_file = input_file.replace('/media/duvi/Extreme/TopoOSM/OpenTopoMap/raw/hillshade_5000.tif', args.external_layers_folder + '/hillshade_5000.tif')
    input_file = input_file.replace('/media/duvi/Extreme/TopoOSM/OpenTopoMap/osm-bright/osm-bright/shp/ne_10m_populated_places/ne_10m_populated_places.shp', args.external_layers_folder + '/ne_places/ne_10m_populated_places.shp')
    input_file = input_file.replace('/media/duvi/Extreme/TopoOSM/data/shp/land_low/simplified_land_polygons.shp', args.simplified_land_polygons)
    input_file= input_file.replace('/media/duvi/Extreme/TopoOSM/OpenTopoMap/osm-bright/osm-bright/shp/land-polygons-split-3857/land_polygons.shp', args.land_polygons)
    input_file = input_file.replace('tags -> \'name:en\'', 'tags -> \'name:' + args.language  + '\'')
    
    with open(args.input_project_file, 'w') as of:
        of.write(input_file)


