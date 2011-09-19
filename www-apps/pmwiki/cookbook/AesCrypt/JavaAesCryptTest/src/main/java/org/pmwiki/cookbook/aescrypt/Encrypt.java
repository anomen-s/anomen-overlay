package org.pmwiki.cookbook.aescrypt;

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
public class Encrypt {

    public static void main(String[] args) throws Exception
    {
        String password = "TopSecret";
        //byte[] plaintext = "abcdefghijklmnopqrstuvwxyz012345".getBytes();
        byte[] plaintext = "abc".getBytes();

        AesCrypto.encrypt("abc", password, AesCrypto.ZERO_NONCE);
    }

}
