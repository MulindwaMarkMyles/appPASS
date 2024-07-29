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
