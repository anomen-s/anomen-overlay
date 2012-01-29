<?php if (!defined('PmWiki')) exit();

/*
    AesCrypt

    Copyright 2011 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

$RecipeInfo['AesCrypt']['Version'] = '2012-DEV';

SDV($AesCryptKDF, 'sha256_dup');
SDV($AesCryptPlainToken, '(:encrypt ');
SDV($AesCryptCipherToken, '(:aes ');
SDV($AesCryptEndToken, ':)');
SDV($AesCryptPadding, 6);
SDV($AesCryptSelectionMode, true);

SDV($HTMLStylesFmt['aescrypt'], "
#aescryptPopupMask {
	position: absolute;
	z-index: 200;
	top: 0px;
	left: 0px;
	width: 100%;
	height: 100%;
	opacity: .4;
	filter: alpha(opacity=40);
	/* this hack is so it works in IE
	 * I find setting the color in the css gives me more flexibility 
	 * than the PNG solution.
	 */
	background-color:transparent !important;
	background-color: #333333;
	/* this hack is for opera support
	 * you can uncomment the background-image if you don't care about opera.
	 * this gives you the flexibility to use any bg color that you want, instead of the png
	 */
	background-image/**/: url('$PubDirUrl/aescrypt/maskBG.png') !important; // For browsers Moz, Opera, etc.
	background-image:none;
	background-repeat: repeat;
	display:none;
}

.aescrypt_overlay {
     visibility: hidden;
     position: absolute;
     left: 0px;
     top: 0px;
     width:100%;
     height:100%;
     text-align:center;
     z-index: 1000;
}

.aescrypt_overlay div {
     width:300px;
     margin: 100px auto;
     background-color: #ffffff;
     border:1px solid #000000;
     padding:15px;
     text-align:center;
}
");


$HTMLHeaderFmt['aescrypt_common'] = "
<script type=\"text/javascript\" src=\"\$PubDirUrl/aescrypt/aescrypt.js\"></script>
<script type=\"text/javascript\">
// <![CDATA[

/**
 * Displays and hides modal dialog.
 */
function aescryptOverlay(id, state) {
  var el = document.getElementById('aescrypt_o_'+id);
  el.style.visibility = (state ? 'visible' : 'hidden');
  if (state) {
    var pw = document.getElementById('aescrypt_p_'+id);
    pw.focus();
    pw.value = '';
  }
}

/**
 * Function invoked on submit of password modal dialog.
 * Performs decryption.
 */
