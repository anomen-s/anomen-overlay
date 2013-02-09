[[#contributors]]
!! Contributors
!!!Alternative version by [[~Anomen]].
: git repo : http://repo.or.cz/w/anomen-overlay.git/tree/HEAD:/www-apps/pmwiki/cookbook/AesCrypt
: download : Attach:AesCrypt-2011-12-17.zip

This version fixes several problems:
* non-standard and weak (only 128bit) key derivation function replaced with SHA-256
* rewritten low quality javascript code
* doesn't require $EnableGUIButtons
* disabled decrypting of already decrypted text
* "Encrypt selection" mode
* alternative implementation available - see Java testing application
* padding plaintext with spaces to conceal exact length of input data (e.q. password)
* Add javascript-controlled password input box to provide secure password entry

!!Advanced Configuration
: $AesCryptKDF : aes, sha256, sha256_dup (default)
: $AesCryptCipherToken : starting token for ciphertext
: $AesCryptEndToken : closing token for ciphertext
: $AesCryptPadding : size of padding block
: $EnableGUIButtons : affects rendering of Encrypt button (do not modify it after including aescrypt.php)

!!Usage
When editing page select text to be encrypted.
Then press encrypt button in toolbar above textarea.
Popup dialog for entering password will appear.
After submitting password your page should contain in appropriate place something like this:

[@ (:aes 5QN7Th0dHR2LVA/UjXTDWQ :) @]

!!!Backward compatibility
Default settings are not compatible with aescrypt-0.1.
To replace aescrypt-0.1 without losing already encrypted data use this code:
[@
$AesCryptKDF='aes';
$AesCryptCipherToken='(:aescrypted:) [=';
$AesCryptEndToken='=]';
require_once("$FarmD/cookbook/aescrypt.php");
@]

!!!Supported browsers
This recipe should work in all current browsers (as of end of 2012) with JavaScript support. 
It was successfully tested on:
* Windows (IE, Firefox, Opera, Chrome)
* Linux (Firefox, Opera, Chromium)
* Android (Opera Mini 7.5 !!! This browser sends password to Opera servers !!!)

!!!Java testing application
Build application using Maven:

 mvn install

Use following command to start command-line interface:

 java -jar JavaAesCryptTest-jar-with-dependencies.jar

Note: GUI interface is not yet implemented.
