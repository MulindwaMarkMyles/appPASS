// ignore_for_file: sort_child_properties_last

import 'package:app_pass/authentication/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:app_pass/actions/bottom_bar.dart';
import 'package:app_pass/authentication/login.dart';

class LoginAndSignup extends StatefulWidget {
  const LoginAndSignup({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginAndSignup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 185, 145, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Ionicons.lock_closed_outline,
              size: 100,
              color: Colors.black,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to appPASS',
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Gammli',
                color: Color.fromRGBO(248, 105, 17, 1),
              ),
            ),
            SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => Login()));
              }, 
              child: Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color.fromRGBO(248, 105, 17, 1),
              ),),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => SignUpPage()));
              }, 
              child: Text(
                "SIGN UP",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(248, 105, 17, 1),
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 44, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Color.fromRGBO(248, 105, 17, 1),
                    width: 2,
                  ),
                ),
                backgroundColor: Color.fromRGBO(250, 249, 248, 1),
                
              ),),
            SizedBox(height: 200),
            Text(
              'Get to know us!',
              style: TextStyle(
                fontSize: 20,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Color.fromRGBO(248, 105, 17, 1),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Ionicons.logo_facebook, size: 30, color: Color.fromRGBO(248, 105, 17, 1)),
                SizedBox(width: 20),
                Icon(Ionicons.logo_instagram, size: 30, color: Color.fromRGBO(248, 105, 17, 1)),
                SizedBox(width: 20),
                Icon(Ionicons.logo_twitter, size: 30, color: Color.fromRGBO(248, 105, 17, 1)),
                SizedBox(width: 20),
                Icon(Ionicons.logo_linkedin, size: 30, color: Color.fromRGBO(248, 105, 17, 1)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

