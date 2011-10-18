<?php if (!defined('PmWiki')) exit();

/*
    SortPage

    Copyright 2011 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

$RecipeInfo['SortPageLines']['Version'] = '2011-10-13';

if ($action == 'edit') {

$HTMLHeaderFmt['sortpage'] = '
<script type="text/javascript">
// <![CDATA[


function sortPage(order) {

 var sortPage_fnc = function (a, b) {
    a = a.toLowerCase();
    b = b.toLowerCase();
    return ((a < b) ? -1 : ((a > b) ? 1 : 0));
 }

 var textField = document.getElementById("text");
 var value = textField.value;

 var mySplitResult = value.split("\n");
 mySplitResult.sort(sortPage_fnc);
 if (order == 1) {
  mySplitResult.reverse();
 }   
 var value  = "";
 for(i = 0; i < mySplitResult.length; i++) {
  if (mySplitResult[i] != "") {
     value= value + mySplitResult[i] + "\n";
  }
 }
 textField.value = value;
}
// ]]> 
</script>
';

 if (IsEnabled($EnableGUIButtons)) {
    $GUIButtons['sortpageAsc'] = array(750, '', '', '',
	'<input type=\"button\" name=\"sortPageButtonAsc\" value=\"$[Sort lines ASC]\" onClick=\"sortPage(0);\" />');
    $GUIButtons['sortpageDesc'] = array(751, '', '', '',
	'<input type=\"button\" name=\"sortPageButtonDesc\" value=\"$[Sort lines DESC]\" onClick=\"sortPage(1);\" />');
 } else {
    $MessagesFmt[] = "<input type='button' name='sortPageButtonAsc' value='$[Sort lines ASC]' onClick='sortPage(0);'/>";
    $MessagesFmt[] = "<input type='button' name='sortPageButtonDesc' value='$[Sort lines DESC]' onClick='sortPage(1);'/>";
 }
}

