/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.pmwiki.cookbook.aescrypt;

import junit.framework.TestCase;

/**
 *
 * @author ludek
 * @author $Author$
 * @version $Rev$
 */
public class PmWikiTest extends TestCase {

    public PmWikiTest(String testName) {
        super(testName);
    }

    protected void setUp() throws Exception {
        super.setUp();
    }

    protected void tearDown() throws Exception {
        super.tearDown();
    }

    int[] keyDataInt = {
        157,150,47,15,254,201,114,195,231,120,61,61,128,55,254,200,157,150,47,15,254,201,114,195,231,120,61,61,128,55,254,200
    };
    byte[] keyData;


    public void testMain() throws Exception {

        System.out.println("Original cookbook/aescrypt recipe keys");
        assertEquals(32, keyDataInt.length);
        
        keyData = new byte[keyDataInt.length];
        for (int i =0 ; i < keyDataInt.length ; i++) {
            keyData[i] = (byte) keyDataInt[i];
        }

        //String password = "TopSecret";

        assertEquals("abcdefghijklmnopqrstuvwyz ",
                AesCrypto.decryptFromBase64RawKey("NIVjTk5OTk56djkEMVROFPZNCJHpBRL40DIgUK0xxsSh+A==", keyData));

        assertEquals("abcdefghijklmnopqrstuvwyz ",
                AesCrypto.decryptFromBase64RawKey("SIdjTtzc3NxGUSy001bgrExMOByI4NE6SWDJj3FycLwa6A==", keyData));

        assertEquals("abc",
                AesCrypto.decryptFromBase64RawKey("1ohjTsnJycmALuk=", keyData));

        assertEquals(" Encrypt this text ",
                AesCrypto.decryptFromBase64RawKey("jvJ5Tnl5eXnpdK89gmpkiWxjkmi73OoGc72C", keyData));


    }
}
