/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.pmwiki.cookbook.aescrypt;

import java.security.SecureRandom;
import java.util.Random;
import java.util.Arrays;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

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
            byte[] key = DigestUtils.sha256(password);
	    System.out.println("key: "+Arrays.toString(key));
            return key;
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

            byte[] key = DigestUtils.sha256(buffer.toString());
	    System.out.println("key: "+Arrays.toString(key));
            return key;
        }
    }

    public static class aes extends KDF {

        public byte[] getKey(String password, int nBits, byte[] nonce) {

	    int nBytes = nBits/8;
	    byte[] pwBytes = new byte[nBytes];
	    for (int i = 0; i < nBytes; i++) {
		if (password.length() > i)
		    pwBytes[i] = (byte)password.charAt(i);
	    }
    	    System.out.println("pwData: "+Arrays.toString(pwBytes));
	    
	    try {
    		SecretKeySpec key = new SecretKeySpec(pwBytes, "AES");

    		Cipher cipher = Cipher.getInstance("AES/ECB/NoPadding");
    	        cipher.init(Cipher.ENCRYPT_MODE, key);
        	byte[] resultData = cipher.doFinal(pwBytes);

		// key transform valid for aes-256
		for (int i = 0 ; i < 16 ; i++) {
		    resultData[i+16] = resultData[i];
		}

		System.out.println("key: "+Arrays.toString(resultData));

        	return resultData;
            } catch (Exception e) {
        	e.printStackTrace();
        	throw new RuntimeException(e);
            }

        }

    }

}
