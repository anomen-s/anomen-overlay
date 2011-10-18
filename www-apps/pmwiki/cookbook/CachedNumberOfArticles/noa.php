<?php if (!defined('PmWiki')) exit();

/*
    CachedNumberOfArticles script adds support for printing number of pages in wiki
    - add (:numberofarticles:) tag functionality
    - this version uses WikiDir->ls() to obtin number of articles

    Copyright 2006-2011 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

$RecipeInfo['CachedNumberOfArticles']['Version'] = '2011-10-13';

Markup('numberofarticles','inline','/\(:numberofarticles(\s+refresh)?\s*:\)/e',
    "Keep(getNumArticles('$1'))");

$NOAFile = "$WorkDir/.noa";

function refreshNumArticles()
{
   global $NOAFile;
   global $WikiDir;

   $count = count($WikiDir->ls());

   $f = fopen($NOAFile, 'w');
   fwrite($f, $count);
   fclose($f);

   return "<!--fresh-->$count\n";
}

function getNumArticles($refresh)
{
    global $NOAFile;
    $content = array();

    if (!empty($refresh)) {
	return refreshNumArticles();

    } else if (FALSE === ($content = @file($NOAFile))) {
	return refreshNumArticles();

    } else {      
	return implode('', $content);
    }
}

