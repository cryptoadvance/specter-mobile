package specter_mobile_java

import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.security.keystore.KeyInfo

import java.io.File
import java.nio.charset.Charset
import java.security.KeyStore
import java.security.KeyStoreException
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.SecretKeyFactory
import javax.crypto.Mac;

import org.json.JSONObject;
import android.util.Log;


/*
 * https://developer.android.com/reference/android/security/keystore/KeyGenParameterSpec
 */

public class CryptoService {
    private val TAG = "CryptoService"
    private var ANDROID_KEYSTORE = "AndroidKeyStore"

    public fun HmacSHA256Sign(keyName: String, toSign: String): JSONObject {
        val key = getOrCreateSecretKey(keyName)
        val sign = signDataByHMAC(key,toSign)

        var isInsideSecureHardware = false;
        val factory = SecretKeyFactory.getInstance(key!!.algorithm, ANDROID_KEYSTORE)
        try {
            val keyInfo: KeyInfo = factory.getKeySpec(key, KeyInfo::class.java) as KeyInfo
            isInsideSecureHardware = keyInfo.isInsideSecureHardware();
        } catch (e: Exception) {
        }

        val obj = JSONObject()
        obj.put("sign", sign)
        obj.put("keyName", keyName)
        obj.put("isInsideSecureHardware", isInsideSecureHardware)
        return obj
    }

    private fun signDataByHMAC(key: SecretKey, toSign: String): String {
        val mac: Mac = Mac.getInstance("HmacSHA256")
        mac.init(key)
        val signData: ByteArray = mac.doFinal(toSign.toByteArray())
        val sign: String = signData.joinToString("") {
            java.lang.String.format("%02x", it)
        }
        return sign.toUpperCase()
    }

    private fun getOrCreateSecretKey(keyName: String): SecretKey {
        val keyStore = KeyStore.getInstance(ANDROID_KEYSTORE)
        keyStore.load(null)
        keyStore.getKey(keyName, null)?.let {
            Log.v(TAG, "HMAC key loaded");
            return it as SecretKey
        }

        val keyGenerator: KeyGenerator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_HMAC_SHA256, ANDROID_KEYSTORE)
        keyGenerator.init(
            KeyGenParameterSpec.Builder(keyName, KeyProperties.PURPOSE_SIGN).build()
        )
        val key: SecretKey = keyGenerator.generateKey()
        val mac: Mac = Mac.getInstance("HmacSHA256")
        mac.init(key)

        Log.v(TAG, "HMAC key generated");
        return key
    }
}