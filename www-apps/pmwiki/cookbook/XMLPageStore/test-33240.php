<?php
$xml = '<?xml version="1.0" encoding="utf-8"?>
<page>

<text>
some text
line 2

&lt;plugin&gt;
 &lt;groupId&gt;org.apache.maven.plugins&lt;/groupId&gt;
 &lt;artifactId&gt;maven-resources-plugin&lt;/artifactId&gt;
&lt;/plugin&gt;

</text>
</page>
';

$p = xml_parser_create();

    xml_parser_set_option($p,XML_OPTION_CASE_FOLDING, false);
#    xml_parser_set_option($p,XML_OPTION_SKIP_WHITE, true);
    xml_parser_set_option($p,XML_OPTION_TARGET_ENCODING, 'UTF-8');

xml_parse_into_struct($p,  $xml, $structure);
print_r($structure);
xml_parser_free($p);
?>
