package redactedghost

import java.nio.file.{Files, Paths}
import javax.crypto.Cipher
import javax.crypto.spec.SecretKeySpec
import java.security.MessageDigest

object DiskCrypto {
  @native def init_disk_crypto(): Unit
  
  def encrypt_disk(path: String, key: String): Int = {
    val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
    val keySpec = new SecretKeySpec(MessageDigest.getInstance("SHA-256")
                                    .digest(key.getBytes), "AES")
    cipher.init(Cipher.ENCRYPT_MODE, keySpec)
    
    val data = Files.readAllBytes(Paths.get(path))
    val encrypted = cipher.doFinal(data)
    Files.write(Paths.get(path), encrypted)
    1
  }
  
  def decrypt_disk(path: String, key: String): Int = {
    val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
    val keySpec = new SecretKeySpec(MessageDigest.getInstance("SHA-256")
                                    .digest(key.getBytes), "AES")
    cipher.init(Cipher.DECRYPT_MODE, keySpec)
    
    val data = Files.readAllBytes(Paths.get(path))
    val decrypted = cipher.doFinal(data)
    Files.write(Paths.get(path), decrypted)
    1
  }
}
