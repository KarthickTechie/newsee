import 'package:biometric_signature/android_config.dart';
import 'package:biometric_signature/biometric_signature.dart';
import 'package:biometric_signature/ios_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:local_auth_android/local_auth_android.dart';

class BioMetricLogin {
  final _biometricSignature = BiometricSignature();

  Future<BioMetricResult> biometricAuthentication() async {
    try {
      if (kIsWeb) {
        return BioMetricResult(
          message: "BioMetric Login not Available in web",
          status: false,
        );
      }

      final LocalAuthentication localauth = LocalAuthentication();
      final getfingerprintdata = await localauth.canCheckBiometrics;
      if (!getfingerprintdata) {
        return BioMetricResult(
          message: "Local authentication not available in this device",
          status: false,
        );
      }

      final List<BiometricType> availableBiometrics =
          await localauth.getAvailableBiometrics();
      print("availableBiometrics: $availableBiometrics");

      if (availableBiometrics.isEmpty) {
        return BioMetricResult(
          message: "BioMetric not added on this device",
          status: false,
        );
        ;
      }

      final bool didAuthenticate = await localauth.authenticate(
        localizedReason: 'Login',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(signInTitle: "Login with BioMetric"),
        ],
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (didAuthenticate) {
        return BioMetricResult(message: "Success", status: true);
      }

      return BioMetricResult(message: "BioMetric Failure", status: false);
    } on PlatformException catch (error) {
      print("PlatformException-biometricAuthentication: ${error.message}");
      return BioMetricResult(
        message: (error.message).toString(),
        status: false,
      );
    }
  }

  Future<BioMetricResult> biometricAuthenticationWithKey() async {
    try {
      final String? biometricsType =
          await _biometricSignature.biometricAuthAvailable();
      debugPrint("biometricsType : $biometricsType");
      // if (condition) {
      // final bool? result = await _biometricSignature.deleteKeys();
      // }
      final bool doExist =
          await _biometricSignature.biometricKeyExists(checkValidity: true) ??
          false;
      debugPrint("doExist : $doExist");
      if (!doExist) {
        final String? publicKey = await _biometricSignature.createKeys(
          androidConfig: AndroidConfig(useDeviceCredentials: true),
        );
        debugPrint("publicKey : $publicKey");
      }
      final String? signature = await _biometricSignature.createSignature(
        options: {
          "payload": "Biometric payload",
          "promptMessage": "Login with BioMetric",
          "shouldMigrate": "true",
          "allowDeviceCredentials": "false",
        },
      );
      debugPrint("signature : $signature");
      return BioMetricResult(message: signature!, status: true);
    } on PlatformException catch (e) {
      return BioMetricResult(message: e.message!, status: false);
    }
  }
}
