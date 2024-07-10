import 'package:flutter/material.dart';
import 'package:app_pass/actions/bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_pass/services/auth.dart';

class Login extends StatefulWidget {
  
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  String email = "";
  String password = "";
  String error = "";
  final _formkey = GlobalKey<FormState>();

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
            Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
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
                    validator: (val) =>
                        val!.isEmpty ? 'Enter an email' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    },
                  ),
                  TextFormField(
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
                    validator: (val) =>
                        val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              error,
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formkey.currentState!.validate()) {
                  // setState(() => loading = true);
                  dynamic result = await _auth.signIn(email, password);
                  if (result == null) {
                    setState(() {
                      error = 'Please check those details';
                      // loading = false;
                    });
                  } else {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => BottomNavBar()));
                  }
                }
              },
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Colors.white,
                ),
              ),
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
