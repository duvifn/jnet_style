/* BASE.MSS CONTENTS
 * - Landuse & landcover
 * - Water areas
 * - Water ways
 * - Administrative Boundaries
 *
 */

/* ================================================================== */
/* LANDUSE & LANDCOVER
/* ================================================================== */

Map { background-color: @water; }
#land-low[zoom>=0][zoom<10],
#land-high[zoom>=10][zoom<=18]{
   polygon-fill: @land;
   polygon-gamma: 0.75;   
  }

#landuse_gen0[zoom>3][zoom<=9],
#landuse_gen1[zoom>9][zoom<=12],
#landuse_residental[zoom>13] {
  [type='cemetery']      { polygon-fill: @cemetery; }
  [type='college']       { polygon-fill: @school; }
  [type='commercial']    { polygon-fill: @industrial; }
  [type='common']        { polygon-fill: @park; }
  [type='golf_course']   { polygon-fill: @sports; }
  [type='hospital']      { polygon-fill: @hospital; }
  [type='industrial']    { polygon-fill: @industrial; }
  [type='park']          { polygon-fill: @park; }
  [type='parking']       { polygon-fill: @parking; }
  [type='pedestrian']    { polygon-fill: @pedestrian_fill; }
  [type='pitch']         { polygon-fill: @sports; }
  [type='residential']   { polygon-fill: @residential; }
  [type='school']        { polygon-fill: @school; }
  [type='sports_center'] { polygon-fill: @sports; }
  [type='stadium']       { polygon-fill: @sports; }
  [type='university']    { polygon-fill: @school; }
}

#landuse[zoom=12] {
  [type='forest']        { polygon-fill: #E6F2C1; } 
  [type='grass']         { polygon-fill: #E6F2C1; }
  [type='wood']          { polygon-fill: #E6F2C1; } 
}

#landuse[zoom>12] {
  [type='forest']        { polygon-fill: #E6F2C1; } 
  [type='grass']         { polygon-fill: #E6F2C1; } 
  [type='wood']          { polygon-fill: #E6F2C1; }
}

#landuse_overlays[type='nature_reserve'][zoom>6] {
  line-color: darken(@wooded,25%);
  line-opacity:  0.3;
  line-dasharray: 1,1;
  polygon-fill: darken(@wooded,25%);
  polygon-opacity: 0.1;
  [zoom=7] { line-width: 0.4; }
  [zoom=8] { line-width: 0.6; }
  [zoom=9] { line-width: 0.8; }
  [zoom=10] { line-width: 1.0; }
  [zoom=11] { line-width: 1.5; }
  [zoom>=12] { line-width: 2.0; }
}
 
#landuse_overlays[type='wetland'][zoom>11] {
  [zoom>11][zoom<=14] { polygon-pattern-file:url(img/marsh-16.png); }
  [zoom>14] { polygon-pattern-file:url(img/marsh-32.png);}
  }

/* ---- BUILDINGS ---- */
#buildings[zoom>=12][zoom<=16] {
  polygon-fill:@building;
  [zoom>=14] {
    line-color:darken(@building,5%);
    line-width:0.2;
  }
  [zoom>=16] {
    line-color:darken(@building,10%);
    line-width:0.4;
  }
}
// At the highest zoom levels, render buildings in fancy pseudo-3D.
// Ordering polygons by their Y-position is necessary for this effect
// so we use a separate layer that does this for us.
#buildings[zoom>=17][type != 'hedge'] {
  building-fill:@building;
  building-height:1.25;
}

#buildings[zoom>=17][type = 'hedge'] {
  building-fill:@wooded;
  building-height:1.25;
}

#hillshade_90::z13[zoom=13] {
  image-filters: agg-stack-blur(1,1);
}

#hillshade_39::z14[zoom=14] {
  image-filters: agg-stack-blur(3,3);
}

#hillshade_30::z15[zoom=15] {
  image-filters: agg-stack-blur(8,8);
}

#hillshade_30::z16[zoom=16] {
  image-filters: agg-stack-blur(14,14);
}

#hillshade_30::z17[zoom=17] {
  image-filters: agg-stack-blur(24,24);
}
#hillshade_30::z18[zoom=18] {
  image-filters: agg-stack-blur(24,24);
}

#hillshade_5000 {
   [zoom>=1][zoom<=4]{
    raster-comp-op: multiply;
    raster-scaling: bilinear;
    raster-opacity:0.32;
  }
}

#hillshade_1000 {
   [zoom>=4][zoom<=6]{
    raster-comp-op: multiply;
    raster-scaling: bilinear;
    raster-opacity:0.32;
  }
}

#hillshade_700 {
   [zoom>=7][zoom<=8]{
    raster-comp-op: multiply;
    raster-scaling: bilinear;
    raster-opacity:0.32;
  }
}

#hillshade_90 {
  [zoom>=9][zoom<=12]{
    raster-comp-op: multiply;
    raster-scaling: bilinear;
    raster-opacity:0.32;
   }
  [zoom>=13][zoom<=14]{
    raster-comp-op: grain-merge;
    raster-scaling: bilinear;
    raster-opacity:0.6;
  }
}

#hillshade_30 {
  [zoom>=15][zoom<=18]{
    raster-comp-op: grain-merge;
    raster-scaling: bilinear;
    raster-opacity:0.6;
  }
}
/* ================================================================== */
/* WATER AREAS
/* ================================================================== */

