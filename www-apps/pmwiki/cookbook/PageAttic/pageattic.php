<?php if (!defined('PmWiki')) exit();

/*
    PageAttic

    Copyright 2006 floozy
    Copyright 2011 Anomen (ludek_h@seznam.cz)
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
    
    
    Usage:
    Create wiki.attic directory 
    Add to local/config.php:

    include_once('cookbook/pageattic.php');
    $WikiDir = new AtticPageStore($WikiDir->dirfmt);

*/

$RecipeInfo['PageAttic']['Version'] = '2011-10-26';

SDV($AtticDir,'wiki.attic');

class AtticPageStore extends PageStore {

  function delete($pagename) {
    global $AtticDir, $Now;

    if (!file_exists("$AtticDir/.htaccess") && $fp = @fopen("$AtticDir/.htaccess", "w")) {
      fwrite($fp, "Order Deny,Allow\nDeny from all\n"); 
      fclose($fp); 
    }

    $pagefile = $this->pagefile($pagename);
    @rename($pagefile,"$AtticDir/".basename($pagefile).",del-$Now");
  }

}
