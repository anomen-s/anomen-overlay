<?php if (!defined('PmWiki')) exit();

/*
    XMLPageStore

    Copyright 2006 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
*/

SDV($XMLPages,false);


class XMLPageStore extends PageStore {

  function read_xml($data, $since=0)
  {
    global $Charset;
    $p = xml_parser_create();
    xml_parser_set_option($p,XML_OPTION_CASE_FOLDING, false);
    xml_parser_set_option($p,XML_OPTION_SKIP_WHITE, true);
    xml_parser_set_option($p,XML_OPTION_TARGET_ENCODING, $Charset);

    xml_parse_into_struct($p, $data, $vals, $index);
    xml_parser_free($p);
    foreach($vals as $v) {
	if (($v['type'] == 'complete') && ($v['level'] == 2)) {
	    $k = $v['tag'];
	    $t = $v['attributes']['time'];
	    $p = $v['attributes']['prev'];

	    
	    if (!empty($t)) {
    		if ($since > 0 && $t < $since) {
        	    continue;
    		}
		$k = "$k:$t";
    	    }
	    if (!empty($p)) {
		$k = "$k:$p:";
    	    }
    	    $page[$k] = $v['value'];
	}
     }
    return @$page;
  }

  function read($pagename, $since=0) {
    $newline = '';
    $urlencoded = false;
    $pagefile = $this->pagefile($pagename);
    if ($pagefile && ($fp=@fopen($pagefile, "r"))) {
      while (!feof($fp)) {
        $line = fgets($fp, 4096);
        if (substr($line,0,5) == "<?xml") {
    	    fseek($fp, 0, SEEK_SET);
	    $pagefilesize = filesize($pagefile);
    	    $data = fread($fp, $pagefilesize);
    	    $page = $this->read_xml($data, $since);
    	    break;
        }
        while (substr($line, -1, 1) != "\n" && !feof($fp)) 
          { $line .= fgets($fp, 4096); }
        $line = rtrim($line);
        if ($urlencoded) $line = urldecode(str_replace('+', '%2b', $line));
        @list($k,$v) = explode('=', $line, 2);
        if (!$k) continue;
        if ($k == 'version') { 
          $ordered = (strpos($v, 'ordered=1') !== false); 
          $urlencoded = (strpos($v, 'urlencoded=1') !== false); 
          if (strpos($v, 'pmwiki-0.')!==false) $newline="\262";
        }
        if ($k == 'newline') { $newline = $v; continue; }
        if ($since > 0 && preg_match('/:(\\d+)/', $k, $m) && $m[1] < $since) {
          if ($ordered) break;
          continue;
        }
        if ($newline) $v = str_replace($newline, "\n", $v);
        $page[$k] = $v;
      }
      fclose($fp);
    }
    return @$page;
  }

  function write($pagename,$page) {
    global $XMLPages;  
    ($XMLPages == true) ? $this->write_xml($pagename,$page) : parent::write($pagename,$page);
  }
  
  function write_xml($pagename,$page) {
    global $Now, $Version, $Charset;
    $page['name'] = $pagename;
    $page['time'] = $Now;
    $page['host'] = $_SERVER['REMOTE_ADDR'];
    $page['agent'] = @$_SERVER['HTTP_USER_AGENT'];
    $page['rev'] = @$page['rev']+1;
    unset($page['version']); unset($page['newline']);
    uksort($page, 'CmpPageAttr');
    $s = false;
    $pagefile = $this->pagefile($pagename);
    $dir = dirname($pagefile); mkdirp($dir);
    if ($pagefile && ($fp=fopen("$pagefile,new","w"))) {
      $x = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<page xmlns=\"http://www.pmwiki.org/anomen/xmlpage\" version=\"$Version\">\n";
      $s = true && fputs($fp, $x); $sz = strlen($x);
      foreach($page as $k=>$v) 
        if ($k > '' && $k{0} != '=') {
    	  $v = htmlspecialchars($v, ENT_NOQUOTES, $Charset);
    	  if (preg_match("/^([a-z]+)(?::(\d+))(?::(\d+):)?$/", $k, $m)) {
    	    $p = empty($m[3]) ? "" : " prev=\"${m[3]}\"";
            $x = "<${m[1]} time=\"${m[2]}\"$p>$v</${m[1]}>\n";
    	  } else {
            $x = "<$k>$v</$k>\n";
          }
          $s = $s && fputs($fp, $x); $sz += strlen($x);
        }
      $x = "</page>\n";
      $s = $s && fputs($fp, $x); $sz += strlen($x);

      $s = fclose($fp) && $s;
      $s = $s && (filesize("$pagefile,new") > $sz * 0.95);
      if (file_exists($pagefile)) $s = $s && unlink($pagefile);
      $s = $s && rename("$pagefile,new", $pagefile);
    }
    $s && fixperms($pagefile);
    if (!$s)
      Abort("Cannot write page to $pagename ($pagefile)...changes not saved");
    PCache($pagename, $page);
  }


}

?>