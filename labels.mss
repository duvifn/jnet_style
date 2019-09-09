/* LABELS.MSS CONTENTS:
 * - place names
 * - area labels
 * - waterway labels 
 */

/* Font sets are defined in palette.mss */
// 

/* 10M */
#contours [one_hundred != true][fifty != true][ele != 0]{
  [zoom>=17][zoom<=19]{
    text-name:[ele];
    text-face-name:@sans;
    text-placement:line;
    text-fill:@road_text;
    text-halo-fill: @place_halo;
    text-halo-radius: 1;
    text-min-path-length: 200.0;
    text-spacing: 400.0;
    text-label-position-tolerance : 100;
    text-max-char-angle-delta: 10;
    text-size: 8;
  }
}
/* 50M */
#contours[fifty = true][ele != 0][zoom>=14][zoom<=17]{
  text-name:[ele] ;
  text-face-name:@sans;
  text-fill:@road_text;
  text-placement:line;
  [zoom=14] {text-fill: #aaa; } 
  [zoom > 14] {text-fill: #a2a2a2; }
  text-halo-fill: @place_halo;
  text-halo-radius: 1;
  text-min-path-length: 200.0;
  text-spacing: 400.0;
  text-label-position-tolerance : 100;
  text-max-char-angle-delta: 10;
  text-size: 8;
  [zoom >= 16] {text-size: 10; }
}

/* 100M */
#contours [one_hundred = true][fifty != true][ele != 0][zoom>=13][zoom<=17]{
  text-name:"[ele].replace('([0-9]+)\.(.+)','$1')";
  text-face-name:@sans;
  text-placement:line;
  text-fill:@road_text;
  text-halo-fill: @place_halo;
  text-halo-radius: 1;
  [zoom >= 16] {text-size: 10; }
}



/* ================================================================== */
/* PLACE NAMES
/* ================================================================== */

#place::country[type='country'][zoom>3][zoom<9] {
  text-name:'[name]';
  text-face-name:@sans_bold;
  text-placement:point;
  text-fill:@country_text;
  text-halo-fill: #aaa;
  text-halo-radius: 0.6;
  text-wrap-width: 30;
  [zoom=3] {
    text-size:10 + @text_adjust;
    text-wrap-width: 40;
  }
  [zoom=4] {
    text-size:11 + @text_adjust;
    text-wrap-width: 30;
  }
  [zoom>4] {
    text-size:18;
  }
  [zoom=5] {
    text-size:11 + @text_adjust;
    text-wrap-width: 30;
    text-line-spacing: 1;
  }
  [zoom=6] {
    text-size:12 + @text_adjust;
    text-character-spacing: 1;
    text-wrap-width: 40;
    text-line-spacing: 2;
  }
  [zoom=7] {
    text-size:14 + @text_adjust;
    text-character-spacing: 1.2;
  }
}

#place::state[type='state'][zoom>=5][zoom<=10] {
  text-name:'[name]';
  text-face-name:@sans_bold_italic;
  text-placement:point;
  text-fill:@state_text;
  text-halo-radius: 0;
  [zoom=6] {
    text-size:10 + @text_adjust;
    text-wrap-width: 40;
  }
  [zoom=7] {
    text-size:11 + @text_adjust;
    text-wrap-width: 50;
  }
  [zoom>8] {
    text-size:12;
    text-halo-radius: 0;
  }
  [zoom=8] {
    text-size:11 + @text_adjust;
    text-wrap-width: 50;
    text-line-spacing: 1;
  }
  [zoom=9] {
    text-size:12 + @text_adjust;
    text-character-spacing: 1;
    text-wrap-width: 80;
    text-line-spacing: 2;
  }
  [zoom=10] {
    text-size:14 + @text_adjust;
    text-character-spacing: 2;
  }
}

/* ---- Cities ------------------------------------------------------ */

#place::city[type='city'][zoom>=8][zoom<=15] {
  ::labels {
    text-name:'[name]';
    text-face-name:@sans;
    text-placement:point;
    text-fill:@city_text;
    text-halo-fill:@city_halo;
    text-halo-radius:0.5;
    
    [zoom<=8] {
      text-size: 9;
      text-halo-radius:0.3;
    }
    [zoom=9] {
      text-size:11;
      text-wrap-width: 60;
      //text-dy: -10;
    }
    [zoom=10] {
      text-size:12;
      text-wrap-width: 70;
    }
    [zoom=11] {
      text-size:12;
      text-character-spacing: 1;
      text-wrap-width: 80;
    }
    [zoom=12] {
      text-size:13;
      text-character-spacing: 1;
      text-wrap-width: 100;
    }
    [zoom=13] {
      text-size:14;
      text-character-spacing: 2;
      text-wrap-width: 200;
      text-transform: uppercase;
    }
    [zoom=14] {
      text-size:15;
      text-character-spacing: 4;
      text-wrap-width: 300;
      text-transform: uppercase;
    }
    [zoom=15] {
      text-size:16;
      text-character-spacing: 6;
      text-wrap-width: 400;
      text-transform: uppercase;
    }
   }
}

