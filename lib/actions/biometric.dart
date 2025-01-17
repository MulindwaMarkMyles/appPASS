import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

Future<bool> supportsBiometric() async {
  LocalAuthentication auth = LocalAuthentication();
  _SupportState supportState = _SupportState.unknown;
  bool isSupported = await auth.isDeviceSupported();
  supportState =
      isSupported ? _SupportState.supported : _SupportState.unsupported;

  print('supportsBiometric: $supportState'); // Debug log

  return supportState == _SupportState.supported;
}

Future<bool> checkBiometrics() async {
  LocalAuthentication auth = LocalAuthentication();
  bool canCheckBiometrics = false;
  try {
    canCheckBiometrics = await auth.canCheckBiometrics;
  } on PlatformException catch (e) {
    print('checkBiometrics error: $e'); // Debug log
  }
  print('checkBiometrics: $canCheckBiometrics'); // Debug log
  return canCheckBiometrics;
}

Future<List<BiometricType>> getAvailableBiometrics() async {
  LocalAuthentication auth = LocalAuthentication();
  List<BiometricType> availableBiometrics = <BiometricType>[];
  try {
    availableBiometrics = await auth.getAvailableBiometrics();
  } on PlatformException catch (e) {
    print('getAvailableBiometrics error: $e'); // Debug log
  }
  print('availableBiometrics: $availableBiometrics'); // Debug log
  return availableBiometrics;
}

Future<bool> authenticate() async {
  LocalAuthentication auth = LocalAuthentication();
  bool authenticated = false;
  try {
    authenticated = await auth.authenticate(
      localizedReason: 'Please Authenticate to continue.',
      options: const AuthenticationOptions(
        stickyAuth: true,
      ),
    );
  } on PlatformException catch (e) {
    print('authenticate error: $e'); // Debug log
  }
  print('authenticated: $authenticated'); // Debug log
  return authenticated;
}

Future<void> authenticateWithBiometrics() async {
  LocalAuthentication auth = LocalAuthentication();
  bool authenticated = false;
  try {
    authenticated = await auth.authenticate(
      localizedReason:
          'Scan your fingerprint (or face or whatever) to authenticate',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
  } on PlatformException catch (e) {
    print('authenticateWithBiometrics error: $e'); // Debug log
  }
  print('authenticatedWithBiometrics: $authenticated'); // Debug log
}

Future<void> cancelAuthentication() async {
  LocalAuthentication auth = LocalAuthentication();
  await auth.stopAuthentication();
  print('cancelAuthentication'); // Debug log
}
