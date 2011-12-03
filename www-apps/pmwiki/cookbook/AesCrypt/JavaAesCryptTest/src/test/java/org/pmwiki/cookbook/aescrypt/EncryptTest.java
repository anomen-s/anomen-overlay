/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.pmwiki.cookbook.aescrypt;

import junit.framework.TestCase;
import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.Hex;

/**
 *
 * @author ludek
 */
public class EncryptTest extends TestCase {

    KDF kdf = new KDF.sha256();

    public EncryptTest(String testName) {
        super(testName);
    }

    protected void setUp() throws Exception {
        super.setUp();
    }

    protected void tearDown() throws Exception {
        super.tearDown();
    }

    /**
     * Test of main method, of class Encrypt.
     */
    public void testMain() throws Exception {

        String password = "TopSecret";

        assertEquals("AAAAAAAAAABHtF8=",
                AesCrypto.encryptToBase64("abc", password, AesCrypto.ZERO_NONCE, kdf));

        assertEquals("AAAAAAAAAABHtF/GUuR5r+R8gBpKzVQv3FT2osanEmZD1DvoR3m3sQ==",
                AesCrypto.encryptToBase64("abcdefghijklmnopqrstuvwxyz012345", password, AesCrypto.ZERO_NONCE, kdf));

        assertEquals("AAAAAAAAAADcVPaixqcSZkPUO+hHebex",
                AesCrypto.encryptToBase64("qrstuvwxyz012345", password, AesCrypto.ONE_NONCE, kdf));
    }

    /**
     * Cross check with values from TrueCrypt Test Vectors
     * @throws Exception
     */
    public void testTruecryptRaw() throws Exception
    {
        String key = "ad531905859e62ee0b5ef2cc916cef3949b11d9b8817a8e4d7ac04f44c79e704";
        String plaintext = "00000000000000000000000000000000";
        // encrypt ...
        byte[] expected = Hex.decodeHex("26d63ca237821ec78d16eb7627a33b5f".toCharArray());

        // data encrypted with CTR mode
        byte[] encrypted = Hex.decodeHex("47b45fc652e479afe47c801a4acd542f".toCharArray());
        byte[] result = new byte[16];
        for (int i = 0; i < 16; i++) {
            result[i] =(byte) (expected[i] ^ encrypted[i]);
        }

        System.out.println(new String(result));
        assertEquals("abcdefghijklmnop", new String(result));

    }

}
