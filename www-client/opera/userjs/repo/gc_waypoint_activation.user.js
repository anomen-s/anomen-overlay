/*
Makes links from GCxxx (GCxxxx and GCxxxxx) waypoints to the
Geocaching.com listing page

v0.2 04/12/2007
xpj <xpj@cetoraz.info>

Version history:

04/12/2007 v 0.2
added TB activation

23/01/2007 v 0.1
initial release


Based on:

Linkifier by Mysterious Unknown
http://userscripts.org/scripts/show/1024


// ==UserScript==
// @name          GCxxxx Waypoint / TBxxxx link activation v 0.2
// @namespace     http://www.cetoraz.info/pavel/geocaching/
// @description   Creates links to all GCxxxx / TBxxxx strings on page
// @include       http://www.geocaching.com/*
// ==/UserScript==

/*
http://www.geocaching.com/seek/cache_details.aspx?wp=GCQG4T&Submit6=Find

*/

var regExp = /\b((GC|TB)[0-9A-Z]{3,5})/gi;
var nodesWithGC = new Array();

window.activate = function(node) {
  getNodes(node);
  for (var i in nodesWithGC) {
    var nodes = new Array(nodesWithGC[i]);
    while (nodes.length > 0) {
      var act = nodes.shift();
      var re = new RegExp(regExp);
      var matches = re.exec(act.nodeValue);
      //var matches = act.nodeValue.match(regExp);
      if (matches == null) { continue; }
      var firstMatch = matches[0].toLowerCase();
      var pos = act.nodeValue.toLowerCase().indexOf(firstMatch);
      if (pos == -1) { continue; }
      else if (pos == 0) {
        if (act.nodeValue.length > firstMatch.length) {
          act.splitText(firstMatch.length);
          nodes.push(act.nextSibling);
        }
        var link = document.createElement("a");
	if (matches[2].toLowerCase() == "gc") {
            link.href = "http://www.geocaching.com/seek/cache_details.aspx?Submit6=Find&wp=" + act.nodeValue;
	} else {
   	    link.href = "http://www.geocaching.com/track/details.aspx?tracker=" + act.nodeValue;  
	}
        act.parentNode.insertBefore(link, act);
        link.appendChild(act);
     } else {
       act.splitText(pos);
       nodes.unshift(act.nextSibling);
     }  
    }
  }
}

window.getNodes = function(node) {
  if (node.nodeType == 3) {
    if (node.nodeValue.search(regExp) != -1) {
      nodesWithGC.push(node);
    }
  } else if (node && node.nodeType == 1 && node.hasChildNodes() 
		&& !node.tagName.match(/^(a|head|object|embed|script|style|frameset|frame|iframe|textarea|input|button|select|option)$/i)) {
	for (var i in node.childNodes) {
	    getNodes(node.childNodes[i]);
        }
  }
}

window.activate(document.documentElement);
