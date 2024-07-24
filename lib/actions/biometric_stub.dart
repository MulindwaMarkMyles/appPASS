import 'package:app_pass/actions/biometric_mobile.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<bool> isAuthenticated() async {
  bool authenticated = false;
  if (kIsWeb) {
    authenticated = true;
    return authenticated;
  } else {
    authenticated = await authenticate();
    return authenticated;
  }
}
