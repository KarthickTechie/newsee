import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:local_auth_android/local_auth_android.dart';

class BioMetricLogin {
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

      if (availableBiometrics == []) {
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
}
