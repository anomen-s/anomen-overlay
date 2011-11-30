>>recipeinfo<<
Summary: How to add an RSS feed to a page
Version: 2011-11-30
Prerequisites: 
Status: 
Maintainer: [[~Anomen]]
Users: {{$FullName}-Users$Rating2} ([[{$FullName}-Users|View]] / [[{$FullName}-Users?action=edit|Edit]])
Categories: [[!RSS]]
Discussion: [[{$Name}-Talk]]
>><<
!! Questions answered by this recipe
Adding an RSS feed to your page.

[[#desc]]
!! Description
Use the rss feed from another site, or your own, to be displayed on your wiki. 
For example, include the most recent changes. 
(That could also be done with a [=[include:RecentChanges]]=], but when using a parser you can easily change the look, or display only the top 10 changes.)
This is also a good way to display images dynamically from Flickr.

This recipe uses RSS parser [[http://magpierss.sourceforge.net/ |Magpie]].

[[#install]]
!!Installation

Your host must allow outgoing http requests.
->%red%'''How do I check if my host allows outgoing http requests?'''
%green%Try to include an external url with this markup : [[Cookbook/IncludeUrl]]

->%red%'''Is this a setting I need to change in the Apache config file(s)?'''
-->%blue%Try it? ( I will try to make a test script soon)


Download [[(Attach:)rssdisplay.zip]]. This archive already constains MagpieRSS.

Extract the archive into your PmWiki folder.

Add following line to local/config.php
 include_once("$FarmD/local/rssdisplay.php");

!!! caching
Create a cache-directory @@$FarmD/cache@@ to avoid having the rss feed fetched a zillion times a day.
Ensure the directory is writable for the webserver (chmod 777).
Add into local/config.php:

 $MagpieEnableCache = true;


[[#usage]]
!!Usage

 (:RSS http://example.com/rss.xml [long|short] number_of_items>:) 
 
!!!Parameters
: how : display only titles (''short'') or also descriptions (''long'') of feed items
: number_of_items : number of items to display, -1 means all items

->Will display the items in a simple list with a max of ten items:

*[=(:RSS http://example.com/rss.xml:)=]

To display a long format and a max of 5 items use:

*[=(:RSS http://example.com/rss.xml long 5:)=]


[[#config]]
!!Configuration
List of configuration variables with their respective default values:

: $MagpieDefaultItems : default number of displayed items of feed  (default 30)
: $MagpieDefaultFormat : default format of displayed items of feed  (default 'long')

: $MagpieCacheDir : cache directory ("$FarmD/cache")
: $MagpieCacheAge : cache item timeout (2 hours)

: $MagpieProxy : proxy server, use syntax @@hostname:port@@
: $MagpieFetchTimeout : timeout for fetching RSS feeds (15)
: $MagpieGzip : use gzip compression for fetching feeds
: $MagpieDir : directory where Magpie is installed (@@"$FarmD/cookbook/magpie"@@)
: $MagpieOutputEncoding : encoding of content produced by feed reeder (defaults to @@$Charset@@)
: $MagpieDebug : output error messages from Magpie.

[[#relnotes]]
!! Change log / Release notes
||width=75%
||2011-11-30||    ||New rewritten version ([[~Anomen]])
||2005-10-30||1.32||Added html_entity_decode for the rss-url (thanks to [[~JohnCooley]])||
||          ||    ||Added some utf8 translation to html entities||
||          ||    ||Cleaned the Comments & Bugs list below a bit||
||2005-10-18||1.31||Looks like the htmlspecialchars stuff was '''not''' a good thing||
||2005-10-11||1.30||replaced ',' with space as seperator;setting error_reporting to zero;cleaned up html output;added conversion htmlspecialchars||
||2004-12-13||    ||Pmwiki 2.0 beta||
||2004-05-16||1.14||Magpie 0.61 basic atom support||
||2004-01-12||1.4||Using new Keep function[[<<]]Added <ul> to meet xhtml validation||
||2004-01-12||1.2||Added more ways to display the feed.||
||2004-01-10||1.0||Initial version.||

See [[{$Name}-Archive]] for archived documantation.

[[#seealso]]
!! See also
: git repository : http://repo.or.cz/w/anomen-overlay.git/tree/HEAD:/www-apps/pmwiki/cookbook/RssFeedDisplay

!!!Links
* [[http://magpierss.sourceforge.net/ |Magpie]]

[[#contributors]]
!! Contributors
* [[http://www.brambring.nl |bram]]
* [[~Mike]]
* [[~Anomen]]
  
[[#comments]]
!! Comments
See discussion at [[{$Name}-Talk]].

