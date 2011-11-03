[[#contributors]]
!! Contributors
!!!Alternative version by [[~Anomen]].
: git repo : http://repo.or.cz/w/anomen-overlay.git/tree/HEAD:/www-apps/pmwiki/cookbook/AesCrypt
: download : Attach:AesCrypt-0.2.zip

This version fixes several problems:
* non-standard and weak (only 128bit) key derivation function replaced with SHA-256
* rewritten low quality javascript code
* doesn't require $EnableGUIButtons
* disabled decrypting of already decrypted text
* added "Encrypt selection" mode
* alternative implementation available - see Java testing application
* padding plaintext with spaces to conceal exact length of input data (e.q. password)
* add possibility to decrypt text with different password - to be considered...
* ''added protection against unintentional submit of plaintext - not yet''
* ''added support for PBKDF2 - not yet''

!!!! Agorithm description
* plaintext is padded with spaces to achieve length of multiple of $AesCryptPadding
* pseudo-random 64bit nonce is extended to 128bit by appending 64bit counter (zeroes)
* key derivation algorithm (configurable by $AesCryptKDF)
** sha256 (SHA-256 hash of password)
** sha256_dup (SHA-256 hash of longer text constructed using password)
** aes (encrypt password with AES, compatible with original aescrypt-0.1 recipe)
** ''pbkdf2 (not yet implemented)''
* plaintext is encrypted using AES-256 in CTR mode
* output is Base64-encoded concatenation of upper 64 bits of nonce and ciphertext


!!Configuration
: $AesCryptKDF : aes, sha256, sha256_dup, pbkdf2
: $AesCryptPlainToken : starting token for plaintext
: $AesCryptCipherToken : starting token for ciphertext
: $AesCryptEndToken : closing token
: $AesCryptPadding : size of padding block
: $AesCryptSelectionMode : current selection is encrypted instead of content between @@$AesCryptPlainToken@@ and @@$AesCryptEndToken@@
: $EnableGUIButtons : affects rendering of Encrypt button (do not modify it after including aescrypt.php)

!!Usage

Depending on value of @@$AesCryptSelectionMode@@ variable, two modes are available.
When Selection Mode is enabled you only need to select text to encrypt and press encrypt button.

When selection mode is disabled you have to use following syntax to select text to encrypt:

[@ (:encrypt  SecretText :) @]

In both modes, after enering password your page should contain in appropriate place something like this:

[@ (:aes 5QN7Th0dHR2LVA/UjXTDWQ== :) @]

!!!Backward compatibility
Default settings are not compatible with aescrypt-0.1.
To replace aescrypt-0.1 without losing already encrypted data use this code:
[@
$AesCryptKDF='aes';
$AesCryptPlainToken='(:aescrypt:) [=';
$AesCryptCipherToken='(:aescrypted:) [=';
$AesCryptEndToken='=]';
$AesCryptSelectionMode=0;
require_once('cookbook/aescrypt.php');
@]

!!!Java testing application
Build application using Maven:

 mvn install

Use following command to start command-line interface:

 java -jar JavaAesCryptTest-jar-with-dependencies.jar

Note: GUI interface is not yet implemented.
