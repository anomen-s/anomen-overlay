<?php if (!defined('PmWiki')) exit();

/*
    SortPage

    Adds two sort buttons to edit form.
    Lines in page can be sorted in ascending or descending order.
    Duplicate and empty lines are removed.
    

    Copyright 2011 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

$RecipeInfo['SortPageLines']['Version'] = '2013-01-24';

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
 var lastval = "";
 for(i = 0; i < mySplitResult.length; i++) {
  var curr = mySplitResult[i];
  if ((lastval != curr) && (curr != "")) {
      value = value + curr + "\n";
  }
  lastval = curr;
 }
 textField.value = value;
}
// ]]> 
</script>
';

 if (IsEnabled($EnableGUIButtons)) {
    $GUIButtons['sortpageAsc'] = array(1250, '', '', '',
	'<input type=\"button\" name=\"sortPageButtonAsc\" value=\"$[Sort lines ASC]\" onClick=\"sortPage(0);\" />');
    $GUIButtons['sortpageDesc'] = array(1251, '', '', '',
	'<input type=\"button\" name=\"sortPageButtonDesc\" value=\"$[Sort lines DESC]\" onClick=\"sortPage(1);\" />');
 } else {
    $MessagesFmt[] = "<input type='button' name='sortPageButtonAsc' value='$[Sort lines ASC]' onClick='sortPage(0);'/>";
    $MessagesFmt[] = "<input type='button' name='sortPageButtonDesc' value='$[Sort lines DESC]' onClick='sortPage(1);'/>";
 }
}

