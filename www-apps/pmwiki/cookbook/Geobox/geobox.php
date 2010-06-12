<?php if (!defined('PmWiki')) exit();

/*
    The noa script adds support for gps coordinates conversion and displaying at maps
    - add (:geo coords :) tag functionality

    Copyright 2006 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

$RecipeInfo['']['Version'] = '$Rev$';

Markup('geo','fulltext','/\(:geo\s+(.*?)\s*:\)/e',
    "geobox('$1')");

$noafile = "$WorkDir/.noa";


function geobox($param)
{
    $re_num = "\d+(.\d*)?";
    $re_coord="(${re_num})\s*[°˚]?(${re_num}\s*([']?\s*(${re_num}\s*(''|\")?)?)?)?";
    $regex_pre = "(N|S)?\s*(${re_coord})\s*(E|W)?\s*(${re_coord})";
    $regex_post = "(${re_coord})\s*(N|S)?\s*(${re_coord})\s*(E|W)?";
    return "$param: [[mapy:Loc:$param|mapy]][[gmaps:$param|google]]";
}

