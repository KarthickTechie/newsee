/* 
@autor    : karthick.d  18/07/2025
@desc     : encapsualtes utility methods of AES encryption and decryption

 */
import 'package:encrypt/encrypt.dart' as encrypt;

String encryptString({required String inputText}) {
  final key = encrypt.Key.fromUtf8('sysarc@1234INFO@');
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.cbc),
  );
  final encrypted = encrypter.encrypt(inputText, iv: iv);
  final encString = encrypted.base64;
  print('AES encrypted base64 string..... => $encString');
  return encString;
}
