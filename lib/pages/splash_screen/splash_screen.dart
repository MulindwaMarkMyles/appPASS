// ignore_for_file: prefer_const_constructors

import 'package:app_pass/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 183, 145),
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
              'appPASS', // Add your app name here
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 163, 44, 7),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 200, // Set the desired width here
              child: LinearProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 163, 44, 7)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Screen'),
      ),
      body: Center(
        child: Text('Welcome to the Next Screen!'),
      ),
    );
  }
}
