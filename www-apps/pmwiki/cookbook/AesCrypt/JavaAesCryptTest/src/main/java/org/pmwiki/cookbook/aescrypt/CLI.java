package org.pmwiki.cookbook.aescrypt;


import java.io.BufferedReader;
import java.io.InputStreamReader;
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
public class CLI {

    public static void main(String[] args)throws Exception
    {
        BufferedReader r = new BufferedReader(new InputStreamReader(System.in));

        System.out.print("Decrypt/encrypt [d/e]: ");
        String mode = r.readLine();
        System.out.print("text:                  ");
        String text = r.readLine();
        System.out.print("Password:              ");
        String password = r.readLine();
        
        System.out.println("Result:              ");

        if ("d".equalsIgnoreCase(mode)) {
            decrypt(text, password);
        } else if ("e".equalsIgnoreCase(mode)) {
            encrypt(text, password);
        }
    }

    public static void decrypt(String encrypted, String password) throws Exception
    {
        String result = AesCrypto.decryptFromBase64(encrypted, password);
        
        //System.out.println(result);
    }

    public static void encrypt(String text, String password) throws Exception
    {
        String result = AesCrypto.encryptToBase64(text, password, AesCrypto.randomNonce());

        //System.out.println(result);
    }
    
    
}
