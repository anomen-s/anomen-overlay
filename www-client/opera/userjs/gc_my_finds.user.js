// ==UserScript==
// @name		Create MyFinds list
// @namespace		http://geokeeper.sf.net/userjs
// @description		Create UUID/date list of found caches
// @include		http://www.geocaching.com/my/logs.aspx?txt=1
// ==/UserScript==

//(function () {

 var onetimeout = 3000;
 var retrytimeout = 10000; 
 var o=''; 
 var a=document.getElementsByTagName('A'); 
 var i; 
 for (i=0;i<a.length;i++) 
 {
  var e=a[i]; 
  if (e.href.indexOf('http://www.geocaching.com/seek/cache_details.aspx?guid=') >= 0) 
  {
   var z=e.parentNode.previousSibling; 
   //if (! (''+z.parentNode.innerHTML).match('Czech Republic')) {continue;} 
   if (z.tagName != 'TD') {z = z.previousSibling}; 
   if (z.tagName != 'TD') {continue;} 
   var d = z.innerHTML.match(/^ *([0-9][0-9]*)\/([0-9][0-9]*)\/(200[0-9]) *$/); 
   z=z.previousSibling; 
   if (z.tagName != 'TD') {z = z.previousSibling}; 
   if (z.tagName != 'TD') {continue;} z=z.childNodes[0]; 
   if (! (''+z.alt).match(/^(Found|Webcam|Attended)/)) {continue;} 
   d = d[3]+'-'+d[1].replace(/^.$/,'0'+d[1])+'-'+d[2].replace(/^.$/,'0'+d[2]); 
   var h = (''+e.href).match(/guid=([-a-fA-F0-9]*)/); 
   if (! h) {continue}; o=o+h[1]+';'+d+'<br />'; 
  }
 } 
 document.getElementById("geocaching").innerHTML=o;
 
// var s=document.createElement('SPAN'); 
 
// var d = window.open().document; 
// d.write(); 
/// d.close(); 
// /d.title='My Url Finds'; 
// d.body.innerHTML=o; 

//})();
