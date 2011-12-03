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

    KDF kdf = new KDF.sha256();

    KDF kdf_dup = new KDF.sha256_dup();
    
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
                AesCrypto.decryptFromBase64("AAAAAAAAAABHtF8=", password, kdf));

        assertEquals("abcdefghijklmnopqrstuvwxyz012345",
                AesCrypto.decryptFromBase64("AAAAAAAAAABHtF/GUuR5r+R8gBpKzVQv3FT2osanEmZD1DvoR3m3sQ==", password, kdf));

        assertEquals("abcdef ",
                AesCrypto.decryptFromBase64("xkh3TvX19fUW25PPKKx/", password, kdf));

        assertEquals("abcdef ",
                AesCrypto.decryptFromBase64("NEl3Tvr6+vp0hD2JVD8P", "test1234", kdf));

        assertEquals("zkou\u0161kaZ1234 ",
                AesCrypto.decryptFromBase64("bkp3Tubm5uZY2VAhREboPH5pf0T8dg==", "Heslo1234!$%", kdf));

        // simulate sha256_dup
        assertEquals("test12344",
                AesCrypto.decryptFromBase64("9hraTimUSiWzKE8FHeWPS/Smwq0+pRyk",
                "0TTopSecret9hraTimUSiU=1oTopSecret9hraTimUSiU=2pTopSecret9hraTimUSiU=3STopSecret9hraTimUSiU=4eTopSecret9hraTimUSiU=5cTopSecret9hraTimUSiU=6rTopSecret9hraTimUSiU=7eTopSecret9hraTimUSiU=8tTopSecret9hraTimUSiU=9TTopSecret9hraTimUSiU=10oTopSecret9hraTimUSiU=11pTopSecret9hraTimUSiU=12STopSecret9hraTimUSiU=13eTopSecret9hraTimUSiU=14cTopSecret9hraTimUSiU=15rTopSecret9hraTimUSiU=16eTopSecret9hraTimUSiU=17tTopSecret9hraTimUSiU=18TTopSecret9hraTimUSiU=19oTopSecret9hraTimUSiU=20pTopSecret9hraTimUSiU=21STopSecret9hraTimUSiU=22eTopSecret9hraTimUSiU=23cTopSecret9hraTimUSiU=24rTopSecret9hraTimUSiU=25eTopSecret9hraTimUSiU=26tTopSecret9hraTimUSiU=27TTopSecret9hraTimUSiU=28oTopSecret9hraTimUSiU=29pTopSecret9hraTimUSiU=30STopSecret9hraTimUSiU=31eTopSecret9hraTimUSiU=", kdf).trim());

        assertEquals("test12344",
                AesCrypto.decryptFromBase64("9hraTimUSiWzKE8FHeWPS/Smwq0+pRyk", "TopSecret", kdf_dup).trim());

        assertEquals("AAAAAAAAAADcVPaixqcSZkPUO+hHebex",
                AesCrypto.encryptToBase64("qrstuvwxyz012345", password, AesCrypto.ONE_NONCE, kdf));

    }

}
