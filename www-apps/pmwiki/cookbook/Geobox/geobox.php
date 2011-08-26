<?php if (!defined('PmWiki')) exit();

/*
    This script adds support for gps coordinates conversion and displaying at maps
    - add (:geo [args] coords :) tag functionality

    Copyright 2006-2011 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
    
    TODO:
    * GPX export (see sourceblock for howto)
    * bearing calc. check 0deg, etc...
*/


$RecipeInfo['Geobox']['Version'] = '2011-08-24';


Markup('geo','fulltext','/\(:geo\s+((?:[dmsDMS,.]+:\s+)?(?:[a-z]+=\S+\s+)*)?(.*?)\s*:\)/e',
    "geobox_maps(strtolower('$1'),'$2')");

SDV($GeoBoxDefaultFormat,'dm');

SDVA($GeoBoxLinks, array(
 'maps.google.com'=>'http://maps.google.com/?q=$N%20$E',
 'mapy.cz'=>'http://www.mapy.cz/?query=Loc:$N%20$E',
//'atlas.cz'=>'http://amapy.atlas.cz/?q=$Ndi°$Nmi\'$Ns%22$LAT;$Edi°$Emi\'$Es%22$LON',
 'geocaching.com/maps'=>'http://www.geocaching.com/map/default.aspx?lat=$N&amp;lng=$E',
 'geocaching.com/near'=>'http://www.geocaching.com/seek/nearest.aspx?lat=$N&amp;lng=$E&amp;f=1'
));

function geobox_asint($m, $index) 
{
  $res = 0;
  if (isset($m[$index])) {
    $res = strtr($m[$index], ',', '.');
  }
  return $res;
}

