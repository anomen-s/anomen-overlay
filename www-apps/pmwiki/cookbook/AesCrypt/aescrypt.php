<?php if (!defined('PmWiki')) exit();

$HTMLHeaderFmt['aescrypt'] = "

<script type=\"text/javascript\" src=\"\$PubDirUrl/aescrypt/sha256.js\"></script>
<script type=\"text/javascript\" src=\"\$PubDirUrl/aescrypt/aes.js\"></script>
<script type=\"text/javascript\">
// <![CDATA[

function aesClick() {

  var textField = document.getElementById('text');

  var markup1 = '(:aescrypt ';
  var markup2 = '(:aes ';
  var markup_end = ':)';

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
   tarr +=AesCtr.encrypt(tpart,tpass,256);
   tarr += ' ';
   tarr += markup_end;

   tmark2 += 2;
   tmark = testt.indexOf(markup1,tmark2);
  }

  tarr += testt.substr(tmark2);

  textField.value = tarr;
}


function decAesClick(elem) {
    var node = elem.childNodes[0];
    var nodeDec = elem.childNodes[1];
    if (nodeDec.style.visibility=='hidden') {
        return;
    }
    var aesDecrypt = node.childNodes[0].nodeValue;
    var res = AesCtr.decrypt(aesDecrypt,prompt('Decrypt key','TopSecret'),256);
    node.childNodes[0].nodeValue = res;
    node.style.display='inline';
    nodeDec.style.visibility='hidden';
    nodeDec.style.display='none';
}

// ]]>
</script>
";

Markup('aescrypt',
       'inline',
       "/\\(:aes\\s*(.*?)\s*:\\)/se",
       "'\n'.'<a href=\"javascript:void (0);\" onClick=\"decAesClick(this);\"><span style=\"display:none;\">$1</span><span>[Decrypt]</span></a>'");

if ($action == 'edit') {
 $GUIButtons['aescrypt'] = array(750, '', '', '',
  '<a href=\"#\" onclick=\"aesClick(0);\"><img src=\"$GUIButtonDirUrlFmt/aescrypt.png\" title=\"Encrypt\" /></a>');
}


