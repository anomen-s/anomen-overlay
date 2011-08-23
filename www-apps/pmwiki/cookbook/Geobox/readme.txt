>>recipeinfo<<
Summary: Create links to various map sites from provided gps coordinates.
Version: 2011-08-23
Prerequisites: 
Status: 
Maintainer: [[~Anomen]]
Users: {{$FullName}-Users$Rating2} ([[{$FullName}-Users|View]] / [[{$FullName}-Users|Edit]])
Categories: [[Links]]
(:if exists {$Name}-Talk:)Discussion: [[{$Name}-Talk]](:ifend:)
>><<
!! Questions answered by this recipe
How to automatically create links for given gps coordinates to various map sites.

!! Description
Recipe creates links to various map sites from provided gps coordinates.

[[#notes]]
!! Notes

!!!Usage
Use geobox markup 
[@ (:geo 49°43.996 14°27.665 :) @]

to create link list:
 ''49°43.996' 014°27.665'' [[http://www.mapy.cz/?query=Loc:49.73327%2014.46108 | mapy.cz]] [[http://maps.google.com/?q=49.73327%2014.46108|gmaps]] [[http://www.geocaching.com/map/default.aspx?lat=49.73327&lng=14.46108|geocaching.com/maps]] [[http://www.geocaching.com/seek/nearest.aspx?lat=49.73327&lng=14.46108&f=1|geocaching.com/near]]
 
 
 !!!Installation
 Download [[(Attach:)geobox.php]].
 
 in config.php, add the following:
 
 [@
  include_once("$FarmD/cookbook/geobox.php");
  @]


!!!Configuration

!!!!Map sites
You can modify list of links be changing @@$GeoBoxLinks@@ array.


In link address you can use these variables (prefixed by @@$@@ sign):
: LAT : quadrant N / S
: LON : quadrant E / W
: N  : latitude
: S : -latitude
: Nd : latitude (absolute value)
: Ndi : latitude (absolute value, integer part only)
: NSig : sign for N (empty for north, - for south)
: Nm : minutes of N (absolute value)
: Nmi : minutes of N (absolute value, integer part only)
: Ns : : seconds of N (absolute value)
: Nsi : seconds of N (absolute value, integer part only)

: E : longitude - values analogical to latitude
: W :
: Ed :
: Edi :
: ESig :
: Em :
: Emi :
: Es :
: Esi :


  
  [[#relnotes]]
  !! Release notes
  * 2010-06-12 - added to PmWiki Cookbook
  : git repository : http://repo.or.cz/w/anomen-overlay.git/tree/HEAD:/www-apps/pmwiki/cookbook/Geobox
  
  [[#contributors]]
  !! Contributors
  * [[~Anomen]] (original author)
  
  [[#comments]]
  !! Comments
  >>comment<<
  This space is for User-contributed commentary and notes.
  Please include your name and a date (eg 2007-05-19) along with your comment.
  Optional alternative:  create a new page with a name like "ThisRecipe-Talk" (e.g. PmCalendar-Talk).
  >><< 
  (:if exists {$Name}-Talk:)See discussion at [[{$Name}-Talk]](:ifend:)
  >>faq display=none<<
  
  Q:
  A:
  
  
 