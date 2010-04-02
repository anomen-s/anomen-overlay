//
//  Adds link to generate LOC file from geocache page.
//  (C) Copyright James Inge 2008.
//
//  V0.01 	Initial version.
//
//  GPL.
//

// ==UserScript==
// @name          Geocaching.com Additional Waypoints LOC Link
// @namespace     http://inge.org.uk/userscripts
// @description	  Adds a link to generate a LOC file containing details of any additional waypoints listed on the geocache page.
// @include       http://www.geocaching.com/seek/cache_details.aspx*
// ==/UserScript==

(function() {
    function addWPLink() {
	var i = 0, j=0;
	var rows = document.evaluate("//img[@title='available']/../..", document, null, XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE, null);
	var cells;

	if( rows.snapshotLength > 0 ) {
		var loc = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<loc version=\"1.0\" src=\"Groundspeak\">\n";
		for( i = 0; i < rows.snapshotLength; i++ ) {
			cells = document.evaluate("td", rows.snapshotItem(i), null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
			if( cells.snapshotLength != 7 ) {
				alert( "Error: wrong number of cells... " + cells.snapshotLength );
			} else {
				loc += "<waypoint>\n\t<name id=\"" + cells.snapshotItem(3).innerHTML;
				loc += "\"><![CDATA[" + stripLink(cells.snapshotItem(4).innerHTML) + "]]></name>\n";
				loc += "\t<coord lat=\"" + getLat(cells.snapshotItem(5).innerHTML) + "\" lon=\"" + getLon(cells.snapshotItem(5).innerHTML) + "\"/>\n";
				loc += "\t<type>Geocache</type>\n";
				loc += "\t<link text=\"Waypoint details\">" + getURL(cells.snapshotItem(4)) + "</link>\n";
				loc += "</waypoint>\n";
			}
		}
		loc += "</loc>\n";
		var dest = document.getElementById('LatLon');
		if( dest ) {
			dest.innerHTML += " <a title=\"Click to generate a LOC file from the additional coordinates.\" href=\"data:application/xml-loc," + escape(loc) +"\">Additional LOC</a>";
		}
	}
	
    }

    function stripLink( txt ) {
	var t = txt.slice(txt.search('>')+1);
	t = t.slice(0,t.search('</a>'));
	return t;
    }

    function getURL( cell ) {
	var link = document.evaluate("a", cell, null, XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE, null);
	if( link.snapshotLength == 1 ) {
		return link.snapshotItem(0).href;
	} else {
		return "http://www.geocaching.com/seek/";
	}
    }

    function getLat( txt ) {
	var deg = 0, min = 0;
	if( txt.length != 26 ) {
		/****
		 * This relies on the coordinate being in the format: N 50' 54.344 W 001' 24.110
		 ****/
		alert( "Error: unexpected string length: " + txt );
		return 0;
	} else {
		deg = txt.slice(2,4);
		/* Force text to number */
		deg *= 1;
		min = txt.slice(6,12);
		min /= 60;
		deg += min;
		if( txt.indexOf('N') == -1 ) {
			return 0 - deg;
		} else {
			return deg;
		}
	}
    }

    function getLon( txt ) {
	var deg = 0, min = 0;
	if( txt.length != 26 ) {
		/****
		 * This relies on the coordinate being in the format: N 50' 54.344 W 001' 24.110
		 ****/
		alert( "Error: unexpected string length: " + txt );
		return 0;
	} else {
		deg = txt.slice(15,18);
		/* Force text to number */
		deg *= 1;
		min = txt.slice(20);
		min /= 60;
		deg += min;
		if( txt.indexOf('W') == -1 ) {
			return deg;
		} else {
			return 0 - deg;
		}
	}
    }

    addWPLink();
})();

