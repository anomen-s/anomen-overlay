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
* created alternative implementation - see Java testing application
* padding plaintext with spaces to conceal exact length of input data (password)
* added protection against unintentional submit of plaintext - not yet
* add support for PBKDF2 - not yet

!!!! Agorithm description
* plaintext is padded with spaces to achieve length of multiple of $AesCryptPadding
* random 64bit nonce is extended to 128bit by appending 64bit counter (zeroes)
* key derivation algorithm (configurable by $AesCryptKDF)
** sha256 (SHA-256 hash of password)
** aes (encrypt password with AES, compatible with original aescrypt-0.1 recipe)
** pbkdf2 (not yet implemented)
* plaintext is encripted using AES-256 in CTR mode
* output is Base64-encoded concatenation of upper 64 bits of nonce and ciphertext


!!Configuration
: $AesCryptKDF : aes, sha256, pbkdf2;
: $AesCryptPlainToken : starting token for plaintext
: $AesCryptCipherToken : starting token for ciphertext
: $AesCryptEndToken : closing token
: $AesCryptPadding : size of padding block
: $EnableGUIButtons : affects rendering of Encrypt button (do not modify it after including aescrypt.php)

!!Usage

Insert following line into your page
[@ (:encrypt  abcdef :) @]

and pres Encrypt button. Line in page is replaced with text similar to:

[@ (:aes 5QN7Th0dHR2LVA/UjXTDWQ== :) @]

!!!Backward compatibility
Default settings are not compatible with aescrytp-0.1.
To replace aescrypt-0.1 without losing already encrypted data use this code:
[@
$AesCryptKDF='aes';
$AesCryptPlainToken='(:aescrypt:) [=';
$AesCryptCipherToken='(:aescrypted:) [=';
$AesCryptEndToken='=]';
require_once('cookbook/aescrypt.php');
@]
