!!!Installation:

*Download the latest [=magpieRSS=] version from the [[http://magpierss.sourceforge.net/ |Magpie]] site. You need the following files installed:
**YOURWIKIHOME/local/magpie/rss_cache.inc
**YOURWIKIHOME/local/magpie/rss_fetch.inc
**YOURWIKIHOME/local/magpie/rss_parse.inc
**YOURWIKIHOME/local/magpie/rss_utils.inc
**YOURWIKIHOME/local/magpie/extlib/Snoopy.class.inc

->%red%'''THE FILE DOWNLOADED BY CLICKING ON RSSDISPLAY.PHP IS NOT A PHP FILE!!!'''
->%red%'''I WOULD NOT DOWNLOAD IT IF I WERE YOU'''
->(It is actually a copy of magpie-0.72.tar.gz)

*Download the recipe to a file named rssdisplay.php.
-->Attach:rssdisplay.php (`PmWiki 2)
** (Here are a [[http://www.christophedavid.org/w/c/w.php/Files/Rssdisplayphp|modified version of the script]], and a [[http://www.christophedavid.org/w/c/w.php/Files/RssDisplayDemo|demonstration of its output]].) [[Category.cda|cda]]

*Caching

Create a cache-directory to avoid having the rss feed fetched a zillion times a day. Ensure the directory is writable for the webserver (chmod 777)

In the top section of the rssdisplay.php file, there are some settings for the caching. You might want to adjust the location of the cache directory or the expiration time. The expiration time is the (minimum) time between fetching a rss-feed.   

 [@
 define('MAGPIE_CACHE_AGE', 2*60*60); #expiration time (seconds).
 define('MAGPIE_CACHE_DIR', "$FarmD/cache"); # location this is YOURWIKIHOME/cache
 @]
 --->[-''Note: 2*60*60 is two times 60 minutes times 60 seconds, aka 2 hours''-]
 
add the following lines to your local/config.php (in this order or rssdisplay fails)
[@
include_once("$FarmD/local/magpie/rss_fetch.inc");
include_once("$FarmD/local/rssdisplay.php");@]


'''%red%Question:%%''' Your instructions just above say to add inclusion of rssdisplay.php "or" rss_fetch.inc to config.php.  Should that say "and" - should the admin include ''both'' files?? \\
'''%green%Answer:%%'''You have to add both to your config.php. I have changed it 

!!Usage
*[=(:RSS http://example.com/rss.xml [long|short] number_of_items>:)=]

!!!Defaults 
*how: short
*number_of_items: 10
->Will display the items in a simple list with a max of ten items:

*[=(:RSS http://example.com/rss.xml:)=]

To display a long format and a max of 5 items use:

*[=(:RSS http://example.com/rss.xml long 5:)=]

!!![[http://www.brambring.nl/wiki/Main/RSSFeedDemo |Example]]

!!Comments
Guys it didnt work for me. Can anyone tell me step by step guide to add
magpie RSS display to pmwiki
     --Amala Singh(amalasingh@gmail.com)

Apache's documentation doesn't say anything on enabling outgoing http requests.  Is this something that would be known by a different name?
Searching for "outgoing http" on the Apache documentation site yields no relevant information.
--Mike Linke

