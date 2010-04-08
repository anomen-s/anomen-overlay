// ==UserScript==
// @name           onewptexport
// @namespace      http://drak.ucw.cz/~ebik/gm
// @include        http://www.geocaching.com/seek/cache_details.aspx*
// @description	   Version 2008-03-01 .|. Includes in listing rows for oziexplorer / smartcomgps .wpt file
// ==/UserScript==

//
// 2008-03-01 First Release
//


// Various "greasemonkey" implementations...
isFireFoxGM = 1;
try {unsafeWindow.try_existence = 1;} catch (e) {
	unsafeWindow = window;
	isFireFoxGM = 0;
};
//<!--#config charset="UTF-8"-->

// Helper functions ....
ElementLocator = {
    traverse:function(element,callback,nextsibling) {
	var ns;
	if (! element) return false;
	if (nextsibling) ns = element.nextSibling; // deletion safety
	if (callback(element)) return true; //found
	if (element.childNodes && this.traverse(element.childNodes[0],callback,true)) return true; //propagate found;
	if (this.traverse(ns,callback,true)) return true; //propagate found;
	return false; //propagate not found
    },

    locate:function(element,callback) {
	var retel=null;
	this.traverse(element,function(el) {if (callback(el)) {retel=el; return true} else return false;});
	return retel;
    },

    locate_by_innerHTML:function(element,ih) {
	return this.locate(element,function(el){return (el.innerHTML == ih);});
    }
}

var matchLatLonDMM = function(x) {
    var m;
    m=x.match(
  	/^\s*([NSWE]?)\s*([0-9]+)[^0-9A-Z]+([0-9]+\.[0-9]+)[^0-9A-Z]+([NSWE])[^0-9A-Z]*([0-9]+)[^0-9A-Z]+([0-9]+\.[0-9]+)\s*([NSWE]?)\s*$/i
    );
    if (!m) return null;
    // 0:& 1:NSWE 2:DEG 3:MIN 4:NSWE 5:DEG 6:MIN 7:NSWE
    var val1 = 1*m[2]+m[3]/60;
    var val2 = 1*m[5]+m[6]/60;
    if (m[7].length) {
	if (m[1].length) return null;
	m[1]=m[4];m[4]=m[7];m[7]='';
    }
    if (m[1].match(/[SW]/)) val1=-val1;
    if (m[4].match(/[SW]/)) val2=-val2;
    val1 = (''+val1).substr(0,10);
    val2 = (''+val2).substr(0,10);
    if (m[1].match(/[NS]/)) {
	if (m[2].match(/[NS]/)) return null;
	return ''+val1+','+val2;
    } else {
	if (! m[2].match(/[NS]/)) return null;
	return ''+val2+','+val1;
    }
}

//
// ... Document parser ...
//

var find_latlon=function(el) {
    var ma=null;
    ElementLocator.traverse(el,
	function(x){
	    if (x.nodeType == x.TEXT_NODE) { //Mozilla, Firefox only
		ma = matchLatLonDMM(x.textContent);
		if (ma) return true;
	    }
	    return false;
	}
    );
    return ma;
}
var cache_info={};

//Collect informations
cache_info.latlon=find_latlon(document.getElementById('LatLon'));

cache_info.name = document.getElementById('CacheName').textContent;
cache_info.wpt = document.title.match(/GC[A-Z0-9]+/i);
cache_info.terrain = document.getElementById('Terrain').getElementsByTagName('IMG')[0].alt.match(/[0-9\.]+/);
cache_info.difficulty = document.getElementById('Difficulty').getElementsByTagName('IMG')[0].alt.match(/[0-9\.]+/);
// vcetne 'by '
cache_info.owner = document.getElementById('CacheOwner').textContent;
cache_info.dateHidden = document.getElementById('DateHidden').textContent;
cache_info.size =document.getElementById('DateHidden');
while (cache_info.size && ! cache_info.size.nodeName.match(/^img$/i))  cache_info.size = cache_info.size.nextSibling;
if (cache_info.size) cache_info.size=cache_info.size.alt.replace(/Size:\s*/i,'');
else cache_info.size='?';

cache_info.type = document.getElementById('CacheName');
while (cache_info.type && ! cache_info.type.nodeName.match(/^a$/i))  cache_info.type = cache_info.type.previousSibling;
if (cache_info.type) cache_info.type = cache_info.type.childNodes[0];
while (cache_info.type && ! cache_info.type.nodeName.match(/^img$/i))  cache_info.type = cache_info.type.nextSibling;
if (cache_info.type) cache_info.type= cache_info.type.alt;
cache_info.hint = document.getElementById('Hints');
if (cache_info.hint) cache_info.hint = cache_info.hint.innerHTML;
else cache_info.hint='[No hint]';

//chytam se na dekodovaci tabulce (id=='dk')
//timto ziskam paragraf s additional wpts
var adwpt = document.getElementById('dk');
while (adwpt && ! adwpt.textContent.match('Additional Waypoints'))  adwpt = adwpt.nextSibling;