#water_gen0[zoom>3][zoom<=9],
#water_gen1[zoom>9][zoom<=12],
#water[zoom>12] {
  polygon-fill: @water;
}

/* ================================================================== */
/* WATER WAYS
/* ================================================================== */

#waterway_low[zoom>=8][zoom<=12] {
  [int_intermittent='yes'] {
    line-dasharray:10,4;
  }
  line-color: @water;
  [zoom=8] { line-width: 0.1; }
  [zoom=9] { line-width: 0.2; }
  [zoom=10]{ line-width: 0.4; }
  [zoom=11]{ line-width: 0.6; }
  [zoom=12]{ line-width: 0.8; }
}

#waterway_med[zoom>=13][zoom<=14] {
  [int_intermittent='yes'] {
    line-dasharray:10,4;
  }
  line-color: @water;
  [type='river'],
  [type='canal'] {
    line-cap: round;
    line-join: round;
    [zoom=13]{ line-width: 1; }
    [zoom=14]{ line-width: 1.5; }
  }
  [type='stream'] {
    [zoom=13]{ line-width: 0.2; }
    [zoom=14]{ line-width: 0.4; }
  }
}
  
#waterway_high[zoom>=14] {
  line-color: @water;
  [int_intermittent='yes'] {
    line-dasharray:10,4;
  }
  [type='river'],
  [type='canal'] {
    line-cap: round;
    line-join: round;
    [zoom=15]{ line-width: 2; }
    [zoom=16]{ line-width: 3; }
    [zoom=17]{ line-width: 4; }
    [zoom=18]{ line-width: 5; }
    [zoom=19]{ line-width: 6; }
    [zoom>19]{ line-width: 7; }
  }
  [type='stream'] {
    [zoom>=14][zoom<=15]{ line-width: 1.0; }
    [zoom=16]{ line-width: 2; }
    [zoom=17]{ line-width: 2; }
    [zoom=18]{ line-width: 2; }
    [zoom>18]{ line-width: 2; }
  }
  [type='ditch'],
  [type='drain'] {
    [zoom=15]{ line-width: 0.1; }
    [zoom=16]{ line-width: 0.3; }
    [zoom=17]{ line-width: 0.5; }
    [zoom=18]{ line-width: 0.7; }
    [zoom=19]{ line-width: 1; }
    [zoom>19]{ line-width: 1.5; }
  }
}

/* ================================================================== */
/* ADMINISTRATIVE BOUNDARIES
/* ================================================================== */

#admin[admin_level='2'][zoom>1] {
    line-color:@admin_2;
    line-width:2;
    [zoom>=2][zoom<=9]{
        line-width:2;
    }
    [zoom=2] { line-opacity: 0.25; }
    [zoom=3] { line-opacity: 0.3; }
    [zoom=4] { line-opacity: 0.4; }
  /* Remove any maritime borders. Unfortunatly this is the only way to do this */
  ::maritime[maritime='yes'][zoom>1]{
    line-color: rgb(163,194,223);
    line-width:4;
    line-opacity: 1.0;
  }
}

/* ================================================================== */
/* NATURAL POINTS
/* ================================================================== */
#natural_points["natural"='peak'][zoom>=13] {
	  marker-file: url(img/peak_a.png);
      [zoom=13] {
   	     marker-height: 8;
  	     marker-width: 8;
         marker-fill-opacity: 0.5;
      }
      [zoom>13] {
         marker-height: 10;
  	     marker-width: 10;
       }
      marker-placement: interior;
}

#springs {
  [natural = 'spring'][zoom >= 14] {
    marker-file: url('res/spring.svg');
    marker-placement: interior;
    marker-clip: false;
    [zoom = 14] {
      marker-width: 5;
      marker-height: 5;
    }
    [zoom >= 15] {
      marker-width: 6.5;
      marker-height: 6.5;
    }
  }
}
/* ================================================================== */
/* INFRASTRUCTURE
/* ================================================================== */
#airports {
    ::poly {
    	[zoom>=10][zoom <= 13] {
      		polygon-fill:#cdcdcd;
    		line-color:darken(@land,10%);
    		line-width:0.6;
            [zoom = 12] { polygon-opacity: 0.7; }
            [zoom = 13] { polygon-opacity: 0.5; }
         }
    }
    ::points {
      [zoom>=10][zoom < 14][aeroway = 'aerodrome']['access' != 'private']['icao' != null]['iata' != null],
      [aeroway = 'aerodrome'][zoom >= 11][zoom < 14]{
          marker-height: 10;
          marker-width: 10;
          marker-file: url('res/airport-24.svg');
          marker-fill: #aaa;
          marker-line-opacity:0.6;
          //marker-allow-overlap:true;
          marker-placement: interior;
      }
    }
  }
/* ================================================================== */
/* BARRIER POINTS
/* ================================================================== */


#barrier_points[zoom>=17][stylegroup = 'divider'] {
  marker-height: 2;
  marker-fill: #c7c7c7;
  marker-line-opacity:0;
  marker-allow-overlap:true;
}

/* ================================================================== */
/* BARRIER LINES
/* ================================================================== */

#barrier_lines[zoom>=17][stylegroup = 'gate'] {
  line-width:2.5;
  line-color:#aab;
  line-dasharray:3,2;
}

#barrier_lines[zoom>=17][stylegroup = 'fence'] {
  line-width:1.75;
  line-color:#aab;
  line-dasharray:1,1;
}

#barrier_lines[zoom>=17][stylegroup = 'hedge'] {
  line-width:3;
  line-color:darken(@park,5%);

}
