// ==UserScript==
// @name		Remove Ads from gc.com
// @namespace		http://geokeeper.sf.net/userjs
// @description		Removes Ads from gc.com
// @include		http://www.geocaching.com/*
// @version		$Rev: 20 $
// ==/UserScript==


function HideJunk() {

    var dnode = document.getElementById("DisclaimerText");
    if (dnode) {
	dnode.style.display = "none";
    }

    var nodes = document.getElementsByTagName("DIV");
    for(var x = 0; x < nodes.length; x++ )
    {
	var n = nodes[x];
	if (n.className == "ads-banman") {
	    n.style.display = "none";
	}
	
    }
}

document.addEventListener("load", HideJunk, false);
