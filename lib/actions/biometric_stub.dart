import 'package:app_pass/actions/biometric_mobile.dart';

Future<bool> isAuthenticated() async {
  bool authenticated = false;
  bool supports_biometric = await supportsBiometric();
  if (supports_biometric) {
    authenticated = await authenticate();
  } else {
    authen
  }
  return authenticated;
}
