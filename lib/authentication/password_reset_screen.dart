import 'package:flutter/material.dart';
import 'package:app_pass/services/auth.dart';
import 'package:ionicons/ionicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_pass/authentication/profile.dart'; // Import the profile screen

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
        backgroundColor: Color.fromARGB(255, 243, 220, 205),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Ionicons.mail_outline,
                      color: Color.fromRGBO(248, 105, 17, 1)),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(248, 105, 17, 1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(248, 105, 17, 1)),
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _auth.resetPassword(_emailController.text);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Color.fromRGBO(248, 105, 17, 1), // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.transparent
                          : Color.fromRGBO(248, 105, 17, 1),
                      width: 1.5,
                    ),
                  ),
                  textStyle: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
