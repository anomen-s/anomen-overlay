<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>
<?php

function Markup($a=0, $b=0, $c=0, $d=0)
{
 return ""; // dummy

}
function SDV($a, $b)
{
 return ""; // dummy
}

define("PmWiki", "1");
include("geobox.php");

$c[] = "N50 E14";
$c[] = "50° 14°";
$c[] = "50° N 14° E";
$c[] = "N 50° E 14°";
$c[] = "S 50° W 14°";
$c[] = "50.0 14.0";
$c[] = "50.230° 14.440°";
$c[] = "50°35.4' 14°22'";
$c[] = "50.3°35.4'44\" 14.1°22'22\"";
$c[] = "N 50.3°35.4'44'' E14.1°22'22''";
$c[] = " 50.3°35.4'44''N 14.1°22'22''W";

foreach($c as $coord) 
{
 $r = parse_coords($coord);
 echo "<div>Str: \"$coord\" ->  [${r[0]},${r[1]},${r['result']}] </div>\n";
}



?>
</body>
</html>
