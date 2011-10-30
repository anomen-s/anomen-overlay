/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.pmwiki.cookbook.aescrypt;

import java.security.SecureRandom;
import java.util.Random;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.Hex;
import org.apache.commons.codec.digest.DigestUtils;

/**
 *
 * @author ludek
 * @author $Author$
 * @version $Rev$
 */
public class AesCrypto {

    public static final byte[] ZERO_NONCE = new byte[16];

    public static final byte[] ONE_NONCE = new byte[] {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
    };

    public static byte[] randomNonce() {

        Random r = new SecureRandom();
        byte[] nonce = new byte[16];
        for (int i = 0; i < 8; i++) {
            nonce[i] = (byte) r.nextInt();
        }
        return nonce;
    }
    
    public static byte[] encrypt (String plaintext, String password, byte[] nonce) throws Exception
    {
        return encrypt(plaintext, DigestUtils.sha256(password), nonce);
    }

    public static String encryptToBase64(String plaintext, String password, byte[] nonce) throws Exception
    {
        return Base64.encodeBase64String(encrypt(plaintext, password, nonce)).trim();
    }

    public static byte[] encrypt (String plaintext, byte[] keyData, byte[] nonce) throws Exception
    {

        SecretKeySpec key = new SecretKeySpec(keyData, "AES");

        Cipher cipher = Cipher.getInstance("AES/CTR/NoPadding");
        IvParameterSpec ivSpec = new IvParameterSpec(nonce);
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
        byte[] resultData = cipher.doFinal(plaintext.getBytes());

        byte enc[] = new byte[8 + resultData.length];

        System.arraycopy(nonce, 0, enc, 0, 8);
        System.arraycopy(resultData, 0, enc, 8, resultData.length);

        System.out.println(Hex.encodeHexString(enc));
        System.out.println(Base64.encodeBase64String(enc));
        return enc;
    }

    public static String decrypt (byte[] cipher, String password, byte[] nonce) throws Exception
    {
        return decrypt(cipher, DigestUtils.sha256(password), nonce);
    }

    public static String decryptFromBase64(String ciphertext, String password) throws Exception
    {

        byte[] dataIn = Base64.decodeBase64(ciphertext);
        byte[] nonce = new byte[16];

        byte enc[] = new byte[dataIn.length - 8];

        System.arraycopy(dataIn, 0, nonce, 0, 8);
        System.arraycopy(dataIn, 8, enc, 0, dataIn.length - 8);

        return decrypt(enc, password, nonce);
    }

    public static String decryptFromBase64RawKey(String ciphertext, byte[] keyData) throws Exception
    {

        byte[] dataIn = Base64.decodeBase64(ciphertext);
        byte[] nonce = new byte[16];

        byte enc[] = new byte[dataIn.length - 8];

        System.arraycopy(dataIn, 0, nonce, 0, 8);
        System.arraycopy(dataIn, 8, enc, 0, dataIn.length - 8);

        return decrypt(enc, keyData, nonce);
    }

    public static String decrypt (byte[] ciphertext, byte[] keyData, byte[] nonce) throws Exception
    {

        SecretKeySpec key = new SecretKeySpec(keyData, "AES");

        Cipher cipher = Cipher.getInstance("AES/CTR/NoPadding");
        IvParameterSpec ivSpec = new IvParameterSpec(nonce);
        cipher.init(Cipher.DECRYPT_MODE, key, ivSpec);
        byte[] resultData = cipher.doFinal(ciphertext);
        System.out.println(new String(resultData));
        return new String(resultData);
    }


}
