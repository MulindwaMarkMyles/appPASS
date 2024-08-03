import 'package:app_pass/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_pass/services/auth.dart';
import 'package:ionicons/ionicons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_otp/email_otp.dart';

class MasterPasswordResetScreen extends StatefulWidget {
  const MasterPasswordResetScreen({Key? key}) : super(key: key);

  @override
  _MasterPasswordResetScreenState createState() =>
      _MasterPasswordResetScreenState();
}

class _MasterPasswordResetScreenState extends State<MasterPasswordResetScreen> {
  final DatabaseService _db =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final AuthService _auth = AuthService();
  dynamic otp;
  bool correct = false;
  bool sentEmail = false;
  String buttonText = 'Request OTP';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Ionicons.arrow_back_circle),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/Image1.png',
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'Reset Password',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 243, 134, 84),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(244, 203, 176, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //
              Text(
                "\nYou will be sent an email containing an OTP to help you reset your master password.",
                style: GoogleFonts.poppins(fontSize: 20),
              ),
              SizedBox(height: 20),
              if (sentEmail) buildOTPField(),
              if (correct) ...[
                SizedBox(height: 20),
                buildPasswordField(),
                SizedBox(height: 20),
                buildPasswordConfirmField(),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (!sentEmail) {
                      // Send OTP
                      User? user = FirebaseAuth.instance.currentUser;
                      CustomUser custom_User =
                          _auth.userFromFirebaseUser(user)!;
                      String user_email = custom_User.getEmail();

                      otp = OTPType.alphaNumeric;
                      EmailOTP.config(
                        appName: 'APPPASS',
                        otpType: otp,
                        emailTheme: EmailTheme.v4,
                      );
                      if (await EmailOTP.sendOTP(email: user_email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("OTP has been sent")));
                        setState(() {
                          sentEmail = true;
                          buttonText = 'Check OTP';
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("OTP failed to send")));
                      }
                    } else if (!correct) {
                      // Check OTP
                      if (EmailOTP.verifyOTP(otp: _otpController.text)) {
                        setState(() {
                          correct = true;
                          buttonText = "Change Password";
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("OTP is not correct.")));
                      }
                    } else {
                      // Change Password Logic
                      if (_passwordController.text ==
                          _passwordConfirmController.text) {
                        // Proceed to change the password in the database
                        await _db.setMasterPassword(_passwordController.text);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("Password changed successfully.")));
                        Navigator.of(context).pop();
                      }
                    }
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
                  buttonText,
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

  Widget buildOTPField() {
    return TextFormField(
      controller: _otpController,
      decoration: InputDecoration(
        labelText: "The OTP",
        prefixIcon: Icon(Ionicons.code_download_outline,
            color: Color.fromRGBO(248, 105, 17, 1)),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the OTP.';
        }
        return null;
      },
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: "The New Password",
        prefixIcon: Icon(Ionicons.lock_closed_outline,
            color: Color.fromRGBO(248, 105, 17, 1)),
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
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the new password.';
        }
        return null;
      },
    );
  }

  Widget buildPasswordConfirmField() {
    return TextFormField(
      controller: _passwordConfirmController,
      decoration: InputDecoration(
        labelText: "Confirm the New Password",
        prefixIcon: Icon(Ionicons.lock_closed_outline,
            color: Color.fromRGBO(248, 105, 17, 1)),
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
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm the new password.';
        } else if (_passwordController.text !=
            _passwordConfirmController.text) {
          return 'Passwords do not match.';
        }
        return null;
      },
    );
  }
}
