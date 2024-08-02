import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auth_button_kit/auth_button_kit.dart';
import 'package:app_pass/actions/bottom_bar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:app_pass/services/database.dart';

class Masterpassword extends StatefulWidget {
  const Masterpassword({Key? key}) : super(key: key);

  @override
  State<Masterpassword> createState() => _MasterpasswordState();
}

class _MasterpasswordState extends State<Masterpassword> {
  final DatabaseService _db =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  String password = "";
  String master_password = "";
  String error = "";
  final _formkey = GlobalKey<FormState>();
  Method? brandSelected;

  void toggle(Method brand) async {
    setState(() => brandSelected = Method.custom);
    if (_formkey.currentState?.validate() ?? false) {
      dynamic result = await _db.setMasterPassword(password);
      if (result == null) {
        setState(() {
          error = 'Please check those details';
          brandSelected = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Biometrics have been automatically applied.')));
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
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 243, 220, 205),
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
                'Master Password',
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: 'Gammli',
                  color: Color.fromRGBO(248, 105, 17, 1),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "This password is used for authentication in cases where biometrics are not available. Please use something very unique and something you are not already using.",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    buildTextFormField(
                      labelText: 'Master Password',
                      prefixIcon: Icon(Ionicons.lock_closed_outline,
                          color: Color.fromRGBO(248, 105, 17, 1)),
                      obscureText: true,
                      validator: (val) => val!.length < 10
                          ? 'Enter a password 10+ chars long'
                          : null,
                      onChanged: (val) => setState(() => master_password = val),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    buildTextFormField(
                      labelText: 'Confirm Master Password',
                      prefixIcon: Icon(Ionicons.lock_closed,
                          color: Color.fromRGBO(248, 105, 17, 1)),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '$value is required';
                        }
                        if (value.length < 10) {
                          return "This must be 10 or more characters.";
                        }
                        if (value != master_password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
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
                text: 'SET',
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red, // Error border color
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent, // Focused error border color
          ),
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