function aescryptDecSubmit(id)
{
 aescryptOverlay(id, false);
 var pwel = document.getElementById('aescrypt_p_'+id);
 var pw = pwel.value;
 pwel.value = 'TopSecret';
 // decrypt all ?
 var allEl = document.getElementById('aescrypt_b_'+id);
 
 var i = id;
 var to = id;
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

/**
 * Key derivation function selected by AesCryptKDF variable.
 */
AesCtr.kdf = function(password, nBits, nonce) {
    return AesCtr.kdf_$AesCryptKDF (password, nBits, nonce);
}

// ]]>
</script>
";

if ($action == 'edit') {
$HTMLHeaderFmt['aescrypt_edit'] = "
<script type=\"text/javascript\">
// <![CDATA[

var aeascryptPopupDiv = false;
/**
 * display modal box for encryption
 */
function aescryptEncPopup()
{
//    alert('123');
    aescryptSelectionRange = aescryptSaveSelection();

//    alert(aescryptSelectionRange);
  if (!aeascryptPopupDiv) {
    var popup =  '<div id=\'aescrypt_o_enc\' class=\'aescrypt_overlay\'>' 
	+ '<div>' 
	+ '<p id=\'aescrypt_l_enc\'>Encrypt selected text:</p>' 
	+ '<form id=\'aescrypt_f_enc\' onsubmit=\'aescryptEncSubmit();return false;\'>' 
	+ '<input type=\'password\' name=\'aescrypt_p_enc\' id=\'aescrypt_p_enc\' />' 
	+ '<input type=\'submit\'  />' 
	+ '</form>' + '</div>' + '</div>';

	var theBody = document.getElementsByTagName('BODY')[0];
	var popmask = document.createElement('div');
	popmask.id = 'aescryptPopupMask';
	var popcont = document.createElement('div');
	popcont.id = 'aescrypt_x_enc';
	popcont.innerHTML = popup;

	theBody.appendChild(popmask);
	theBody.appendChild(popcont);
	
	aeascryptPopupDiv = true;
  }
    var pwel = document.getElementById('aescrypt_p_enc');
    pwel.value = '';

  aescryptOverlay('enc',true);
}

/**
  * Hide modal box and encrypt selection
  * - how to get selection?
  * - 
  */
function aescryptEncSubmit() {

    var tpart = aescryptGetSelection();
    
    var pwel = document.getElementById('aescrypt_p_enc');
    var pw = pwel.value;
    pwel.value = 'TopSecret';

    aescryptOverlay('enc', false);

    var padding = $AesCryptPadding;
    var tarr = '$AesCryptCipherToken';
    var markup_end = '$AesCryptEndToken';

    while ((tpart.length % padding) > 0) {
       tpart = tpart.concat(' ');
    }
    tpart = tpart.concat(' ');

    tarr +=AesCtr.encrypt(tpart, pw, 256);
    tarr += ' ';
    tarr += markup_end;
    alert('encrypted: ' + tarr);

  // TODO write result
  aescryptReplaceSelection(tarr);
}

var aescryptSelectionRange = [0, 0];

/**
 * Get selection to be encrypted (selection mode)
 */
function aescryptSaveSelection() {

  var textarea = document.getElementById('text');

  if (document.selection) { // IE variant
     textarea.focus();
     //var sel = document.selection.createRange();
     
     // TODO: save selection object (easier, might not work)
     // or save start,length and reconstruct later ?
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
    // alert(sel.text);
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

function aescryptGetSelection() {
    var start = aescryptSelectionRange[0];
    var end = aescryptSelectionRange[1];
    var textarea = document.getElementById('text');
    var sel = textarea.value.substring(start, end);
    return sel;
}

function aescryptReplaceSelection(replace) {
    var textarea = document.getElementById('text');
    var start = aescryptSelectionRange[0];
    var end = aescryptSelectionRange[1];
    var len = textarea.value.length;
    textarea.value = textarea.value.substring(0,start) + replace + textarea.value.substring(end,len);
}

// ]]>
</script>
";
}


/* generate decryption code */
function aescryptMarkup($ciphertext)
{
    static $id = 0;
    $id++;
    $res = "\n";
    $res .= "<div id=\"aescrypt_c_$id\" style=\"white-space:pre;display:none;\">$ciphertext</div>";
    $res .= "<div id=\"aescrypt_d_$id\">";
    $res .= "<a id=\"aescrypt_a_$id\" href=\"javascript:void (0);\" onClick=\"aescryptOverlay($id, true);\">";
    $res .= "[Decrypt]";
    $res .= "</a>";
    $res .= "</div>";
    $c = $ciphertext;
    if (strlen($c) > 30) {
      $c = substr($c, 0, 27) . "...";
    }
    $res .= "<div id=\"aescrypt_o_$id\" class=\"aescrypt_overlay\">
     <div>
          <p id=\"aescrypt_l_$id\">Decrypting \"$c\".</p>
          <form id=\"aescrypt_f_$id\" onsubmit=\"aescryptDecSubmit($id);return false;\">
           <label for=\"aescrypt_p_$id\">Password </label>
           <input type=\"password\" name=\"aescrypt_p_$id\" id=\"aescrypt_p_$id\" />
           <br />
           <input type=\"checkbox\" name=\"aescrypt_b_$id\" id=\"aescrypt_b_$id\" value=\"true\" />
           <label for=\"aescrypt_b_$id\">decrypt all</label>
           <br />
           <input type=\"submit\"  />
          </form>
        </div>
    </div>";

    return $res;
}

Markup('aescrypt',
       'directives',
       "/\\Q$AesCryptCipherToken\\E\\s*(.*?)\\s*\\Q$AesCryptEndToken\\E/se",
       "aescryptMarkup('$1')");

if ($action == 'edit') {

 if (IsEnabled($EnableGUIButtons)) {
  $GUIButtons['aescrypt'] = array(750, '', '', '',
  // TODO:  add overlay DIV here & test browsers
   "<a href='#' onclick='aescryptEncPopup();'><img src='\$GUIButtonDirUrlFmt/aescrypt.png' title='Encrypt' /></a>");
 } else {
  // TODO: simply add overlay DIV here
  $MessagesFmt[] = "<input type='button' name='aesButton' value='Encrypt' onClick='aescryptEncPopup();'/>";
  
 }
}


