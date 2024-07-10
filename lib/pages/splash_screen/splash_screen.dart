import 'package:flutter/material.dart';
import 'dart:async';
import 'package:app_pass/authentication/login_or_signup.dart';
import 'package:app_pass/actions/bottom_bar.dart';

class SplashScreen extends StatefulWidget {
  final String page;
  SplashScreen({required this.page});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      if (widget.page == 'login'){
         Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => LoginOrSignup()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => BottomNavBar()));
      }
    });
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
            SizedBox(height: 20),
            SizedBox(
              width: 200, // Set the desired width here
              child: LinearProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(247, 105, 17, 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
