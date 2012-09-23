<?php if (!defined('PmWiki')) exit();
/*
    filelist.php
    Copyright 2012 Anomen
    Copyright 2007 Hans Bracker
    Copyright 2004-2007 Patrick Michaud
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
    
    Script to create alternative filelists with markup (:filelist:)
*/
$RecipeInfo['FileList']['Version'] = '2012-09-24';

SDV($FileListTimeFmt, '%d %b %Y');
#alternatively use pmwiki's time format:
#$FileListTimeFmt = $TimeFmt;

# load uploads.php now so alt filelist will work
include_once("$FarmD/scripts/upload.php");

# add (:filelist:) as another kind of attachlist
Markup('filelist', '<block', 
  '/\\(:filelist\\s*(.*?):\\)/ei',
  "Keep('<table class=\"filelist\">'.FmtUploadList2('$pagename',PSS('$1')).'</table>')");

# file list generation & formatting
function FmtUploadList2($pagename, $args) {
  global $UploadDir, $UploadPrefixFmt, $UploadUrlFmt, $EnableUploadOverwrite,
    $FileListTimeFmt, $EnableDirectDownload, $HTMLStylesFmt, $FarmPubDirUrl;

   $HTMLStylesFmt['filelist'] = "
   table.filelist { padding:0; margin:0; border-spacing:0; }
   table.filelist td { padding:3px 0 0 0; margin:0; }
   .filelist a { text-decoration:underline; }
   .dotted  { background:url($FarmPubDirUrl/images/dot3.png) repeat-x bottom; }
   .nodots { background:#feffff; }
   ";

  $opt = ParseArgs($args);
  if (@$opt[''][0]) $pagename = MakePageName($pagename, $opt[''][0]);
  if (@$opt['re']) 
    $matchre = '/^(' . $opt['re'] . ')$/i';
  if (@$opt['ext']) 
    $matchext = '/\\.(' 
      . implode('|', preg_split('/\\W+/', $opt['ext'], -1, PREG_SPLIT_NO_EMPTY))
      . ')$/i';
  
  $uploaddir = FmtPageName("$UploadDir$UploadPrefixFmt", $pagename);
  $uploadurl = FmtPageName(IsEnabled($EnableDirectDownload, 1) 
                          ? "$UploadUrlFmt$UploadPrefixFmt/"
                          : "\$PageUrl?action=download&amp;upname=",
                      $pagename);

  $dirp = @opendir($uploaddir);
  if (!$dirp) return '';
  $filelist = array();
  while (($file=readdir($dirp)) !== false) {
    if ($file{0} == '.') continue;
    if (@$matchext && !preg_match(@$matchext, $file)) continue;
    if (@$matchre && !preg_match(@$matchre, $file)) continue;
    $filelist[$file] = $file;
  }
  closedir($dirp);
  $out = array();
  #asort($filelist);
  $overwrite = '';
  foreach($filelist as $file=>$x) {
    $name = PUE("$uploadurl$file");
    $stat = stat("$uploaddir/$file");
   
    if ($EnableUploadOverwrite) 
      $overwrite = FmtPageName("<a class='createlink'
        href='\$PageUrl?action=upload&amp;upname=$file'>&nbsp;&Delta;</a>", 
        $pagename);
  
    $out[] = "<tr><td class='dotted'> <a href='$name'>$file</a>$overwrite &nbsp;&nbsp;</td>"
        ."<td class='dotted' align=right><span class='nodots'>".number_format($stat['size']/1024). "Kb</span></td>"
        ."<td>&nbsp;&nbsp;&nbsp;".strftime($FileListTimeFmt, $stat['mtime'])."</td>" 
        ."<tr>";
   
  }
  return implode("\n",$out);
}