/* ---- Towns ------------------------------------------------------- */

#place::town[type='town'][zoom>=12][zoom<=17] {
  text-name:'[name]';
  text-face-name:@sans;
  text-placement:point;
  text-fill:@town_text;
  text-size:9;
  text-halo-fill: rgb(100,100,100);
  text-halo-radius:0.5;
  text-wrap-width: 50;

  [zoom>=12]{
    text-size:12;
    text-line-spacing: 1;
  }
  [zoom>=13]{
    text-transform: uppercase;
    text-character-spacing: 1;
    text-line-spacing: 2;
  }
  [zoom>=14]{
    text-size:13;
    text-character-spacing: 2;
    text-line-spacing: 3;
  }
  [zoom>=15]{
    text-size:14;
    text-character-spacing: 3;
    text-line-spacing: 4;
  }
  [zoom>=15]{
    text-size:15;
    text-character-spacing: 4;
    text-line-spacing: 5;
  }
  [zoom>=17]{
    text-size:16;
    text-character-spacing: 5;
    text-line-spacing: 6;
  }
}

/* ---- Other small places ------------------------------------------ */

#place::small[type='village'][zoom>=13],
#place::small[type='suburb'][zoom>=13],
#place::small[type='hamlet'][zoom>=13],
#place::small[type='neighbourhood'][zoom>=13] {
  text-name:'[name]';
  text-face-name:@sans;
  text-placement:point;
  text-fill:rgb(100,100,100) ;
  text-size:10;
  text-halo-fill:@other_halo;
  text-halo-radius:0.5;
  text-wrap-width: 30;
  [zoom>=14] {
    text-size:12;
    text-halo-fill:rgb(100,100,100) ;
    text-character-spacing: 1;
    text-wrap-width: 40;
    text-line-spacing: 1;
  }
  [zoom>=15] {
    text-halo-fill:rgb(100,100,100);
    text-transform: uppercase;
    text-character-spacing: 1;
    text-wrap-width: 60; 
    text-line-spacing: 1;
  }
  [zoom>=16] {
    text-size:12;
    text-character-spacing: 2;
    text-wrap-width: 120;
    text-line-spacing: 2;
  } 
  [zoom>=17] {
    text-size:13; 
    text-character-spacing: 3;
    text-wrap-width: 160;
    text-line-spacing: 4;
  }
  [zoom>=18] {
    text-size:14;
    text-character-spacing: 4;
    text-line-spacing: 6;
  }
}

#place::small[type='locality'][zoom>=15] {
  text-name:'[name]';
  text-face-name:@sans;
  text-placement:point;
  text-fill:@locality_text;
  text-size:9;
  text-halo-fill:@locality_halo;
  text-halo-radius:0;
  text-wrap-width: 30;
  [zoom>=16] {
    text-size:10;
    text-wrap-width: 60;
    text-line-spacing: 1;
  }
  [zoom>=17] {
    text-size:11;
    text-wrap-width: 120;
    text-line-spacing: 2;
  }
  [zoom>=18] {
    text-size:12;
    text-character-spacing: 1;
    text-line-spacing: 4;
  }
}

#poi[type='university'][zoom>=15],
#poi[type='hospital'][zoom>=16],
#poi[type='school'][zoom>=17],
#poi[type='library'][zoom>=17] {
  text-name:"[name]";
  text-face-name:@sans;
  text-size:10;
  text-wrap-width:30;
  text-fill: @poi_text;
}


/* ================================================================== */
/* WATERWAY LABELS
/* ================================================================== */

#waterway_label[type='river'][zoom>=13],
#waterway_label[type='canal'][zoom>=15],
#waterway_label[type='stream'][zoom>=17] {
  text-name: '[name]';
  text-face-name: @sans_italic;
  text-fill: @water * 0.75;
  text-halo-fill: fadeout(lighten(@water,5%),25%);
  text-halo-radius: 1;
  text-placement: line;
  text-min-distance: 400;
  text-size: 10;
  [type='river'][zoom=15],
  [type='canal'][zoom=17] {
    text-size: 11;
  }
  [type='river'][zoom>=16],
  [type='canal'][zoom=18] {
    text-size: 14;
    text-spacing: 300;
  }
}

