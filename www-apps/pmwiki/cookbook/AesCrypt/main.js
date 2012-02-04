/**
 * Aes encryption for PmWiki recipe AesCrypt
 *
 * Based on:
 *   http://submodal.googlecode.com
 */

var AesCrypt = {};

AesCrypt.decryptId = 0;

/**
 * Displays and hides modal dialog.
 */
AesCrypt.overlay = function(state) {
  var el = document.getElementById('aescrypt_o');
  var mask = document.getElementById('aescrypt_m');
  var newState = (state ? 'visible' : 'hidden');
  el.style.visibility = newState;
  mask.style.visibility = newState;


  var pw = document.getElementById('aescrypt_p');
  if (state) {
    var pw = document.getElementById('aescrypt_p');
    pw.focus();
    pw.value = '';
    addEvent(window, 'keypress', AesCrypt.onEscPress);
  } 
  else {
    removeEvent(window, 'keypress', AesCrypt.onEscPress, false);
  }
}

/**
 * Function invoked on submit of password modal dialog.
 * Performs decryption.
 */
AesCrypt.decSubmit = function()
{
 AesCrypt.overlay(false);
 var pwel = document.getElementById('aescrypt_p');
 var pw = pwel.value;
 pwel.value = '';
 // decrypt all ?
 var allEl = document.getElementById('aescrypt_b');
 
 var i = AesCrypt.decryptId;
 var to = AesCrypt.decryptId;
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
	var plain = AesCtr.decrypt(cipher,pw,256);
	var plainTrim = plain.replace(/\\s\\s*\$/, '');
	contentel.childNodes[0].nodeValue = plainTrim;
	contentel.style.display='block';
	var linkel = document.getElementById('aescrypt_a_'+i);
	if (!linkel) {
	   alert(i);
	} else {
	  linkel.style.visibility='hidden';
	  linkel.style.display='none';
	}
    }
    i++;
 }
}

AesCrypt.addEvent = function (obj, evType, fn){
 if (obj.addEventListener){
    obj.addEventListener(evType, fn, false);
    return true;
 } else if (obj.attachEvent){
    var r = obj.attachEvent('on'+evType, fn);
    return r;
 } else {
    return false;
 }
}
AesCrypt.removeEvent = function (obj, evType, fn, useCapture){
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



AesCrypt.onEscPress  = function ()
{
    if (window.event.keyCode == 27) {
	AesCrypt.overlay(false);
   }
}


AesCrypt.popupDiv = false;

/**
 * display modal box for encryption
 */
AesCrypt.encPopup = function ()
{
//    alert('123');
    AesCrypt.SelectionRange = AesCrypt.saveSelection();

//    alert(aescryptSelectionRange);
  if (!AesCrypt.popupDiv) {
    var popup =  '<div id=\'aescrypt_o\' class=\'aescrypt_overlay\'>' 
	+ '<div>' 
	+ '<p id=\'aescrypt_l\'>Encrypt selected text:</p>' 
	+ '<form id=\'aescrypt_f\' onsubmit=\'aescryptEncSubmit();return false;\'>' 
	+ '<input type=\'password\' name=\'aescrypt_p\' id=\'aescrypt_p\' />' 
	+ '<input type=\'submit\'  />' 
	+ '</form>' + '</div>' + '</div>';

	var theBody = document.getElementsByTagName('body')[0];
	var popmask = document.createElement('div');
	popmask.id = 'aescrypt_m';
	popmask.className = 'aescryptPopupMask';
	var popcont = document.createElement('div');
	popcont.id = 'aescrypt_x';
	popcont.innerHTML = popup;

	theBody.appendChild(popmask);
	theBody.appendChild(popcont);
	
	AesCrypt.popupDiv = true;
  }
  var pwel = document.getElementById('aescrypt_p_enc');
  pwel.value = '';

  AesCrypt.overlay('enc',true);
}

/**
  * Hide modal box and encrypt selection
  * - how to get selection?
  * - 
  */
AesCrypt.encSubmit =  function () {

    var tpart = AesCrypt.getSelection();
    
    var pwel = document.getElementById('aescrypt_p_enc');
    var pw = pwel.value;
    pwel.value = 'TopSecret';

    aescryptOverlay('enc', false);

    var padding = $AesCryptPadding;
    var tarr = AesCrypt.AesCryptCipherToken;
    var markup_end = AesCrypt.AesCryptEndToken;

    while ((tpart.length % padding) > 0) {
       tpart = tpart.concat(' ');
    }
    tpart = tpart.concat(' ');

    tarr +=AesCtr.encrypt(tpart, pw, 256);
    tarr += ' ';
    tarr += markup_end;
    alert('encrypted: ' + tarr);

  // TODO write result
  AesCrypt.replaceSelection(tarr);
}

AesCrypt.selectionRange = [0, 0];

/**
 * Get selection to be encrypted (selection mode)
 */
AesCrypt.saveSelection = function () {

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
      return [start, end];
      
    // alert the selected text in textarea
    alert(sel.text);
  } else {
    var start = textarea.selectionStart;
    var end = textarea.selectionEnd;
    if (start  < end) {
	return [start, end];
    }
    else {
	alert('Please select text to encrypt');
	return [0,0];
    }
  }
}

AesCrypt.getSelection = function () {
    var start = AesCrypt.selectionRange[0];
    var end = AesCrypt.selectionRange[1];
    var textarea = document.getElementById('text');
    var sel = textarea.value.substring(start, end);
    return sel;
}

AesCrypt.replaceSelection = function (replace) {
    var textarea = document.getElementById('text');
    var start = AesCrypt.selectionRange[0];
    var end = AesCrypt.selectionRange[1];
    var len = textarea.value.length;
    textarea.value = textarea.value.substring(0,start) + replace + textarea.value.substring(end,len);
}


