/**
 * Aes encryption for PmWiki recipe AesCrypt
 *
 * Based on:
 *   http://submodal.googlecode.com
 *   http://www.pmwiki.org/wiki/Cookbook/DesCrypt
 *   http://www.pmwiki.org/wiki/Cookbook/AesCrypt
 *
 *
 */

var AesCrypt = {};

/**
 * Mode of work. Either ['enc', start, end] or ['dec',block_id];
 */
AesCrypt.mode = null;

/**
 * Title of dialog
 */
AesCrypt.title = null;

/**
 * is popup element created?
 */
AesCrypt.popupDiv = false;

/**
 * create hidden modal box for encryption
 */
AesCrypt.createPopup = function ()
{
    if (!AesCrypt.popupDiv) {
        var popup =  '<div id=\'aescrypt_o\' class=\'aescrypt_overlay\'>' 
	        + '<div>' 
	        + '<img onclick=\'AesCrypt.hideDialog()\' width=\'24\' height=\'24\' title=\'close dialog\' alt=\'close dialog\' id=\'aescrypt_i\' src=\''+AesCrypt.PubDirUrl+'/close.png\' />'
	        + '<p id=\'aescrypt_l\'>Enter password:</p>'
	        + '<form id=\'aescrypt_f\' onsubmit=\'AesCrypt.overlaySubmit();return false;\'>'
	        + '<span><input type=\'password\' name=\'aescrypt_p\' id=\'aescrypt_p\' onkeypress=\'AesCrypt.hidePass()\' />  '
	        + '<img onmousedown=\'AesCrypt.showPass()\' style=\'vertical-align:bottom\' onmouseup=\'AesCrypt.hidePass()\' onmouseout=\'AesCrypt.hidePass()\' onmouseover=\'AesCrypt.hidePass()\'   width=\'24\' height=\'24\' alt=\'Show password\' title=\'Show password\' id=\'aescrypt_sp\' src=\''+AesCrypt.PubDirUrl+'/showpass.png\' />'
	        + '</span><br />'
            + '<label title=\'All encrypted texts on this page will be decrypted.\' id=\'aescrypt_all\'><input type=\"checkbox\" name=\"aescrypt_allb\" id=\"aescrypt_allb\"  checked=\"checked\" value=\"true\" /> decrypt all</label>'
            + '<br />'
	        + '<input type=\'submit\' />'
	        + '</form>' + '</div>' + '</div>';

	    var theBody = document.getElementsByTagName('body')[0];
	    var popmask = document.createElement('div');
	    popmask.id = 'aescrypt_m';
	    var popcont = document.createElement('div');
	    popcont.id = 'aescrypt_x';
	    popcont.innerHTML = popup;

	    theBody.appendChild(popmask);
	    theBody.appendChild(popcont);
	
	    AesCrypt.popupDiv = true;
    }
}

/**
 * Retrieve password and clear password box.
 */
AesCrypt.getPassword = function ()
{
    var pwel = document.getElementById('aescrypt_p');
    var pw = pwel.value;
    pwel.value = '';
    return pw;
}


/**
 * Display modal dialog.
 */
AesCrypt.showDialog = function(label, decmode) 
{
    document.getElementById('aescrypt_o').style.visibility = 'visible';
    document.getElementById('aescrypt_m').style.visibility = 'visible';
    document.getElementById('aescrypt_all').style.visibility = (decmode ? 'visible' : 'hidden');
    document.getElementById('aescrypt_l').childNodes[0].nodeValue = label;
    AesCrypt.title = label;

    var pw = document.getElementById('aescrypt_p');
    pw.focus();
    pw.value = '';
        
    AesCrypt.addEvent(window, 'keyup', AesCrypt.onEscPress);
}

/**
 * Hide modal dialog.
 */
AesCrypt.hideDialog = function() 
{
    document.getElementById('aescrypt_o').style.visibility = 'hidden';
    document.getElementById('aescrypt_m').style.visibility = 'hidden';
    document.getElementById('aescrypt_all').style.visibility = 'inherit';
    document.getElementById('aescrypt_l').childNodes[0].nodeValue = 'Enter password:';

    AesCrypt.removeEvent(window, 'keyup', AesCrypt.onEscPress, false);
}


AesCrypt.addEvent = function (obj, evType, fn)
{
    if (obj.addEventListener){
        obj.addEventListener(evType, fn, false);
        return true;
    } 
    else if (obj.attachEvent) {
        var r = obj.attachEvent('on'+evType, fn);
        return r;
    } else {
        return false;
    }
}

AesCrypt.removeEvent = function(obj, evType, fn, useCapture)
{
    if (obj.removeEventListener){
        obj.removeEventListener(evType, fn, useCapture);
        return true;
    } else if (obj.detachEvent){
        var r = obj.detachEvent('on'+evType, fn);
        return r;
    } else {
        alert('Handler could not be removed');
    }
}

AesCrypt.onEscPress = function(e)
{
    if (!e) e = event;

    if (e.keyCode == 27) {
        AesCrypt.hideDialog();
    }
}



/**
 * display modal box for encryption
 */
