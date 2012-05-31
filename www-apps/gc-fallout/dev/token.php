<?php

require_once('phpseclib/AES.php');

define('SEED_LENGTH', 2);

function base64_url_encode($input) {
    return strtr(base64_encode($input), '+', '_');
}

function base64_url_decode($input) {
    return base64_decode(strtr($input, '_', '+'));
}

function aes_encrypt($pass, $plaintext)
{
    $aes = new Crypt_AES(CRYPT_AES_MODE_CTR);

    $size = 32;
    $i = 'a';
    while (strlen($pass) < $size) {
            $pass .= $i;
            $i++;
    }
    $aes->setKey($pass);

    return $aes->encrypt($plaintext);
}

function aes_decrypt($pass, $cipher)
{
    $aes = new Crypt_AES(CRYPT_AES_MODE_CTR);

    $size = 32;
    $i = 'a';
    while (strlen($pass) < $size) {
            $pass .= $i;
            $i++;
    }
    $aes->setKey($pass);

    return $aes->decrypt($cipher);
}

function getToken($U)
{
  $perkyStr = implode('!',$U['perky']);
  $seed = str_pad('', SEED_LENGTH, 'x');
  $plain = "$seed!${U['login']}!${U['karma']}!${U['penize']}!${U['jidlo']}!${U['skore']}!$perkyStr";
  while (strlen($plain) % 3 != 0) { // pad to base64 block
   $plain .= ' ';
  }
  $sha = sha1(PASSWORD . $plain, true);
  for ($i = 0; $i < SEED_LENGTH; $i++) {
    $plain{$i} = $sha{$i};
  }

  $token = aes_encrypt(PASSWORD, $plain);
  $token_b64 = base64_url_encode($token);
  return $token_b64;
}

function decodeToken($token)
{
  $U = array();
  $token_raw = base64_url_decode($token);
  $token_dec = aes_decrypt(PASSWORD, $token_raw);
  $sep = $token_dec{SEED_LENGTH};
  
  $token_check = $token_dec;
  for ($i = 0; $i < SEED_LENGTH; $i++) {
    $token_check{$i} = 'x';
  }
    header('X-Token: '.$token_check );
  $sha = sha1(PASSWORD . $token_check, true);

  if (substr($token_dec,0,SEED_LENGTH) != substr($sha,0,SEED_LENGTH)) {
    // error
    header('X-Error: sha1fail');
    readfile('img/no.png');
    die;
  }
  header('X-Token: ' . $token_check);
  
  $token_list = explode($sep, trim($token_check));
  array_shift($token_list); // = xx
  $U['login'] = array_shift($token_list);
  $U['karma'] = array_shift($token_list);
  $U['penize'] = array_shift($token_list);
  $U['jidlo'] = array_shift($token_list);
  $U['skore'] = array_shift($token_list);

  $U['perky'] = $token_list;
  
  return $U;
}
