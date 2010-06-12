<?php if (!defined('PmWiki')) exit();

/*
    The noa script adds support for gps coordinates conversion and displaying at maps
    - add (:geo coords :) tag functionality

    Copyright 2006 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
    
    $Id$
*/

define('COORDS_INVALID', 0);

$RecipeInfo['']['Version'] = '$Rev$';

Markup('geo','fulltext','/\(:geo\s+(.*?)\s*:\)/e',
    "geomaps('$1')");

Markup('geobox','fulltext','/\(:geobox\s+(.*?)\s*:\)/e',
    "geobox('$1')");

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
	    (?:°|˚||
		(?:
		    (?:°|˚)
		    \s*
		    (${re_num})
		    \s*
		    (?:'| |
			(?:
			    (?:')
			    \s*
			    (${re_num})
			    \s*
			    (?:''|\"|“|”|)
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
    
    $res[0] = asint($m, 3) + asint($m, 4)/60 + asint($m, 5)/(60*60);
    $res[1] = asint($m, 8) + asint($m, 9)/60 + asint($m, 10)/(60*60);

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
    $c['ESig'] = sign($c[0]);
    
    $c['Nd'] = abs($c['N'] = $c[0]);$c['S'] = -$c[0];
    $c['Ed'] = abs($c['E'] = $c[1]);$c['W'] = -$c[1];

    //FIXME: negative numbers - do not return negative min, sec

    // convert to [Nd.]°[Nm.]'[Ns]" and  [Nd.]°[Nm]'
    $c['Ndi'] = floor0($c['Nd']);
    $c['Nm'] = abs(($c['Nd']-$c['Ndi'])*60);
    $c['Nmi'] = floor0($c['Nm']);
    $c['Ns'] = ($c['Nm']-$c['Nmi'])*60;
    $c['Nsi'] = floor0($c['Ns']);

    $c['Edi'] = floor0($c['Ed']);
    $c['Em'] = abs(($c['Ed']-$c['Edi'])*60);
    $c['Emi'] = floor0($c['Em']);
    $c['Es'] = ($c['Em']-$c['Emi'])*60;
    $c['Esi'] = floor0($c['Es']);

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

function geomaps($param)
{
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
	
	$COORDS=build_link("!NSig!Ndi°!Nm !ESig!Edi°!Em", $c);//
#	return Keep("<span><i>$COORDS</i><a href='$LINK_MAPY'>mapy</a> <a href='$LINK_GMAPS'>gmaps</a></span>");
	return "''$COORDS''  – [[$LINK_MAPY | mapy]] [[$LINK_GMAPS | gmaps]] [[$LINK_AMAPY | amapy]] [[$LINK_GC | gc]] [[$LINK_GC_LIST | gc list]]";
	
    }
}

function geobox($param)
{
    // TODO
}
