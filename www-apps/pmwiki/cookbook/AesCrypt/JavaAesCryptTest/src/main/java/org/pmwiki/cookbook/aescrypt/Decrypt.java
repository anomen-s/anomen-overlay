package org.pmwiki.cookbook.aescrypt;


import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.digest.DigestUtils;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author ludek
 * @author $Author$
 * @version $Rev$
 */
public class Decrypt {

    public static void main(String[] args)throws Exception
    {
        String password = "TopSecret";
        //String encrypted = "AAAAAAAAAABHtF/GUuR5r+R8gBpKzVQv3FT2osanEmZD1DvoR3m3sQ==";
        String encrypted = "AAAAAAAAAABHtF8=";

        byte dataIn[] = Base64.decodeBase64(encrypted);
        byte nonce[] = new byte[16];
        byte enc[] = new byte[dataIn.length - 8];

        System.arraycopy(dataIn, 0, nonce, 0, 8);
        System.arraycopy(dataIn, 8, enc, 0, dataIn.length - 8);

        byte[] keyData = DigestUtils.sha256(password);
        SecretKeySpec key = new SecretKeySpec(keyData, "AES");

        Cipher cipher = Cipher.getInstance("AES/CTR/NoPadding");
        IvParameterSpec ivSpec = new IvParameterSpec(nonce);
        cipher.init(Cipher.DECRYPT_MODE, key, ivSpec);
        byte[] resultData = cipher.doFinal(enc);
        System.out.println(new String(resultData));
    }

}
