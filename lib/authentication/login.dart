import 'package:flutter/material.dart';
import 'package:app_pass/actions/bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';
class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/Image1.png'),
            SizedBox(
              height: 20,
            ),
            Text(
              'Sign In',
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'Gammli',
                color: Color.fromRGBO(248, 105, 17, 1),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Username or Email',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => BottomNavBar()));
              },
              child: Text(
                'Login',
              style: TextStyle(
                fontSize: 20,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white,
              ),),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 44, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color.fromRGBO(248, 140, 73, 1),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(248, 105, 17, 1),
              ),
            ),
            Text(
              'Create an account',
              style: TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(248, 105, 17, 1),
              ),
            )
          ],
        ),
      ),
    );
  }
}
