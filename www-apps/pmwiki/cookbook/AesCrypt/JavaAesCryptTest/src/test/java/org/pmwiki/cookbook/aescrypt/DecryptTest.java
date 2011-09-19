/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.pmwiki.cookbook.aescrypt;

import junit.framework.TestCase;
import org.apache.commons.codec.digest.DigestUtils;

/**
 *
 * @author ludek
 */
public class DecryptTest extends TestCase {
    
    public DecryptTest(String testName) {
        super(testName);
    }

    protected void setUp() throws Exception {
        super.setUp();
    }

    protected void tearDown() throws Exception {
        super.tearDown();
    }

    /**
     * Test of main method, of class Decrypt.
     */
    public void testMain() throws Exception {
        String password = "TopSecret";

        System.out.println(DigestUtils.sha256Hex(password));
        
        assertEquals("abc",
                AesCrypto.decryptFromBase64("AAAAAAAAAABHtF8=", password));

        assertEquals("abcdefghijklmnopqrstuvwxyz012345",
                AesCrypto.decryptFromBase64("AAAAAAAAAABHtF/GUuR5r+R8gBpKzVQv3FT2osanEmZD1DvoR3m3sQ==", password));

        assertEquals("abcdef ",
                AesCrypto.decryptFromBase64("AC13Tnd3d3emp8VsKzQR", password));

        assertEquals("AAAAAAAAAADcVPaixqcSZkPUO+hHebex",
                AesCrypto.encryptToBase64("qrstuvwxyz012345", password, AesCrypto.ONE_NONCE));

    }

}
