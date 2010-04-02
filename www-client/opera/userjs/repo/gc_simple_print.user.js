// ==UserScript==
// @name		Hideable elements in print page on gc.com
// @namespace		http://geokeeper.sf.net/userjs
// @description		Allows hiding elements by click in print page on gc.com
// @include		http://www.geocaching.com/seek/cdpf.aspx*
// @version		$Rev: 0 $
// ==/UserScript==

// NOT WORKING

function HideableJunk() {

    var nodes = document.getElementsByTagName("BLOCKQUOTE");
    for(var x = 0; x < nodes.length; x++ )
    {
	x.addEventListener("click", function() { x.style.display = "none";return true; } , false);
	
    }
}

document.addEventListener("load", HideableJunk, false);
