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
SDV($AesCryptCipherToken, '(:aes ');
SDV($AesCryptEndToken, ':)');
SDV($AesCryptPadding, 6);

SDV($HTMLStylesFmt['aescrypt'], "
#aescrypt_m {
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
	background-color:#cccccc;
	background-repeat: repeat;
	/*display:none; */
	visibility: hidden;
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
<script type=\"text/javascript\" src=\"\$PubDirUrl/aescrypt/main.js\"></script>
<script type=\"text/javascript\">
// <![CDATA[

/**
 * Key derivation function selected by AesCryptKDF variable.
 */
AesCtr.kdf = function(password, nBits, nonce) {
    return AesCtr.kdf_$AesCryptKDF (password, nBits, nonce);
}

AesCrypt.AesCryptCipherToken = '$AesCryptCipherToken';
AesCrypt.AesCryptEndToken = '$AesCryptEndToken';
AesCrypt.AesCryptPadding = $AesCryptPadding;

// ]]>
</script>
";

/* generate decryption code */
function aescryptMarkup($ciphertext)
{
    static $id = 0;
    $id++;
    $res = "\n";
    $res .= "<div id=\"aescrypt_c_$id\" style=\"white-space:pre;display:none;\">$ciphertext</div>";
    $res .= "<div id=\"aescrypt_d_$id\">";
    $res .= "<a id=\"aescrypt_a_$id\" href=\"javascript:void (0);\" onClick=\"AesCrypt.decPopup($id);\">";
    $res .= "[Decrypt]";
    $res .= "</a>";
    $res .= "</div>";
    return $res;
}

Markup('aescrypt',
       'directives',
       "/\\Q$AesCryptCipherToken\\E\\s*(.*?)\\s*\\Q$AesCryptEndToken\\E/se",
       "aescryptMarkup('$1')");

if ($action == 'edit') {

 if (IsEnabled($EnableGUIButtons)) {
  $GUIButtons['aescrypt'] = array(750, '', '', '',
   "<a href='#' onclick='AesCrypt.encPopup();'><img src='\$GUIButtonDirUrlFmt/aescrypt.png' title='Encrypt' /></a>");
 } else {
  $MessagesFmt[] = "<input type='button' name='aesButton' value='Encrypt' onClick='AesCrypt.encPopup();'/>";
 }
}


