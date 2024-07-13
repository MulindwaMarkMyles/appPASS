import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_pass/services/auth.dart';
import 'package:auth_button_kit/auth_button_kit.dart';
import 'package:app_pass/actions/bottom_bar.dart';
import 'package:ionicons/ionicons.dart';

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
  Method? brandSelected;

  void toggle(Method brand) async {
    setState(() => brandSelected = Method.custom);
    if (_formkey.currentState?.validate() ?? false) {
      dynamic result = await _auth.signIn(email, password);
      if (result == null) {
        setState(() {
          error = 'Please check those details';
          brandSelected = null;
        });
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => BottomNavBar()));
      }
    } else {
      setState(() {
        brandSelected = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 243, 220, 205),
        leading: IconButton(
          icon: Icon(Ionicons.arrow_back_circle),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/Image1.png'),
              SizedBox(height: 20),
              Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: 'Gammli',
                  color: Color.fromRGBO(248, 105, 17, 1),
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    buildTextFormField(
                      labelText: 'Username or Email',
                      prefixIcon: Icon(Ionicons.person_outline,
                          color: Color.fromRGBO(248, 105, 17, 1)),
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) => setState(() => email = val),
                    ),
                    SizedBox(height: 20),
                    buildTextFormField(
                      labelText: 'Password',
                      prefixIcon: Icon(Ionicons.lock_closed_outline,
                          color: Color.fromRGBO(248, 105, 17, 1)),
                      obscureText: true,
                      validator: (val) => val!.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      onChanged: (val) => setState(() => password = val),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
              SizedBox(height: 14),
              AuthButton(
                onPressed: (b) => toggle(b),
                brand: Method.custom,
                text: 'LOGIN',
                textCentering: Centering.independent,
                textColor: Colors.white,
                backgroundColor: Color.fromRGBO(248, 105, 17, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.transparent
                        : Color.fromRGBO(248, 105, 17, 1),
                    width: 1.5,
                  ),
                ),
                fontFamily: GoogleFonts.poppins().fontFamily,
                showLoader: Method.custom == brandSelected,
                loaderColor: Colors.white,
                splashEffect: true,
                customImage: Image.asset('assets/Image1.png'),
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 12),
              ),
              SizedBox(height: 20),
              Text(
                'Forgot Password?',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: Color.fromRGBO(248, 105, 17, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required String labelText,
    required Icon prefixIcon,
    bool obscureText = false,
    required String? Function(String?) validator,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        labelStyle: TextStyle(
          color: Colors.black,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(248, 105, 17, 1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(248, 105, 17, 1)),
        ),
      ),
      style: TextStyle(
        color: Colors.black,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