/* ================================================================== */
/* ROAD LABELS
/* ================================================================== */

#motorway_label[zoom>=11][zoom<=14][reflen<=8] {
  shield-name: "[ref]";
  shield-size: 9;
  shield-face-name: @sans_bold;
  shield-fill: #fff;
  shield-file: url(img/shield-motorway-1.png);
  [type='motorway'] {
    [reflen=1] { shield-file: url(img/shield-motorway-1a.png); }
    [reflen=2] { shield-file: url(img/shield-motorway-2a.png); }
    [reflen=3] { shield-file: url(img/shield-motorway-3a.png); }
    [reflen=4] { shield-file: url(img/shield-motorway-4a.png); }
    [reflen=5] { shield-file: url(img/shield-motorway-5a.png); }
    [reflen=6] { shield-file: url(img/shield-motorway-6a.png); }
    [reflen=7] { shield-file: url(img/shield-motorway-7a.png); }
    [reflen=8] { shield-file: url(img/shield-motorway-8a.png); }
  }
  [type='trunk'] {
    [reflen=1] { shield-file: url(img/shield-trunk-1a.png); }
    [reflen=2] { shield-file: url(img/shield-trunk-2a.png); }
    [reflen=3] { shield-file: url(img/shield-trunk-3a.png); }
    [reflen=4] { shield-file: url(img/shield-trunk-4a.png); }
    [reflen=5] { shield-file: url(img/shield-trunk-5a.png); }
    [reflen=6] { shield-file: url(img/shield-trunk-6a.png); }
    [reflen=7] { shield-file: url(img/shield-trunk-7a.png); }
    [reflen=8] { shield-file: url(img/shield-trunk-8a.png); }
  }
  [zoom=11] { shield-min-distance: 120; } 
  [zoom=12] { shield-min-distance: 120; } 
  [zoom=13] { shield-min-distance: 120; }
  [zoom=14] { shield-min-distance: 180; }
}

#motorway_label[type='motorway'][zoom>9],
#motorway_label[type='trunk'][zoom>9] {
  text-name:"[name]";
  text-face-name:@sans_bold;
  text-placement:line;
  text-fill:@road_text;
  text-halo-fill:@road_halo;
  text-halo-radius:1;
  text-min-distance:60;
  text-size:10;
  [zoom=11] { text-min-distance:70; }
  [zoom=12] { text-min-distance:80; }
  [zoom=13] { text-min-distance:100; }
}

#mainroad_label[type='primary'][zoom>12],
#mainroad_label[type='secondary'][zoom>13],
#mainroad_label[type='tertiary'][zoom>13] {
  text-name:'[name]';
  text-face-name:@sans;
  text-placement:line;
  text-fill:@road_text;
  text-halo-fill:@road_halo;
  text-halo-radius:1;
  text-min-distance:60;
  text-size:11;
}

#minorroad_label[zoom>14] {
  text-name:'[name]';
  text-face-name:@sans;
  text-placement:line;
  text-size:9;
  text-fill:@road_text;
  text-halo-fill:@road_halo;
  text-halo-radius:1;
  text-min-distance:60;
  text-size:11;
}

/* ================================================================== */
/* ONE-WAY ARROWS
/* ================================================================== */
#motorway_label[zoom>=16],
#mainroad_label[zoom>=16],
#minorroad_label[zoom>=16] {
  [oneway = 'yes'],
  [oneway='-1'] {
     marker-placement:line;
     marker-max-error: 0.5;
     marker-spacing: 200;
     marker-file: url(img/icon/oneway.svg);
     [oneway='-1'] { marker-file: url(img/icon/oneway-reverse.svg); }
     [zoom=16] { marker-transform: "scale(0.5)"; }
     [zoom=17] { marker-transform: "scale(0.75)"; }
  }
}


/* ================================================================== */
/* TRAIN STATIONS
/* ================================================================== */

#train_stations[zoom>15]{
  point-file:url('img/icon/rail-12.png');
  [zoom>=17] { point-file:url('img/icon/rail-18.png'); }
}

/* ****************************************************************** */
/* ================================================================== */
/* LANDUSES AND NATURAL POINTS
/* ================================================================== */


  
 
