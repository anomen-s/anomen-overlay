

AesCtr.testVectors = function() {
  var blockSize = 16;  // block size fixed at 16 bytes / 128 bits (Nb=4) for AES
  if (!(nBits==128 || nBits==192 || nBits==256)) return '';  // standard allows 128/192/256 bit keys
  plaintext = Utf8.encode(plaintext);
  password = Utf8.encode(password);
  //var t = new Date();  // timer
	
  var key = [0x60,0x3d,0xeb,0x10,0x15,0xca,0x71,0xbe,0x2b,0x73,0xae,0xf0,0x85,0x7d,0x77,0x81,0x1f,0x35,0x2c,0x07,0x3b,0x61,0x08,0xd7,0x2d,0x98,0x10,0xa3,0x09,0x14,0xdf,0xf4];

  // initialise counter block (NIST SP800-38A §B.2): millisecond time-stamp for nonce in 1st 8 bytes,
  // block counter in 2nd 8 bytes
  var counterBlock = [0xf0,0xf1,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,0xf9,0xfa,0xfb,0xfc,0xfd,0xfe,0xff];

  // TOOD: finish
  
  // generate key schedule - an expansion of the key into distinct Key Rounds for each round
  var keySchedule = Aes.KeyExpansion(key);
  
  var blockCount = Math.ceil(plaintext.length/blockSize);
  var ciphertxt = new Array(blockCount);  // ciphertext as array of strings
  
  for (var b=0; b<blockCount; b++) {
    // set counter (block #) in last 8 bytes of counter block (leaving nonce in 1st 8 bytes)
    // done in two stages for 32-bit ops: using two words allows us to go past 2^32 blocks (68GB)
    for (var c=0; c<4; c++) counterBlock[15-c] = (b >>> c*8) & 0xff;
    for (var c=0; c<4; c++) counterBlock[15-c-4] = (b/0x100000000 >>> c*8)

    var cipherCntr = Aes.Cipher(counterBlock, keySchedule);  // -- encrypt counter block --
    
    // block size is reduced on final block
    var blockLength = b<blockCount-1 ? blockSize : (plaintext.length-1)%blockSize+1;
    var cipherChar = new Array(blockLength);
    
    for (var i=0; i<blockLength; i++) {  // -- xor plaintext with ciphered counter char-by-char --
      cipherChar[i] = cipherCntr[i] ^ plaintext.charCodeAt(b*blockSize+i);
      cipherChar[i] = String.fromCharCode(cipherChar[i]);
    }
    ciphertxt[b] = cipherChar.join(''); 
  }

