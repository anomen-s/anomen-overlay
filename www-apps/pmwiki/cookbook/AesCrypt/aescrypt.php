<?php if (!defined('PmWiki')) exit();

/*
    AesCrypt

    Copyright 2011 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

$RecipeInfo['AesCrypt']['Version'] = '2011-12-12';

SDV($AesCryptKDF, 'sha256_dup');
SDV($AesCryptPlainToken, '(:encrypt ');
SDV($AesCryptCipherToken, '(:aes ');
SDV($AesCryptEndToken, ':)');
SDV($AesCryptPadding, 8);
SDV($AesCryptSelectionMode, 1);


$HTMLHeaderFmt['aescrypt_common'] = "
<script type=\"text/javascript\" src=\"\$PubDirUrl/aescrypt/aescrypt.js\"></script>
<script type=\"text/javascript\">
// <![CDATA[

AesCtr.kdf = AesCtr.kdf_$AesCryptKDF;

function decAesClick(elem) {
    var node = elem.childNodes[0];
    var nodeDec = elem.childNodes[1];
    if (nodeDec.style.visibility=='hidden') {
        return;
    }
    var aesDecrypt = node.childNodes[0].nodeValue;
    var res = AesCtr.decrypt(aesDecrypt,prompt('Decrypt key','TopSecret'),256);
    res = res.replace(/^\\s\\s*/, '').replace(/\\s\\s*\$/, '');
    node.childNodes[0].nodeValue = res;
    node.style.display='block';
    nodeDec.style.visibility='hidden';
    nodeDec.style.display='none';
}
// ]]>
</script>
";

if ($action == 'edit') {
$HTMLHeaderFmt['aescrypt_edit'] = "
<script type=\"text/javascript\">
// <![CDATA[

function aesPrompt(tmark, tpart) {
    var padding = $AesCryptPadding;
    var tarr = '$AesCryptCipherToken';
    var markup_end = '$AesCryptEndToken';

    var tpass = prompt('Encrypt key for text starting at position '+tmark,'TopSecret');

    while ((tpart.length % padding) > 0) {
       tpart = tpart.concat(' ');
    }

    tarr +=AesCtr.encrypt(tpart,tpass,256);
    tarr += ' ';
    tarr += markup_end;
    return tarr;
}

function aesSelectionClick() {

  var textarea = document.getElementById('text');

  if (document.selection) { // IE variant
    textarea.focus();
    var sel = document.selection.createRange();
    // alert the selected text in textarea
    // alert(sel.text);
    // Finally replace the value of the selected text with this new replacement one
    if (sel != null && sel.text != null && sel.text != '' ) {
	sel.text = aesPrompt('[selection]', sel.text);
    } else {
	alert('Please select text to encrypt');
    }
  } else {
    var len = textarea.value.length;
    var start = textarea.selectionStart;
    var end = textarea.selectionEnd;
    var sel = textarea.value.substring(start, end);
           
    if (start  < end) {
        var replace =  aesPrompt(start, sel);
	// Here we are replacing the selected text with this one
	textarea.value =  textarea.value.substring(0,start) + replace + textarea.value.substring(end,len);
    }
    else {
	alert('Please select text to encrypt');
	return;
    }
  }
  
}


function aesClick() {

  var textField = document.getElementById('text');

  var markup1 = '$AesCryptPlainToken';
  var markup2 = '$AesCryptCipherToken';
  var markup_end = '$AesCryptEndToken';
  var padding = $AesCryptPadding;

  var testt = textField.value;
  var tmark2 = 0;
  var tarr = new String;
  var tmark = testt.indexOf(markup1);

  while(tmark >= 0) {
   tarr += testt.substring(tmark2,tmark);
   tmark2 = testt.indexOf(markup_end,tmark);
   var tpart = testt.substring(tmark+markup1.length,tmark2);

   tarr += aesPrompt(tmark, tpart);

   tmark2 += markup_end.length;
   tmark = testt.indexOf(markup1,tmark2);
  }

  tarr += testt.substr(tmark2);

  textField.value = tarr;
}

function registerAesEvent()
{
  // TODO: add protection handler to save buttons
/*
  var formElement = document.getElementById('text').parentNode;
  //alert(formElement.nodeValue);

  var inputs = document.getElementsByTagName('input');
  var button;
  for (var i=0; i < inputs.length; i++)
  {
     if ((inputs[i].getAttribute('type') == 'submit') && (inputs[i].getAttribute('name') == name))
     {
        button = inputs[i];
     }
  }
  */
  
}

if ( document.addEventListener ) {
  window.addEventListener( 'load', registerAesEvent, false );
} else if ( document.attachEvent ) {
  window.attachEvent( 'onload', registerAesEvent );
}

// ]]>
</script>
";
}

Markup('aescrypt',
       'directives',
       "/\\Q$AesCryptCipherToken\\E\\s*(.*?)\\s*\\Q$AesCryptEndToken\\E/se",
       "'\n'.'<a href=\"javascript:void (0);\" onClick=\"decAesClick(this);\"><div style=\"white-space:pre;display:none;\">$1</div><span>[Decrypt]</span></a>'");

if ($action == 'edit') {

 $aesBtnFunction = (IsEnabled($AesCryptSelectionMode)) ? 'aesSelectionClick' : 'aesClick';

 if (IsEnabled($EnableGUIButtons)) {
  $GUIButtons['aescrypt'] = array(750, '', '', '',
   "<a href='#' onclick='$aesBtnFunction();'><img src='\$GUIButtonDirUrlFmt/aescrypt.png' title='Encrypt' /></a>");
 } else {
  $MessagesFmt[] = "<input type='button' name='aesButton' value='Encrypt' onClick='$aesBtnFunction();'/>";
 }
}

 // DEV
// $GUIButtons['aescryptDebug'] = array(1750, '', '', '',
//  '<a href=\"#\" onclick=\"registerAesEvent();\"><img src=\"$GUIButtonDirUrlFmt/aescrypt.png\" title=\"dev\" /></a>');

