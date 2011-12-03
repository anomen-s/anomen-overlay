/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.pmwiki.cookbook.aescrypt;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.digest.DigestUtils;

/**
 *
 * @author ludek
 * @author $Author$
 * @version $Rev$
 */
public abstract class KDF {

    public abstract byte[] getKey(String password, int nBits, byte[] nonce);


    public static class sha256 extends KDF {

        public byte[] getKey(String password, int bits, byte[] nonce) {
            return DigestUtils.sha256(password);
        }
        
    }

    public static class sha256_dup extends KDF {

        public byte[] getKey(String password, int nBits, byte[] nonce) {
            StringBuilder buffer = new StringBuilder();
            int nBytes = nBits/8;
            byte[] nonce8 = new byte[8];
            System.arraycopy(nonce, 0, nonce8, 0, 8);
            String nonceEnc = Base64.encodeBase64String(nonce8).trim();
            for (int i = 0; i < nBytes ; i++) {
                buffer = buffer.append(i);
                buffer = buffer.append(password.charAt(i % password.length()));
                buffer = buffer.append(password);
                buffer = buffer.append(nonceEnc);
            }

            return DigestUtils.sha256(buffer.toString());
        }
    }

    public static class aes extends KDF {

        public byte[] getKey(String password, int nBits, byte[] nonce) {
            throw new UnsupportedOperationException("Not supported yet.");
        }

    }

}
