package org.pmwiki.cookbook.aescrypt;


import java.io.BufferedReader;
import java.io.InputStreamReader;

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

    public static void main(String[] args) throws Exception
    {
        BufferedReader r = new BufferedReader(new InputStreamReader(System.in));

        System.out.print("Decrypt/encrypt [d/e][u]: ");
        String mode = r.readLine();
        System.out.print("text:                     ");
        String text = r.readLine();
        System.out.print("Password:                 ");
        String password = r.readLine();
        
        System.out.println("Result:                 ");

        KDF kdf;
                
        if ((mode.indexOf('u') > 0)) {
            kdf = new KDF.sha256();
        } else {
            kdf = new KDF.sha256_dup();
        }
        
        if ("d".equalsIgnoreCase(mode)) {
            decrypt(text, password, kdf);
        } else if ("e".equalsIgnoreCase(mode)) {
            encrypt(text, password, kdf);
        }
    }

    public static void decrypt(String encrypted, String password, KDF kdf) throws Exception
    {
        String result = AesCrypto.decryptFromBase64(encrypted, password, kdf);
        
        System.out.println(result);
    }

    public static void encrypt(String text, String password, KDF kdf) throws Exception
    {
        String result = AesCrypto.encryptToBase64(text, password, AesCrypto.randomNonce(), kdf);

        System.out.println(result);
    }
    
    
}
