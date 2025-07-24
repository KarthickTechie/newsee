import 'package:encrypt/encrypt.dart' as encrypt;

// Class to mirror Java's MPINEncryptResponse
class MPINEncryptResponse {
  final bool success;
  final String? cipherText;

  MPINEncryptResponse(this.success, this.cipherText);
}

MPINEncryptResponse encryptMobileMPIN(String plaintext, String passphrase) {
  try {
    // Convert passphrase to a 16-byte key for AES-128
    final key = encrypt.Key.fromUtf8(
      passphrase.padRight(16, '\0').substring(0, 16),
    );

    // Use a 16-byte zeroed IV to match Java's new byte[16]
    final iv = encrypt.IV.fromLength(16);

    // Initialize AES encrypter in CBC mode (PKCS7 padding is default in encrypt package)
    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );

    // Encrypt the plaintext
    final encrypted = encrypter.encrypt(plaintext, iv: iv);

    // Return Base64-encoded ciphertext
    return MPINEncryptResponse(true, encrypted.base64);
  } catch (e) {
    print('Encryption error: $e');
    return MPINEncryptResponse(false, null);
  }
}
