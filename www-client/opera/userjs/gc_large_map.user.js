// ==UserScript==
// @name		Zvetsit mapu
// @namespace		http://geokeeper.sf.net/userjs/gc_largemap
// @author		anomen
// @description		zvetsi google mapu
// @include		http://www.geocaching.com/map/default.aspx*
// @version		1.0
// @licence		http://creativecommons.org/licenses/by-nc-sa/3.0/
// ==/UserScript==


function gc_large_map()
{
    var w = '' + (screen.availWidth-60) + 'px';

    var c = document.getElementById('Content');
    var div1;
    for (var i = 0; i < c.childNodes.length; i++) {
	div1 = c.childNodes[i];
	if ((div1.nodeType == 1) && (div1.nodeName == "DIV")) {
		break;
        }
    }
    div1.style.width= w;

    var div2 = document.getElementById('ctl00_divContentMain');
    div2.style.width= w;

}

gc_large_map();
