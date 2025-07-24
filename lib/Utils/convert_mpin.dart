import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;

class MPINEncryptResponse {
  final bool success;

  final String? encryptedText;

  MPINEncryptResponse(this.success, this.encryptedText);
}

MPINEncryptResponse encryptMPIN(String plaintext, String passphrase) {
  try {
    // Ensure key is 16 bytes (AES-128)

    final keyBytes = utf8.encode(passphrase);

    final key = encrypt.Key(
      Uint8List.fromList(
        keyBytes.length >= 16 ? keyBytes.sublist(0, 16) : List.filled(16, 0),
      ),
    );

    // IV of 16 zero bytes

    final iv = encrypt.IV(Uint8List(16));

    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
    );

    final encrypted = encrypter.encrypt(plaintext, iv: iv);

    return MPINEncryptResponse(true, encrypted.base64);
  } catch (e) {
    print(e);

    return MPINEncryptResponse(false, null);
  }
}