AesCrypt.encPopup = function()
{
    AesCrypt.mode = AesCrypt.saveSelection();

    //alert("selection: " + AesCrypt.mode);
    
    if (!AesCrypt.mode) {
	    alert('Please select text to encrypt');
	    return false;
    }

    AesCrypt.createPopup();

    document.getElementById('aescrypt_p').value = '';

    AesCrypt.showDialog("Encrypt selected text", false);
    
}

/**
 * display modal box for decryption
 */
AesCrypt.decPopup = function(id)
{
    AesCrypt.mode = ['dec',id];
    
    AesCrypt.createPopup();

    document.getElementById('aescrypt_p').value = '';

    var c = document.getElementById('aescrypt_c_'+id).childNodes[0].nodeValue;
    if (c.length > 30) {
        c = c.substr(0,29) + "\u2026";
    }
    AesCrypt.showDialog("Decrypt " + c, true);
}

AesCrypt.showPass = function()
{
    var pwel = document.getElementById('aescrypt_p');
    var pw = pwel.value;
    if (pw) {
	document.getElementById('aescrypt_l').childNodes[0].nodeValue = "Password is: "+pw;
    }
}

AesCrypt.hidePass = function()
{
    if (AesCrypt.title) {
	document.getElementById('aescrypt_l').childNodes[0].nodeValue = AesCrypt.title;
    }
}


AesCrypt.overlaySubmit = function()
{
    var pw = AesCrypt.getPassword();

    AesCrypt.hideDialog();

    if (!pw) {
      alert("No password given!");
      return;
    }
    
    if (!AesCrypt.mode) {
        alert('Nothing to do.');
    } 
    else if (AesCrypt.mode[0] == 'enc') {
        AesCrypt.encSubmit(pw);
    }
    else if (AesCrypt.mode[0] == 'dec') {
        AesCrypt.decSubmit(pw);
    }
    else {
        alert('Unknown action: '+AesCrypt.mode[0]);
    }
    AesCrypt.mode = null;
}

/**
 * Function invoked on submit of password modal dialog.
 * Performs decryption.
 */
AesCrypt.decSubmit = function(password)
{
    // decrypt all ?
    var allEl = document.getElementById('aescrypt_allb');

    var i = AesCrypt.mode[1];
    var to = i;
    if (allEl.checked) {
        i = 1;
        to = 10000; // just some big number
    }

    while (i <= to) {
        var contentel = document.getElementById('aescrypt_c_'+i);
        if (!contentel) {
            break;
        }
        if (contentel.style.display == 'none') {
            var cipher = contentel.childNodes[0].nodeValue;
            var plain = AesCtr.decrypt(cipher,password,256);
            if (plain.charAt(plain.length-1) != ' ') {
        	alert ("Invalid password for cipher #"+i);
            }
            else {
        	var plainTrim = plain.replace(/\s\s*$/, '');
        	contentel.childNodes[0].nodeValue = plainTrim;
        	contentel.style.display='block';
        	var linkel = document.getElementById('aescrypt_a_'+i);
                if (!linkel) {
                    alert("Cipher block not found: id="+i);
                } else {
                    linkel.style.visibility='hidden';
                    linkel.style.display='none';
                }
            }
        }
        i++;
    }
}

/**
  * Hide modal box and encrypt selection
  */
AesCrypt.encSubmit = function(password) 
{
    var tpart = AesCrypt.getSelection();
    
    var padding = AesCrypt.AesCryptPadding;
    var tarr = AesCrypt.AesCryptCipherToken;
    var markup_end = AesCrypt.AesCryptEndToken;

    while ((tpart.length % padding) > 0) {
        tpart = tpart.concat(' ');
    }
    tpart = tpart.concat(' ');

    tarr +=AesCtr.encrypt(tpart, password, 256);
    tarr += ' ';
    tarr += markup_end;

    AesCrypt.replaceSelection(tarr);
}

/**
 * Get selection to be encrypted (selection mode)
 */
AesCrypt.saveSelection = function() 
{
    var textarea = document.getElementById('text');

    if (document.selection) { // IE variant
        textarea.focus();
        //var sel = document.selection.createRange();

        var bm = document.selection.createRange().getBookmark();
        var sel = textarea.createTextRange();
        sel.moveToBookmark(bm);

        var sleft = textarea.createTextRange();
        sleft.collapse(true);
        sleft.setEndPoint('EndToStart', sel);
        var start = sleft.text.length
        var end = sleft.text.length + sel.text.length;

        // alert the selected text in textarea
        //alert(">" + sel.text + "<");

	// add 'magic' constants, no idea why.
        return ['enc', start+1, end+2];
      
    } else {
        var start = textarea.selectionStart;
        var end = textarea.selectionEnd;
        if (start  < end) {
            return ['enc', start, end];
        }
        else {
            return null;
        }
    }
}

AesCrypt.getSelection = function()
{
    var start = AesCrypt.mode[1];
    var end = AesCrypt.mode[2];
    var textarea = document.getElementById('text');
    var sel = textarea.value.substring(start, end);
    return sel;
}

AesCrypt.replaceSelection = function(replace) 
{
    var textarea = document.getElementById('text');
    var start = AesCrypt.mode[1];
    var end = AesCrypt.mode[2];
    var len = textarea.value.length;
    textarea.value = textarea.value.substring(0,start) + replace + textarea.value.substring(end,len);
}

