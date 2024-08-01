import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:app_pass/actions/biometric_stub.dart';
import 'package:app_pass/authentication/login_or_signup.dart';
import 'package:app_pass/actions/bottom_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  final String page;

  const SplashScreen({Key? key, required this.page}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplashScreen();
  }

  void _startSplashScreen() {
    // Display the splash screen for 3 seconds before checking biometric support
    Timer(Duration(seconds: 3), () async {
      bool authenticated;
      if (kIsWeb) {
        authenticated = true;
      } else {
        authenticated = await isAuthenticated();
      }

      if (authenticated) {
        _navigateToNextScreen();
      } else {
        _exitApp();
      }
    });

    // Ensure the splash screen is shown for a total of 5 seconds
    Timer(Duration(seconds: 7), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // If possible, pop the splash screen to avoid blocking the stack
      }
      // Proceed with navigation or exiting based on authentication status
    });
  }

  void _navigateToNextScreen() {
    Timer(Duration(seconds: 3), () {
      if (widget.page == 'login') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginOrSignup()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => BottomNavBar()),
        );
      }
    });
  }

  void _exitApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 185, 145, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_square.png', // Add your logo asset here
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'appPASS',
              style: TextStyle(
                fontSize: 40,
                fontFamily: 'Gammli',
                color: Color.fromRGBO(248, 105, 17, 1),
              ),
            ),
            SizedBox(height: 100),
            SizedBox(
              width: 200, // Set the desired width here
              child: LoadingAnimationWidget.inkDrop(
                  color: Color.fromRGBO(248, 105, 17, 1), size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
