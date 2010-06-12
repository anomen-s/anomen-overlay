<?php if (!defined('PmWiki')) exit();

/*
    This  script adds support for gps coordinates conversion and displaying at maps
    - add (:geo [format:] coords :) tag functionality

    Copyright 2006 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
    
    $Id: geobox.php 367 2009-07-28 15:46:10Z ludek $

    TODO:
    * geobox for conversions (is it useful?)
    * GPX export (see sourceblock for howto)
*/

define('COORDS_INVALID', 0);

$RecipeInfo['']['Version'] = '$Rev: 367 $';

Markup('geo','fulltext','/\(:geo\s+([dmsDMS,.]+:)?\s*(.*?)\s*:\)/e',
    "geomaps(strtoupper('$1'),'$2')");

Markup('geobox','fulltext','/\(:geobox\s+(.*?)\s*:\)/e',
    "geobox('$1')");

SDV($GeoBoxDefaultFormat,'DM');

function asint($m, $index) 
{
 //FIXME: convert ',' -> '.'
  
  $res = 0;
  if (isset($m[$index])) {
    $res = strtr($m[$index], ',', '.');
  }
  return $res;
}

function parse_coords($coords)
{
    $re_num = "\d+(?:[.,]\d*)?";
    $re_coord="
	    ([-+]?${re_num})
	    \s*
	    (?:°|˚|º||
		(?:
		    (?:°|˚|º)
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
	$res['pattern'] = $regexp_pre;
    }
    else if (preg_match("/^\s*${regex_post}\s*\$/xi", $coords, $m)) {
	$res['result'] = 'POST';
	$res['pattern'] = $regexp_post;
	$m[1]=$m[6];$m[6]=$m[11]; // move directions
    } 
    else  {
	$res['result'] = "";
    }    
    
    $res[0] = abs(asint($m, 3)) + asint($m, 4)/60 + asint($m, 5)/(60*60);
    $res[1] = abs(asint($m, 8)) + asint($m, 9)/60 + asint($m, 10)/(60*60);

    if (asint($m, 3) < 0) { $res[0] = -$res[0]; }
    if (asint($m, 8) < 0) { $res[1] = -$res[1]; }

    if (strtoupper($m[1]) == 'S') { $res[0] = -$res[0]; }
    if (strtoupper($m[6]) == 'W') { $res[1] = -$res[1]; }

        
    return $res;
}

function floor0($foo) 
{
    if($foo > 0) { return floor($foo); }
    else { return ceil($foo); }
}

function sign($foo) 
{
    if($foo < 0) { return "-"; } 
    else { return ""; }
}


// FIXME:: N = (NSig*Ndi)°Nmi'Ns''  = (NSig*Ndi)°Nm
function convert_coords($c)
{
    $c['LAT'] = ($c[0] > 0) ? "N" : "S";
    $c['LON'] = ($c[0] > 0) ? "E" : "W";
    
    $c['NSig'] = sign($c[0]);
    $c['ESig'] = sign($c[1]);

    $c['N'] = sprintf("%'08.5f",$c[0]);
    $c['E'] = sprintf("%'08.5f",$c[1]);
    $c['W'] = sprintf("%'08.5f",-$c[1]);
    $c['S'] = sprintf("%'08.5f",-$c[0]);
    $c['Nd'] = sprintf("%'08.5f",abs($c[0]));
    $c['Ed'] = sprintf("%'08.5f",abs($c[1]));

    //FIXME: negative numbers - do not return negative min, sec

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

function build_link($link, $coords) 
{
    foreach($coords as $ak => $av) {
	$k[] = "/!$ak(?![a-z])/i";
	$v[] = $av;
    }
    return preg_replace($k, $v, $link);
}

function geomaps($cformat, $param)
{
    global $GeoBoxDefaultFormat;

    $c = parse_coords($param);
    
    if (empty($c['result'])) {
	return "[Invalid ($param)]";
    } 
    else {
	$c = convert_coords($c);

	$LINK_MAPY="http://www.mapy.cz/?query=Loc:${c['N']}%20${c['E']}";
	$LINK_GMAPS="http://maps.google.com/?q=${c['N']}%20${c['E']}";
	$LINK_AMAPY="http://amapy.atlas.cz/?q=${c['Ndi']}°${c['Nmi']}'${c['Ns']}%22${c['LAT']};${c['Edi']}°${c['Emi']}'${c['Es']}%22${c['LON']}";
	$LINK_GC="http://www.geocaching.com/map/default.aspx?lat=${c['N']}&lng=${c['E']}";
	$LINK_GC_LIST="http://www.geocaching.com/seek/nearest.aspx?lat=${c['N']}&lng=${c['E']}&f=1";
	
	// FIXME - sign OR NS/EW
	//$COORDS="${c['NSig']}${c['Ndi']}°${c['Nm']} ${c['ESig']}${c['Edi']}°${c['Em']}";


	if (empty($cformat)) { 
		$cformat = $GeoBoxDefaultFormat; 
	}
	if (strpos($cformat, "S") !== false) {
		$COORDS=build_link("!NSig!Ndi°!Nmi'!Ns\" !ESig!Edi°!Emi'!Es\"", $c);// DMS
	}
	else if (strpos($cformat, "M") !== false) {
		$COORDS=build_link("!NSig!Ndi°!Nm' !ESig!Edi°!Em'", $c);// DM
	}
	else {
		$COORDS=build_link("!NSig!Nd !ESig!Ed", $c);//
	}
#	return Keep("<span><i>$COORDS</i><a href='$LINK_MAPY'>mapy</a> <a href='$LINK_GMAPS'>gmaps</a></span>");
	return "''$COORDS'' – [[$LINK_MAPY | mapy]] [[$LINK_GMAPS | gmaps]] [[$LINK_AMAPY | amapy]] [[$LINK_GC | gc]] [[$LINK_GC_LIST | gc list]]";
	
    }
}

function geobox($param)
{
    // TODO
}
