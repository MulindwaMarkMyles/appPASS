import 'package:app_pass/actions/biometric_mobile.dart';

Future<bool> isAuthenticated() async {
  bool authenticated = false;
  bool supportsBiometric = await supportsBiometric();
  authenticated = await authenticate();
  return authenticated;
}
