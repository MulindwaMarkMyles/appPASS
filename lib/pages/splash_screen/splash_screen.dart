// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png', // Add your logo asset here
              height: 200,
            ),
            // SizedBox(height: 20),
            // Text(
            //   'One For All',
            //   style: TextStyle(
            //     fontSize: 40,
            //     fontWeight: FontWeight.bold,
            //     color: Color.fromARGB(255, 173, 54, 17),
            //   ),
            // ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 163, 44, 7)),
            ),
          ],
        ),
      ),
    );
  }
}
