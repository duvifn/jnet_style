/* ****************************************************************** */
/* OSM BRIGHT BASED TOPOGRAPHIC STYLE                                 */
/* ****************************************************************** */

/* For basic style customization you can simply edit the colors and
 * fonts defined in this file. For more detailed / advanced
 * adjustments explore the other files.
 *
 * GENERAL NOTES
 *
 * There is a slight performance cost in rendering line-caps.  An
 * effort has been made to restrict line-cap definitions to styles
 * where the results will be visible (lines at least 2 pixels thick).
 */

/* ================================================================== */
/* FONTS
/* ================================================================== */

/* directory to load fonts from in addition to the system directories */
Map { font-directory: url(./fonts); }

/* set up font sets for various weights and styles */
@sans_lt:       "Open Sans Regular", "DejaVu Sans Book", "Arundina Sans Regular", "Padauk Regular", "Khmer OS Metal Chrieng Regular",
                "Mukti Narrow Regular", "gargi Medium", "TSCu_Paranar Regular", "Tibetan Machine Uni Regular", "Mallige Normal",
                "Droid Sans Fallback Regular", "Unifont Medium", "unifont Medium";


@sans_lt_italic:    "Open Sans Oblique", "DejaVu Sans Oblique", "Arundina Sans Italic", "TSCu_Paranar Italic", "Mallige NormalItalic",
                "DejaVu Sans Book", "Arundina Sans Regular", "Padauk Regular", "Khmer OS Metal Chrieng Regular",
                "Mukti Narrow Regular", "gargi Medium", "TSCu_Paranar Regular", "Tibetan Machine Uni Regular", "Mallige Normal",
                "Droid Sans Fallback Regular", "Unifont Medium", "unifont Medium";


@sans:          "Open Sans Semibold", "DejaVu Sans Book", "Arundina Sans Regular", "Padauk Regular", "Khmer OS Metal Chrieng Regular",
                "Mukti Narrow Regular", "gargi Medium", "TSCu_Paranar Regular", "Tibetan Machine Uni Regular", "Mallige Normal",
                "Droid Sans Fallback Regular", "Unifont Medium", "unifont Medium";

@sans_italic:   "Open Sans Semibold Italic",  "DejaVu Sans Oblique", "Arundina Sans Italic", "TSCu_Paranar Italic", "Mallige NormalItalic",
                "DejaVu Sans Book", "Arundina Sans Regular", "Padauk Regular", "Khmer OS Metal Chrieng Regular",
                "Mukti Narrow Regular", "gargi Medium", "TSCu_Paranar Regular", "Tibetan Machine Uni Regular", "Mallige Normal",
                "Droid Sans Fallback Regular", "Unifont Medium", "unifont Medium";


@sans_bold:  "Open Sans Bold", "DejaVu Sans Bold", "Arundina Sans Bold", "Padauk Bold", "Mukti Narrow Bold", "TSCu_Paranar Bold", "Mallige Bold",
             "DejaVu Sans Book", "Arundina Sans Regular", "Padauk Regular", "Khmer OS Metal Chrieng Regular",
             "Mukti Narrow Regular", "gargi Medium", "TSCu_Paranar Regular", "Tibetan Machine Uni Regular", "Mallige Normal",
             "Droid Sans Fallback Regular", "Unifont Medium", "unifont Medium";

@sans_bold_italic:  "Open Sans Bold Italic","DejaVu Sans Bold Oblique", "DejaVu Sans Oblique", "Arundina Sans Italic", "TSCu_Paranar Italic", "Mallige NormalItalic",
                "DejaVu Sans Book", "Arundina Sans Regular", "Padauk Regular", "Khmer OS Metal Chrieng Regular",
                "Mukti Narrow Regular", "gargi Medium", "TSCu_Paranar Regular", "Tibetan Machine Uni Regular", "Mallige Normal",
                "Droid Sans Fallback Regular", "Unifont Medium", "unifont Medium";

/* Some fonts are larger or smaller than others. Use this variable to
   globally increase or decrease the font sizes. */
/* Note this is only implemented for certain things so far */
@text_adjust: 0;

/* ================================================================== */
/* LANDUSE & LANDCOVER COLORS
/* ================================================================== */

@land:              #FCFBE7;
@water:             #C4DFF6;
@grass:             #E6F2C1;
@beach:             #FFEEC7;
@park:              #DAF2C1;
@cemetery:          #D6DED2;
@wooded:            #C3D9AD;
@agriculture:       #F2E8B6;

@building:          #d0d0d0;//#E4E0E0;
@hospital:          rgb(229,198,195);
@school:            #FFF5CC;
@sports:            #B8E6B8;

@residential:       rgba(247, 246, 226, 0.78);
@commercial:        @land * 0.97;
@industrial:        @land * 0.96;
@parking:           #EEE;
@military:          #f55;

/* ================================================================== */
/* ROAD COLORS
/* ================================================================== */

/* For each class of road there are three color variables:
 * - line: for lower zoomlevels when the road is represented by a
 *         single solid line.
 * - case: for higher zoomlevels, this color is for the road's
 *         casing (outline).
 * - fill: for higher zoomlevels, this color is for the road's
 *         inner fill (inline).
 */

@motorway_line:     #aaa; 
@motorway_fill:     #aaa;
@motorway_case:     #aaa; 

@trunk_line:        #aaa; 
@trunk_fill:        #aaa; 
@trunk_case:        #aaa; 

@primary_line:      #aaa; 
@primary_fill:      #aaa; 
@primary_case:      #aaa; 

@secondary_line:    #aaa; 
@secondary_fill:    #aaa; 
@secondary_case:    #aaa; 

@standard_line:     #aaa; 
@standard_fill:     #aaa; 
@standard_case:     #aaa; 

@pedestrian_line:   #aaa; 
@pedestrian_fill:   #aaa; 
@pedestrian_case:   #aaa;

@cycle_line:        @standard_line;
@cycle_fill:        #FAFAF5;
@cycle_case:        @land;

@rail_line:         #999;
@rail_fill:         #fff;
@rail_case:         @land;

@aeroway:           #ddd;

/* ================================================================== */
/* BOUNDARY COLORS
/* ================================================================== */

@admin_2:           rgb(255,255,255);

/* ================================================================== */
/* LABEL COLORS
/* ================================================================== */

/* We set up a default halo color for places so you can edit them all
   at once or override each individually. */
@place_halo:        fadeout(#fff,34%);

@country_text:      rgb(255,255,255);
@country_halo:      @place_halo;

@state_text:        rgb(255,255,255);
@state_halo:        @place_halo;

@city_text:         rgb(45,45,45);
@city_halo:         rgb(100,100,100);

@town_text:         #666;
@town_halo:         @place_halo;

@poi_text:          #888;

@road_text:         #777;
@road_halo:         #fff;

@other_text:        #888;
@other_halo:        @place_halo;

@locality_text:     #aaa;
@locality_halo:     @land;

/* Also used for other small places: hamlets, suburbs, localities */
@village_text:      #888;
@village_halo:      @place_halo;

/* ****************************************************************** */


