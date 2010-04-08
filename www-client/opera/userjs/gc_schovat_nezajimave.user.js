// ==UserScript==
// @name		Schovat neaktivni
// @namespace		http://geokeeper.sf.net/userjs
// @author		anomen, original idea by chupito
// @description		přidává do mapy geocaching.com možnost schovat neaktivni kešky
// @include		http://www.geocaching.com/map/default.aspx*
// @version		$Rev: 19 $
// @licence		http://creativecommons.org/licenses/by-nc-sa/3.0/
// ==/UserScript==


function hideFound(e,b)
{
    return do_hide(b);
}
function hideOwned(e,b)
{
    return do_hide(b);
}

function do_hide(doupdate) {
        var d=mrks.length;
	var h_d = ($("hdCB").checked===true);
	var h_f = ($("chkHideFound").checked===true);
	var h_o = ($("chkHideOwned").checked===true);
//	if ($("huCB").checked===true) {
//	    h_d = h_f = h_o = true;
//	}
	//alert("d:"+h_d+" f:"+h_f+" o:"+h_o);

        for(var a=0; a<d; a++) {
	    var m = mrks[a];
	    var v = (lgnds.byTypeID(m.wptTypeId).visible===true);
            if(h_d && (m.isAvailable!=true)) { v=false; }
            if(h_f && (m.found===true)) { v=false; }
            if(h_o && (m.owned===true)) { v=false; }
	    if (v) {
		m.show();
	    } else {
                m.hide();
            }
        } //for
        if(doupdate){
    	    updateSideBarList()
        }
}

function ct_tgl(b,a){
    
    if(a===true){
        lgnds.byTypeID(b).show()
    }else{
        lgnds.byTypeID(b).hide()
    }
    do_hide(true);
    return
}

function setHideState(){
    for(var b=0,a=lgnds.length();b<a;b++){
        if(lgnds.byID(b).visible===false){
            lgnds.byID(b).hide()
        }
    }
    do_hide(true);
}

function hideDisabledHandler(c)
{
/*    var vis = ($("huCB").checked===false);
    if (!vis) { alert("hide"); }
    document.getElementById('hdCB').style.display = vis;
    document.getElementById('chkHideFound').style.display = vis;
    document.getElementById('chkHideOwned').style.display = vis;
*/
    return do_hide(true);
}


function gc_dis_init()
{
    console.log("gc_dis_init");
    pm = true;
    var newElement = document.getElementById('filterLegend');
    if (newElement) {
        newElement.parentNode.insertBefore(document.createElement('div'), newElement.nextSibling).innerHTML = 
    	'<input type="checkbox" id="hdCB" checked="checked" /><img src="../images/gmn/cm_dis.png" alt="Hide Disabled" width="16" height="16" />Hide Disabled';
    //    newElement.parentNode.insertBefore(document.createElement('div'), newElement.nextSibling).innerHTML = 
    //	'<input type="checkbox" id="huCB" checked="checked" /><img src="../images/icons/icon_greenlight.gif" alt="Hide Uninteresting" width="16" height="16" />Hide All Uninteresting';
    
        document.getElementById('hdCB').addEventListener("click", hideDisabledHandler, true);
    //    document.getElementById('huCB').addEventListener("click", hideDisabledHandler, true);
    }

    $("chkHideFound").checked=true;
    $("chkHideOwned").checked=true;
    $("chkHideFound").disabled=false;
    $("chkHideOwned").disabled=false;

}


//window.opera.addEventListener(  'BeforeScript', gc_dis_init, false);

gc_dis_init();