//a tabulku
if (adwpt) adwpt=adwpt.getElementsByTagName('TABLE')[0];
if (adwpt) {
    var wptn=-1;
    var i;
    cache_info.addwpts=Array();
    for (i=0;i<adwpt.rows.length;i++) {
	var ro=adwpt.rows[i];
	if(
	    ro.cells[0].innerHTML.match(/<img/i) &&
	    ro.cells[1].innerHTML.match(/<img/i)
	) {
	    wptn++;
	    cache_info.addwpts[wptn]={
		stat:ro.cells[0].childNodes[0].alt,
		cat:ro.cells[1].childNodes[0].alt,
                prefix:ro.cells[2].innerHTML,
                lookup:ro.cells[3].innerHTML,
                name:ro.cells[4].getElementsByTagName('A')[0].innerHTML,
		latlon:find_latlon(ro.cells[5])
	    }
	} else if (ro.cells[0].innerHTML.match(/Note:/i)) {
	    cache_info.addwpts[wptn].note=ro.cells[1].innerHTML;
	}
    }
}

// ... WPT CREATOR

var wpttoday = new Date();
wptToday = wpttoday.getTime() /1000 /60 /60 /24 + 25569;
wptToday = ('' + wptToday).substr(0,12);

var construct_wpt=function(x) {
    return ''+(x.index || '-1')+','+ //1
	('' + x.name).replace(/,/g,' ')+','+ //2
        (x.latlon || '0,0')+','+ //3,4
	(x.date || wptToday) + ',' + //5
        (x.symbol || '0') + ',' +
        (x.status || '1') + ',' +
        (x.mapDisplayFmt || '3') + ',' +
	(x.forecolor || '0') + ',' +
	(x.backcolor || (256*256*256-1)) + ',' +
	('' + x.description).replace(/,/g,';') + ',' +
	(x.ptrdir || '0') + ',' +
	(x.garminDisplayFmt || '0') + ',' +
	(x.proximityDist || '0') + ',' +
	(x.alt || '-777') + ',' + 
	(x.fontSize || '7') + ',' +
	(x.fontStyle || '0') + ',' +
	(x.symbolSize || '17') + ',' +
	(x.proximitySymbolPos || '0') + ',' +
	(x.proximityTime || '10') + ',' +
	(x.proximityOrRoute || '2') + ',' +
	(x.attachFileName || '') + ',' +
	(x.proximityAttachFileName || '') + ',' +
	(x.proximitySymbolName || '')
	//+ ',0,0,0,0,' //ocas pro SmartComGPS 
	;
}


//Colors:
var wptcolor=function(r,g,b) {
   return ''+((b*256+g)*256+r);
}
var cache_colors = {
	'multi-cache':wptcolor(255,255,0),
	'earthcache':wptcolor(208,160,64),
	'unknown cache':wptcolor(50,50,255),
	'traditional cache':wptcolor(50,255,50)
};

//Misto disclaimeru:
targetEl=document.getElementById('DisclaimerText');
if (targetEl.getElementsByTagName('TABLE').length) {
   targetEl=targetEl.getElementsByTagName('TABLE')[0].rows[0];
   if (targetEl.cells.length>1) {
      targetEl.cells[0].innerHTML='E<br>X<br>P<br>O<br>R<br>T';
      targetEl.cells[0].align='center';
   }
   targetEl=targetEl.cells[targetEl.cells.length-1];
   targetEl.style.backgroundColor="#DDDDDD";
   targetEl.style.color="#000080";
}
targetEl.innerHTML='';
var appendText = function (x,t) {x.appendChild(document.createTextNode(t));};
var newLine = function(x) {x.appendChild(document.createElement('BR'));};
var appendTextLn = function(x,t) {appendText(x,t);newLine(x);};

appendTextLn(targetEl,'OziCe/SmartComGPS wpt');
appendTextLn(targetEl,'Warning oziexplorer needs exactly 4 lines before first waypoint!');
appendTextLn(targetEl,'Oziexplorer also truncates waypoint description to 40 characters');
newLine(targetEl);

cache_info.type.replace(/^\s+/,'');
cache_info.type.replace(/\s+$/,'');
var cachecolor = cache_colors[cache_info.type.toLowerCase()] || wptcolor(255,255,255);

if (cache_info.addwpts) {
    var i;
    for (i=0; i<cache_info.addwpts.length;i++) {
	var w=cache_info.addwpts[i];
	if (w.latlon) appendTextLn(targetEl,construct_wpt({
	    name:cache_info.wpt+'-'+w.prefix,
	    description:w.lookup+' '+w.name+'|'+w.note+' ',
	    backcolor:cachecolor,
	    forecolor:wptcolor(44,44,44),
	    latlon:w.latlon
	}));
    }
}

appendTextLn(targetEl,construct_wpt({
	name:cache_info.wpt+' '+cache_info.type.substr(0,1)
	    +cache_info.size.substr(0,1)+
	    +(''+cache_info.difficulty).substr(0,1)
	    +(''+cache_info.terrain).substr(0,1),
	latlon:cache_info.latlon,
	description:cache_info.name + '|' + cache_info.hint+' ',
	backcolor:cachecolor
}));

