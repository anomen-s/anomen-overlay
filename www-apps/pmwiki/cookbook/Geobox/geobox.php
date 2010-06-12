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
  $res = 0;
  if (isset($m[$index]))
    $res = $m[$index];
  return $res;
}

function parse_coords($coords)
{
    $re_num = "\d+(?:.\d*)?";
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
    $regex_pre = "(N|S|)\s*(${re_coord})\s*(E|W|)\s*(${re_coord})";
    $regex_post = "()(${re_coord})\s*(N|S)\s*(${re_coord})\s*(E|W)";
    $m[] = '';
    if (preg_match("/^\s*${regex_pre}\s*\$/x", $coords, $m)) {
	$res["result"] = 'PRE';
	$res["pattern"] = $regexp_pre;
    }
    else if (preg_match("/^\s*${regex_post}\s*\$/x", $coords, $m)) {
	$res["result"] = 'POST';
	$res["pattern"] = $regexp_post;
	$m[1]=$m[6];$m[6]=$m[11]; // move directions
    } 
    else  {
	$res["result"] = 0;
    }    
    
    $res[0] = asint($m, 3) + asint($m, 4)/60 + asint($m, 5)/(60*60);
    $res[1] = asint($m, 8) + asint($m, 9)/60 + asint($m, 10)/(60*60);

    if ($m[1] == 'S') { $res[0] = -$res[0]; }
    if ($m[6] == 'W') { $res[1] = -$res[1]; }

        
    return $res;
}

function convert($c)
{
    $c['Nd'] = $c['N'] = $c[0];$c['S'] = -$c[0];
    $c['Ed'] = $c['E'] = $c[1];$c['W'] = -$c[1];

    // convert to [Nd.]°[Nm.]'[Ns]" and  [Nd.]°[Nm]'
    $c['Nd.'] = floor($c['Nd']);
    $c['Nm'] = ($c['Nd']-$c['Nd.'])*60;
    $c['Nm.'] = floor($c['Nm']);
    $c['Ns'] = ($c['Nm']-$c['Nm.'])*60;
    $c['Ns.'] = floor($c['Ns']);

    $c['Ed.'] = floor($c['Ed']);
    $c['Em'] = ($c['Ed']-$c['Ed.'])*60;
    $c['Em.'] = floor($c['Em']);
    $c['Es'] = ($c['Em']-$c['Em.'])*60;
    $c['Es.'] = floor($c['Es']);

    return $c;
}

function geomaps($param)
{
    $c = parse_coords($param);
    if ($c['result'] == COORDS_INVALID) {
	return "[Invalid ($param)]";
    } 
    else {
	return "$param: [[mapy:Loc:${c[0]} ${c[1]}|mapy]][[gmaps:${c[0]} ${c[1]}|google]]";
    }
}

function geobox($param)
{
    // TODO
}
