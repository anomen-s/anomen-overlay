>>recipeinfo<<
Summary: How to store backup files of deleted pages in a separate directory
Version: 2011-10-26
Prerequisites: Last tested on [=PmWiki=] version: pmwiki-2.1.beta22
Status:
Maintainer: floozy
Categories: [[!Administration]], [[!CustomPageStore]]
Users: {{$FullName}-Users$Rating2} ([[{$FullName}-Users|View]] / [[{$FullName}-Users?action=edit|Edit]])
Discussion: [[{$Name}-Talk]]
>><<

!! Question
The ''wiki.d/'' directory can get crowded if many pages are deleted, especially in conjunction with the [[Cookbook/ExpireDiff]] recipe. How to store the backup files of deleted pages in a separate directory?

!! Answer
* Put a copy of the Attach:pageattic.php script into your ''cookbook/'' directory.
* Create a new ''wiki.attic/'' subdirectory in your pmwiki folder, and provide it with write permissions (same procedure as for the ''wiki.d/'' directory).
* Add the following lines to your ''local/config.php'' file:

->[@
 include_once('cookbook/pageattic.php');
 $WikiDir = new AtticPageStore($WikiDir->dirfmt);
@]

!! Notes
The location of the attic directory can be controlled by setting the %blue%[@$AtticDir@]%% variable in your ''local/config.php'' file:

    $AtticDir = 'wiki.trash';

The directory is relative to the location containing the main pmwiki.php script, and should be specified without any trailing slash.

!! Contributors
* floozy, 2006-01-29, Initial version
* [[~anomen]], 2011-10-26, minor fixes