function geobox_parse_coords($coords)
{
    $re_num = "\d+(?:[.,]\d*)?";
    $re_coord="
	    ([-+]?${re_num})
	    \s*
	    (?:°|˚|º|\*||
		(?:
		    (?:°|˚|º|\*)
		    \s*
		    (${re_num})
		    \s*
		    (?:'|’| |
			(?:
			    (?:'|’)
			    \s*
			    (${re_num})
			    \s*
			    (?:''|\"|“|”|’’|)
			)
		    )
		)
	    )?";
    $regex_pre = "(N|S|)\s*(${re_coord})\s*;?\s*(E|W|)\s*(${re_coord})";
    $regex_post = "()(${re_coord})\s*(N|S)\s*\;?s*(${re_coord})\s*(E|W)";
    $m[] = array();
    if (preg_match("/^\s*${regex_pre}\s*\$/xi", $coords, $m)) {
	$res['result'] = 'PRE';
	$res['pattern'] = $regex_pre;
    }
    else if (preg_match("/^\s*${regex_post}\s*\$/xi", $coords, $m)) {
	$res['result'] = 'POST';
	$res['pattern'] = $regex_post;
	$m[1]=$m[6];$m[6]=$m[11]; // move directions
    } 
    else  {
	$res['result'] = "";
    }    
    
    $res[0] = abs(geobox_asint($m, 3)) + geobox_asint($m, 4)/60 + geobox_asint($m, 5)/(60*60);
    $res[1] = abs(geobox_asint($m, 8)) + geobox_asint($m, 9)/60 + geobox_asint($m, 10)/(60*60);

    if (geobox_asint($m, 3) < 0) { $res[0] = -$res[0]; }
    if (geobox_asint($m, 8) < 0) { $res[1] = -$res[1]; }

    if (strtoupper($m[1]) == 'S') { $res[0] = -$res[0]; }
    if (strtoupper($m[6]) == 'W') { $res[1] = -$res[1]; }

        
    return $res;
}

function geobox_floor0($foo) 
{
    if($foo > 0) { return floor($foo); }
    else { return ceil($foo); }
}

function geobox_sign($foo) 
{
    return ($foo < 0) ? "-" : "";
}

function geobox_atan2($y, $x)
{
    if ($y == 0) {
      return ($x >= 0) ? 0 : pi();
    }
    return 2 * atan((sqrt($x*$x+$y*$y)-$x)/$y);
}
    


function geobox_convert_coords($c)
{
    $c['LAT'] = ($c[0] > 0) ? "N" : "S";
    $c['LON'] = ($c[1] > 0) ? "E" : "W";
    
    $c['NSig'] = geobox_sign($c[0]);
    $c['ESig'] = geobox_sign($c[1]);

    $c['N'] = sprintf("%'08.5f",$c[0]);
    $c['E'] = sprintf("%'08.5f",$c[1]);
    $c['W'] = sprintf("%'08.5f",-$c[1]);
    $c['S'] = sprintf("%'08.5f",-$c[0]);
    $c['Nd'] = sprintf("%'08.5f",abs($c[0]));
    $c['Ed'] = sprintf("%'08.5f",abs($c[1]));

    // convert to [Ndi]°[Nmi]'[Ns]" and  [Ndi]°[Nm]'
    $c['Ndi'] = sprintf("%'02.0f",floor($c['Nd']));
    $c['Nm']  = sprintf("%'06.3f",($c['Nd']-$c['Ndi'])*60);
    $c['Nmi'] = sprintf("%'02.0f",floor($c['Nm']));
    $s = ($c['Nd']*60);
    $c['Ns']  = sprintf("%'06.3f",($s-floor($s))*60);
    $c['Nsi'] = sprintf("%'02.0f",floor($c['Ns']));

    $c['Edi'] = sprintf("%'03.0f",floor($c['Ed']));
    $c['Em']  = sprintf("%'06.3f",($c['Ed']-$c['Edi'])*60);
    $c['Emi'] = sprintf("%'02.0f",floor($c['Em']));
    $s = ($c['Ed']*60);
    $c['Es']  = sprintf("%'06.3f",($s-floor($s))*60);
    $c['Esi'] = sprintf("%'02.0f",floor($c['Es']));
   
    return $c;
}

/*
 * Parses parameters and returns them in array.
 * 
 * If parameter is specified by uniquely distinguishable substring of known
 * parameter (e.g.: dist=10), 
 * full parameter value is also returned (e.g.: distance=10).  
 */ 
function geobox_parse_params($param)
{
  $known_params = array('format', 'azimuth', 'distance');
  
  $params = array('param' => $param);
  
  $pairs = preg_split("/\s+/", $param, -1, PREG_SPLIT_NO_EMPTY);
  foreach ($pairs as $p) {
    $tokens=explode('=', $p);
    if (strpos($tokens[0],":") !== false) {
        $params['format'] = $tokens[0];
    } else {
      $params[$tokens[0]] = $tokens[1];
      foreach ($known_params as $k) {
        if (strpos($k, $tokens[0]) === 0) {
          $params[$k] = $tokens[1];
        } 
      }
    }   
  }
  
  return $params;
}

function geobox_build_link($link, $c) 
{
   return preg_replace('/\\$([A-Za-z]+)/e', '$c[\'$1\']', $link);
}

function geobox_maps($param, $coords_param)
{
    global $GeoBoxDefaultFormat, $GeoBoxLinks;

    $c = geobox_parse_coords($coords_param);
    
    if (empty($c['result'])) {
	     return "[Invalid \"$coords_param\"]";
    }
    
    $params = geobox_parse_params($param);
    $cformat = $params['format'];
    
	  if (!empty($params['azimuth']) || !empty($params['distance'])) { 
  	  if (is_numeric($params['azimuth']) && is_numeric($params['distance'])) { 
         $c = geobox_projection($c[0], $c[1], $params['azimuth'], $params['distance']);
      } else {
  	     return "[Invalid azimuth \"${params['azimuth']}\" or distance \"${params['distance']}\"]";
      }
    }
	$c = geobox_convert_coords($c);

	if (empty($cformat)) { 
		$cformat = $GeoBoxDefaultFormat; 
	}
	if (strpos($cformat, "s") !== false) {
		$COORDS=geobox_build_link('$NSig$Ndi&#176;$Nmi\'$Ns" $ESig$Edi&#176;$Emi\'$Es"', $c);// DMS
	}
	else if (strpos($cformat, "m") !== false) {
		$COORDS=geobox_build_link('$NSig$Ndi&#176;$Nm\' $ESig$Edi&#176;$Em\'', $c);// DM
	}
	else {
		$COORDS=geobox_build_link('$NSig$Nd&#176; $ESig$Ed&#176;', $c);//
	}

  $result = "$COORDS";

  if (is_array($GeoBoxLinks) && !empty($GeoBoxLinks)) {
    $result .= " - ";
    foreach ($GeoBoxLinks as $t=>$l) {
      $l = geobox_build_link($l, $c);
      $result .= " [[$l | $t]]";
    }
  }
  
  return $result;
}

/**
 *  Calculates coordinates of point given by starting coordinates, azimuth and distance (meters).
 *  All angles are in degrees.  
 */ 
function geobox_projection($latitude_deg, $longtitude_deg, $azimuth_deg, $distance) {

    //source: geocaching_tool2.xls
    $ro =  pi() / 180.0;
    $R = 1.0/6378000;
    $DR = $distance*$R;
    $azimuth = $azimuth_deg*$ro;
    $latitude = $latitude_deg*$ro;
    
    $fi2 = sin($latitude)*cos($DR)+cos($latitude)*sin($DR)*cos($azimuth);
    //System.out.println("fi2="+fi2);
    $lat = asin($fi2);
    //System.out.println("lat="+lat);
    
    $x = (cos($DR)-sin($latitude)*sin($lat))/(cos($latitude)*cos($lat));
    //System.out.println("x="+x);
    $y = sin($DR)*sin($azimuth)/cos($lat);
    //System.out.println("y="+y);
    $la2 = geobox_atan2($y, $x); //MathUtil.atan2(y, x);
    //System.out.println("la2="+la2);
    $lon = $longtitude_deg + $la2/$ro;
    //System.out.println("lon="+lon);
          
    $ret = array();
    $ret[0] = $lat / $ro;
    $ret[1] = $lon;
    return $ret;
}


