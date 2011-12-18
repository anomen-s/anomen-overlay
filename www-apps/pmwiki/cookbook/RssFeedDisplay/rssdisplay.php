<?php if (!defined('PmWiki')) exit();
/*

    Syntax
    (:RSS http://url.to.rss.feed/feed.rss <parameters> :)

    Examples:
    displays the feed of the pmwiki pages with the default layout and number of lines:
    (:RSS http://www.pmichaud.com/wiki/Pm/AllRecentChanges?action=rss :)
    
    displays the pmwiki feed in long layout and  the top 5 lines 
    (:RSS http://www.pmichaud.com/wiki/Pm/AllRecentChanges?action=rss long 5 :)

    displays the pmwiki feed in short layout and  all lines in the feed
    (:RSS http://www.pmichaud.com/wiki/Pm/AllRecentChanges?action=rss short -1 :)

    Copyright 2006-2011 Anomen (ludek_h@seznam.cz)
    Copyright 2005 http://www.brambring.nl
    Copyright 2005 http://mypage.iu.edu/~mweiner/index.html
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

*/

$RecipeInfo['RSSDisplay']['Version'] = '2011-12-18';

Markup('rssdisplay', 'fulltext', '/\(:RSS\s*(.*?)\s*:\)/e',"MagpieRSS('\$1')");


SDV($MagpieDir, "$FarmD/cookbook/magpie");
SDV($MagpieDebug, false);


SDV($MagpieEnableCache, false);
SDV($MagpieCacheAge, 2*60*60);
SDV($MagpieCacheDir, "$FarmD/cache");

SDV($MagpieFetchTimeout, 15);
SDV($MagpieGzip, true);
SDV($MagpieProxy, '');

SDV($MagpieDefaultItems, 30);
SDV($MagpieDefaultShowHeader, true);
SDV($MagpieDefaultShowDate, false);
SDV($MagpieDefaultShowContent, true);

SDV($MagpieOutputEncoding, $Charset);



function MagpieRssPhpInclude()
{
	static $MagpieRssPhpIncluded = false;
	if ($MagpieRssPhpIncluded) {
	    return;
	}
	global $MagpieDir;
	global $MagpieEnableCache, $MagpieCacheAge, $MagpieCacheDir;
	global $MagpieFetchTimeout, $MagpieGzip, $MagpieOutputEncoding, $MagpieProxy;

	$MagpieRssPhpIncluded = true;
	define('MAGPIE_CACHE_ON', $MagpieEnableCache);
	define('MAGPIE_CACHE_AGE', $MagpieCacheAge);
	define('MAGPIE_CACHE_DIR', $MagpieCacheDir);

	define('MAGPIE_FETCH_TIME_OUT', $MagpieFetchTimeout);
	define('MAGPIE_GZIP', $MagpieGzip);
	define('MAGPIE_PROXY', $MagpieProxy);
	define('MAGPIE_OUTPUT_ENCODING', $MagpieOutputEncoding);

	include("$MagpieDir/rss_fetch.inc");
}

function MagpieRSSDate($item) {
 # by http://www.pmwiki.org/wiki/Profiles/Mike
 $date = "";
 $rss_2_date = $item['pubdate'];
 $rss_1_date = $item['dc']['date'];
 $rss_3_date = $item['prism']['publicationDate'];
 $atom_date = $item['issued'];
 if ($atom_date != "") $date = parse_w3cdtf($atom_date);
 if ($rss_1_date != "") $date = parse_w3cdtf($rss_1_date);
 if ($rss_2_date != "") $date = strtotime($rss_2_date);
 if ($rss_3_date != "") $date = parse_w3cdtf($rss_3_date);
 if ($date == '-1') {
   if ($atom_date != "") $date = strtotime($atom_date);
   if ($rss_1_date != "") $date = strtotime($rss_1_date);
   if ($rss_3_date != "") $date = strtotime($rss_3_date);
 }
 if (($date != "") && ($date != '-1')) {
   $secondsinaday = 60 * 60 * 24;
   $dateformat = 'd M Y';
   $today = time();
   $yesterday = time() - $secondsinaday;
   $datetoday = date($dateformat, $today);
   $dateyesterday = date($dateformat, $yesterday);
   $daterss = date($dateformat, $date);
   if (($daterss == $datetoday) || ($daterss == $dateyesterday)) {
    $color = 'red';
   }
   else {
     $color = 'gray';
   }
   return '<div class="magpie-date" style="font-size:smaller;color:' . $color . '">' . $daterss . '</div>';
  }
  return '';
}

