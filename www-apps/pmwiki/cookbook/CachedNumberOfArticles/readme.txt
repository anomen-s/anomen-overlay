>>recipeinfo<<
Summary: Count pages in wiki
Version: 2011-10-13
Prerequisites:
Status: Stable
Maintainer: [[profiles/Anomen]]
Categories: [[!Includes]]
Users: {$Users} ([[{$FullName}-Users|view]] / [[{$FullName}-Users?action=edit|edit]])
Discussion: [[{$Name}-Talk]]
>><<

!!Description

This recipe reports number of articles in wiki.
Value is obtained from cache unless optional ''refresh'' argument is specified.

!! Usage

!!!Installation

Copy Attach:noa.php into your cookbook dir.

Add to '''local/config.php''':

[@
  require_once($FarmD . '/cookbook/noa.php');
@]

!!! Markup usage

* Use @@(:numberofarticles:)@@ to display number of articles.
* Use @@(:numberofarticles refresh:)@@ to update counter and display correct number of articles.

!! Notes
* Number of articles is cached in @@$WorkDir/.noa@@.
* Pages in wikilib.d (i.e. default articles in groups ''Site'' and ''PmWiki'') are excluded.
* This recipe should work with [[Cookbook/PerGroupSubDirectories]].

!! Comments
(:if false:)
This space is for User-contributed commentary and notes.
Please include your name and a date along with your comment.
Optional alternative:  create a new page with a name like "ThisRecipe-Talk" (e.g. PmCalendar-Talk).
(:if exists {$Name}-Talk:)See Discussion at [[{$Name}-Talk]](:if:)

[[#seealso]]
!! See Also

* [[Cookbook/NumberOfArticles]]

: git repository : http://repo.or.cz/w/anomen-overlay.git/tree/HEAD:/www-apps/pmwiki/cookbook/CachedNumberOfArticles

!! Contributors
* [[~Anomen]]

