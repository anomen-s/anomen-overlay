<?php if (!defined('PmWiki')) exit();

/*
    AesCrypt

    Copyright 2011 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

$RecipeInfo['AesCrypt']['Version'] = '2011-10-04';

SDV($AesCryptKDF, 'sha256');
SDV($AesCryptPlainToken, '(:encrypt ');
SDV($AesCryptCipherToken, '(:aes ');
SDV($AesCryptEndToken, ':)');
SDV($AesCryptPadding, 8);


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
    node.style.display='inline';
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

   tarr += markup2;
   var tpass = prompt('Encrypt key for text starting at position '+tmark,'TopSecret');

   while ((tpart.length % padding) > 0) {
       tpart = tpart.concat(' ');
   }

   tarr +=AesCtr.encrypt(tpart,tpass,256);
   tarr += ' ';
   tarr += markup_end;

   tmark2 += markup_end.length;
   tmark = testt.indexOf(markup1,tmark2);
  }

  tarr += testt.substr(tmark2);

  textField.value = tarr;
}

function registerAesEvent()
{
  var formElement = document.getElementById('text').parentNode;
  //alert(formElement.nodeValue);
/*
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
  // TODO: add protection handler to save buttons
  
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
       '_begin',
       "/\\Q$AesCryptCipherToken\\E\\s*(.*?)\\s*\\Q$AesCryptEndToken\\E/se",
       "'\n'.'<a href=\"javascript:void (0);\" onClick=\"decAesClick(this);\"><span style=\"display:none;\">$1</span><span>[Decrypt]</span></a>'");

if ($action == 'edit') {

 if (IsEnabled($EnableGUIButtons)) {
  $GUIButtons['aescrypt'] = array(750, '', '', '',
   '<a href=\"#\" onclick=\"aesClick(0);\"><img src=\"$GUIButtonDirUrlFmt/aescrypt.png\" title=\"Encrypt\" /></a>');
 } else {
  $MessagesFmt[] = "<input type='button' name='aesButton' value='Encrypt' onClick='aesClick(0);'/>";
 }
}

 // DEV
// $GUIButtons['aescryptDebug'] = array(1750, '', '', '',
//  '<a href=\"#\" onclick=\"registerAesEvent();\"><img src=\"$GUIButtonDirUrlFmt/aescrypt.png\" title=\"dev\" /></a>');

