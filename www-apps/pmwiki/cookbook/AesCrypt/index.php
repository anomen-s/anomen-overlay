<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<?php
 $PubDirUrl = "/aswiki/pub";
?>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>AsWiki test Page</title>
	<!--link rel="stylesheet" type="text/css" href="style.css" /-->
	<link rel="stylesheet" type="text/css" href="<?php echo $PubDirUrl; ?>/aescrypt/subModal.css" />
	<script type="text/javascript" src="<?php echo $PubDirUrl; ?>/aescrypt/common.js"></script>
	<script type="text/javascript" >
	    var gDefaultPage = "<?php echo $PubDirUrl; ?>/aescrypt/loading.html";
	</script>
	<script type="text/javascript" src="<?php echo $PubDirUrl; ?>/aescrypt/subModal.js"></script>
</head>
<body>
<b>DEVELOPMENT PAGE ONLY !!!</b>
<script>
function aescryptEncCallback(password)
{
  var el = document.getElementById('result0');
//  el.style.visibility = 'hidden';
  el.childNodes[0].nodeValue=password;

// alert("val: "+val);
}
</script>
<div style="width:500px;">
<h1>subModal test page</h1>
<p id="result0">result</p>
<p>
This is a test page for the subModal - a DHTML modal dialog solution.
</p>
<button onclick="showPopWin('<?php echo $PubDirUrl; ?>/aescrypt/dialog.html', 400, 200, aescryptEncCallback, true, 'title1');">show modal window button</button>
<br/>
</div>

</body>
</html>