#cliffs{
    [zoom>=13] {
       marker-placement:line;
       marker-max-error: 0.5;
       marker-spacing: 0;
       marker-file: url('img/cliff.svg');
    }
   [zoom>=15] {
       line-pattern-file: url('img/cliff2.svg');
    }
  }

@landcover-font-size: 10;
@landcover-wrap-width-size: 30; // 3 em
@landcover-line-spacing-size: -1.5; // -0.15 em
@landcover-font-size-big: 12;
@landcover-wrap-width-size-big: 36; // 3 em
@landcover-line-spacing-size-big: -1.8; // -0.15 em
@landcover-font-size-bigger: 15;
@landcover-wrap-width-size-bigger: 45; // 3 em
@landcover-line-spacing-size-bigger: -2.25; // -0.15 em
@landcover-face-name: @sans;
@standard-halo-radius: 1;
@standard-halo-fill: rgba(255,255,255,0.6);

.text[zoom >= 11] {
  [feature = 'landuse_military'],
  [feature = 'natural_wood'],
  [feature = 'landuse_forest'],
  [feature = 'boundary_national_park'],
  [feature = 'leisure_nature_reserve'] {
    [zoom >= 8][way_pixels > 3000][is_building = 'no'],
    [zoom >= 17] {
      text-name: "[name]";
      text-size: @landcover-font-size;
      text-wrap-width: @landcover-wrap-width-size;
      text-line-spacing: @landcover-line-spacing-size;
      [way_pixels > 12000] {
        text-size: @landcover-font-size-big;
        text-wrap-width: @landcover-wrap-width-size-big;
        text-line-spacing: @landcover-line-spacing-size-big;
      }
      [way_pixels > 48000] {
        text-size: @landcover-font-size-bigger;
        text-wrap-width: @landcover-wrap-width-size-bigger;
        text-line-spacing: @landcover-line-spacing-size-bigger;
      }
      text-face-name: @landcover-face-name;
      text-halo-radius: @standard-halo-radius;
      text-halo-fill: @standard-halo-fill;
      text-placement: interior;
      [feature = 'landuse_military'] {
        text-fill: darken(@military, 40%);
      }
      [feature = 'natural_wood'],
      [feature = 'landuse_forest'] {
        text-fill: #46673b;
      }
      [feature = 'boundary_national_park'],
      [feature = 'leisure_nature_reserve'] {
        text-fill: darken(@park, 70%);
      }
    }
  }

  [feature = 'military_danger_area'][is_building = 'no'] {
    [zoom >= 9][way_pixels > 3000],
    [zoom >= 17] {
      text-name: "[name]";
      text-size: @landcover-font-size;
      text-wrap-width: @landcover-wrap-width-size;
      text-line-spacing: @landcover-line-spacing-size;
      [way_pixels > 12000] {
        text-size: @landcover-font-size-big;
        text-wrap-width: @landcover-wrap-width-size-big;
        text-line-spacing: @landcover-line-spacing-size-big;
      }
      [way_pixels > 48000] {
        text-size: @landcover-font-size-bigger;
        text-wrap-width: @landcover-wrap-width-size-bigger;
        text-line-spacing: @landcover-line-spacing-size-bigger;
      }
      text-fill: darken(@military, 20%);
      text-face-name: @landcover-face-name;
      text-halo-radius: @standard-halo-radius;
      text-halo-fill: @standard-halo-fill;
      text-placement: interior;
    }
  }
 }
#springs::labels[zoom>=15] {
    text-name:'[name]';
    text-face-name:@sans;
    text-size:10;
    [zoom>=16] { text-size:11; }
    text-fill: @water;// rgb(129,167,213); //#b3d6f6;
    text-halo-fill: rgb(129,167,213); //#b3d6f6;//@road_halo;
    text-halo-radius:0.4;
    text-placement: interior;
    text-dy: 7;
}
 
#natural_points["natural"='peak'][zoom>=13] {
      text-face-name:@sans;
      text-fill: #555555;
	  text-name: '[name]';
      text-placement: interior;
      text-dy: 7;
  	  text-halo-fill:@standard-halo-fill;
      text-size: @landcover-font-size;
      text-halo-radius: 1.0;
      [zoom>=14] { text-name: ''[name] + "\n" + [ele]''; }
}


#barrier_points[zoom>=17][stylegroup = 'divider'] {
  marker-height: 2;
  marker-fill: #c7c7c7;
  marker-line-opacity:0;
  marker-allow-overlap:true;
}