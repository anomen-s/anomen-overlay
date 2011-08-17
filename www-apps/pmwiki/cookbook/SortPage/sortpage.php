<?php if (!defined('PmWiki')) exit();

/*
    SortPage

    Copyright 2006 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

$RecipeInfo['SortPage']['Version'] = '2011-08-17';

$HTMLHeaderFmt[] = '
<script type="text/javascript">
// <![CDATA[
function sortPage() {
 var textField = document.getElementById("text");
 var value = textField.value;

 var mySplitResult = value.split("\n");
 mySplitResult.sort();
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

$MessagesFmt[] = '<input type="button" name="sortPageButton" value="$[Sort lines]" onClick="sortPage();" />';

?>