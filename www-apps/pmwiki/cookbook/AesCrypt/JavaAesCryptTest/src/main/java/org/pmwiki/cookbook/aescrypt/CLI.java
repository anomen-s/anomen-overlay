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


        System.out.println("Modes: ");
        System.out.println(" d = decrypt (default)");
        System.out.println(" e = encrypt ");
        System.out.println("KDF: ");
        System.out.println(" s = sha256");
        System.out.println(" u = sha256_dup (default)");
        System.out.println(" a = aes");

        System.out.print("Decrypt/encrypt [d/e][s/u/a]: ");
        String mode = r.readLine();
        System.out.print("text:                     ");
        String text = r.readLine();
        System.out.print("Password:                 ");
        String password = r.readLine();
        
        System.out.println("Result:                 ");

        KDF kdf;
        
        mode = mode.toLowerCase();
        
        if ((mode.indexOf('s') >= 0)) {
            kdf = new KDF.sha256();
        } else if ((mode.indexOf('a') >= 0)) {
            kdf = new KDF.aes();
        } else {
            kdf = new KDF.sha256_dup();
        }
        
        if (mode.indexOf('e') >= 0) {
            encrypt(text, password, kdf);
        } else {
            decrypt(text, password, kdf);
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
