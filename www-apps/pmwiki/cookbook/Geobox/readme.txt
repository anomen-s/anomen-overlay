>>recipeinfo<<
Summary: Create links to various map sites from provided gps coordinates.
Version: 2011-08-24
Prerequisites: 
Status: 
Maintainer: [[~Anomen]]
Users: {{$FullName}-Users$Rating2} ([[{$FullName}-Users|View]] / [[{$FullName}-Users|Edit]])
Categories: [[Links]]
(:if exists {$Name}-Talk:)Discussion: [[{$Name}-Talk]](:ifend:)
>><<
!! Questions answered by this recipe
How to automatically create links for given gps coordinates to various map sites.

[[#desc]]
!! Description
Recipe creates links to various map sites from provided gps coordinates.

[[#install]]
!!Installation
Download [[(Attach:)geobox.php]].

In config.php, add the following line:

[@
 include_once("$FarmD/cookbook/geobox.php");
@]

[[#usage]]
!!Usage
Use geobox markup 
[@ (:geo 49°43.996 14°27.665 :) @]

to create link list:
 ''49°43.996' 014°27.665'' [[http://www.mapy.cz/?query=Loc:49.73327%2014.46108 | mapy.cz]] [[http://maps.google.com/?q=49.73327%2014.46108|gmaps]] [[http://www.geocaching.com/map/default.aspx?lat=49.73327&lng=14.46108|geocaching.com/maps]] [[http://www.geocaching.com/seek/nearest.aspx?lat=49.73327&lng=14.46108&f=1|geocaching.com/near]]

!!! Coordinate input format
*Coordinates consists of latitude and logitude values separated by space character(s).
* Values can pre prefixed or postfixed with N or S for lat. and E or W for lon.
* Decimal dot or coma can be used.
* several characters can be used as degree sign (''U+002A ASTERISK'', ''U+00B0 DEGREE SIGN'', ''U+00BA MASCULINE ORDINAL INDICATOR', ''U+02DA RING ABOVE'').
* all three formats are recognised (degrees only and mixed formats with arcmin or arcmin+arcsec)
* degree sign is mandatory only for mixed formats (to separate degrees and arcminutess)

!!!Coordinate display format
You can change format of displayed coordinates by using ''format'' paremater.

Possible values and meanings are:
: D : deg°
: M : deg°min'
: S : deg°min'sec"

For example, following line will produce coordinates displayed as degrees:
[@ (:geo format=d 49°43.996 14°27.665 :) @]

!!!Point projection
You can perform point projection using parameters ''azimuth'' (value in degrees) and ''distance'' (value in meters).
Result of projection will be displayed (together with proper links) instead of original given coordinates.

For example, following line will produce coordinates @@ 50.00949 15.18703 @@:

[@ (:geo format=d azimuth=45 distance=2703 49.99232 15.16031 :) @]


[[#config]]
!!Configuration

!!!Map sites
You can modify list of links be changing @@$GeoBoxLinks@@ array.

: disable list :  @@$GeoBoxLinks = array();@@
: remove link : @@unset($GeoBoxLinks['mapy.cz']);@@
: add link :  @@SDVA($GeoBoxLinks,  array('title'=>'http://example.com/maps'));@@
: replace list:  @@$GeoBoxLinks = array('title'=>'http://example.com/maps');@@

In link address you can use these variables (prefixed by @@$@@ sign):
: LAT : hemisphere N / S
: N  : latitude
: S : -latitude
: Nd : latitude (absolute value)
: Ni : latitude (integer part only)
: Ndi : latitude (absolute value, integer part only)
: NSig : sign for N (empty for north, - for south)
: Nm : minutes of N (absolute value)
: Nmi : minutes of N (absolute value, integer part only)
: Ns : : seconds of N (absolute value)
: Nsi : seconds of N (absolute value, integer part only)

: LON : hemisphere E / W
: E : longitude - ''all values analogical to latitude''
: W :
: Ed :
: Ei :
: Edi :
: ESig :
: Em :
: Emi :
: Es :
: Esi :

-> Note: Either apostrophes must be used as string delimiters instead of double quotes or proper @@$@@ escaping must be used to avoid expanding of variables by PHP.

!!!Example
* print coordinates and link to google maps

[@
 include_once("$FarmD/cookbook/geobox.php");
 $GeoBoxLinks = array('maps.google.com'=>'http://maps.google.com/?q=$N%20$E');
@]

* add link to mapquest.com

[@
 include_once("$FarmD/cookbook/geobox.php");
 SDVA($GeoBoxLinks,  array('mapquest'=>'http://www.mapquest.com/?q=$N,$E&amp;zoom=15'));
@]


[[#relnotes]]
!! Change log / Release notes
* 2010-06-12 - added to PmWiki Cookbook
* 2011-08-22 - point projection, configurable link list and various improvements

[[#seealso]]
!! See also
: git repository : http://repo.or.cz/w/anomen-overlay.git/tree/HEAD:/www-apps/pmwiki/cookbook/Geobox

!!!Links
* http://transition.fcc.gov/mb/audio/bickel/sprong.html
* http://www.movable-type.co.uk/scripts/latlong.html
* [[http://handygeocaching.googlecode.com/svn/trunk/src/gps/Gps.java  | Handy Geocaching sources]]

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

