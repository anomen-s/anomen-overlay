<?php if (!defined('PmWiki')) exit();
/*
     http://www.brambring.nl

     $Id: rssdisplay.php 295 2008-11-30 14:16:50Z ludek $

    Syntax
    (:RSS http://url.to.rss.feed/feed.rss <what> <parameters> :)

    Examples:
    displays the feed of the pmwiki pages with the default layout and number of lines:
    (:RSS http://www.pmichaud.com/wiki/Pm/AllRecentChanges?action=rss :)
    
    displays the pmwiki feed in long layout and  the top 5 lines 
    (:RSS http://www.pmichaud.com/wiki/Pm/AllRecentChanges?action=rss long 5 :)

    displays the pmwiki feed in short layout and  all lines in the feed
    (:RSS http://www.pmichaud.com/wiki/Pm/AllRecentChanges?action=rss short -1 :)
*/

$RecipeInfo['RSSDisplay']['Version'] = '2011-10-13';

Markup('rssdisplay', 'fulltext', '/\(:RSS\s*(.*?)\s*:\)/e',"RSS('\$1')");

define('MAGPIE_CACHE_AGE', 2*60*60);
//define('MAGPIE_CACHE_DIR', "$FarmD/cache");
define('MAGPIE_FETCH_TIME_OUT', 15);
define('MAGPIE_GZIP', true);


function RSS($regex) {
global $action;
global $FarmD;
global $MAGPIE_ERROR;

$OriginalError_reportingLevel = error_reporting();
error_reporting(0);
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

  $url      =html_entity_decode($tokens[0]);
  $what     =$tokens[1];
  $num_items=$tokens[2];
  $header   =$tokens[3];

  if ( $what == '' ) {
    $what='long';  // modified by anomen
  }

  if ( $num_items == 0 ) {
    $num_items=30;  // modified by anomen
  }
  if ( $action && (  $action != 'browse'  ) ) {
    # this is important
    #pmwiki processes DoubleBrackets in the rss module
    #recursion untill the server blows
    $line.= "RSS Feed : $url";
  } else {
//    include_once("$FarmD/cookbook/magpie/rss_fetch.inc");
    $rss = fetch_rss($url);
    if ($rss) {
      $title = $rss->channel['title'];
      $link = $rss->channel['link'];
      
      if ( $header != 'noheader') {
          $line .= "<h2 class='rss'>RSS feed: <a href='$link'>$title</a></h2>\n";
      }
      
      if ( $num_items > 0 ) { 
        $items = array_slice($rss->items, 0, $num_items);
      } else {
        $items = $rss->items;
      }
      foreach ($items as $item) {
        #print_r ($item);
        $href = $item['link'];
        $title = $item['title'];	
	$description = "-- empty -- "; // bugfix by anomen
        if ( isset ($item['description']) ) {
          $description = $item['description'];	
        }
        if ( isset ($item['atom_content']) ) {
          $description = $item['atom_content'];	
        }

// removed by anomen - nonsense code
//         list($description,$title)=
//         preg_replace('/([^\x00-\x7f])/e','sprintf("&#%d;", ord($1))',array($description,$title));

        $link="<a class='urllink' href='$href'>$title</a>";
          $line .= "<h3 class='rss$what'>$link</h3>\n";
        if ( $what == 'long' ) { 
          $line .=  $description . "<br />\n";
        }//if
           
      }//foreach
    }//if rss
    else {
     $line .= "<tt>$MAGPIE_ERROR</tt>";
    }
  }//else
}
error_reporting($OriginalError_reportingLevel);
$line="<div class='rss'>$line</div>";

$rss_link = "\n%right% [[$url|RSS]]\n";

return  Keep($line) . $rss_link;
}