function MagpieRSS($regex) {
 global $action;
 global $FarmD;
 global $MAGPIE_ERROR, $MagpieDebug;
 global $MagpieDefaultItems;
 global $MagpieDefaultShowHeader, $MagpieDefaultShowContent, $MagpieDefaultShowDate;

 if (!IsEnabled($MagpieDebug)) {
    $OriginalError_reportingLevel = error_reporting();
    error_reporting(0);
 }
# If you make a call to your own site
# and you have any kind of WritePage action ( Lock(2) ) for example
# because you do some kind of logging in a wiki-page.
# the whole thing will deadlock, so remove any locks.
# ReadPage will request a lock again when needed
 Lock(-1);
 $line="";
 if ( $regex == '' ) {
  $line.="Empty parameter in RSS ";
 } else {
  $tokens=preg_split("/\s+/", $regex);

    $url=html_entity_decode($tokens[0]);
    $what=$MagpieDefaultShowContent;
    $num_items=$MagpieDefaultItems;
    $showheader = $MagpieDefaultShowHeader;
    $showdate = $MagpieDefaultShowDate;
    
    foreach ($tokens as $t) {
        if ($t == 'long') {	$what = true; }
        if ($t == 'short') { 	$what = false; }
        if ($t == 'header') { 	$showheader = true; }
        if ($t == 'noheader') {	$showheader = false; }
        if ($t == 'date') { 	$showdate = true; }
        if ($t == 'nodate') { 	$showdate = false; }
        if (is_numeric($t)) { 	$num_items = intval($t); }
    }

  if ( $action && (  $action != 'browse'  ) ) {
    # this is important
    #pmwiki processes DoubleBrackets in the rss module
    #recursion untill the server blows
    $line.= "RSS Feed : $url";
  } else {
    MagpieRssPhpInclude();

    $rss = fetch_rss($url);
    if ($rss) {
      $title = $rss->channel['title'];
      $link = $rss->channel['link'];
      
      if ( $showheader) {
          $line .= "<h2 class='rss'>RSS feed: <a href='$link'>$title</a></h2>\n";
      }
      if ( $num_items >= 0 ) {
        $items = array_slice($rss->items, 0, $num_items);
      } else {
        $items = $rss->items;
      }
      foreach ($items as $item) {
        #print_r ($item);
        $href = $item['link'];
        $title = $item['title'];
	$description = "-- empty -- ";
        if ( isset ($item['description']) ) {
          $description = $item['description'];
        }
        if ( isset ($item['atom_content']) ) {
          $description = $item['atom_content'];	
        }

        $link="<a class='urllink' href='$href'>$title</a>";
          $line .= "<h3 class='rss$what'>$link</h3>\n";
          if ($showdate) {
            $date = MagpieRSSDate($item);
            $line .= "$date \n" ;
          }
        if ($what) {
          $line .=  "<div class=\"magpie-desc\">$description</div>\n";
        }//if
           
      }//foreach
    }//if rss
    else {
     $line .= "<tt>$MAGPIE_ERROR</tt>";
    }
  }//else
 }

 if (!IsEnabled($MagpieDebug)) {
   error_reporting($OriginalError_reportingLevel);
 }
 $line="<div class='rss'>$line</div>";

 $rss_link = "\n%right% [[$url|RSS]]\n";

 return  Keep($line) . $rss_link;
}
