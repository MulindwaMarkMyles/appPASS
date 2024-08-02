import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:app_pass/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:app_pass/actions/biometric_stub.dart';
import 'package:app_pass/authentication/login_or_signup.dart';
import 'package:app_pass/actions/bottom_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';

class SplashScreen extends StatefulWidget {
  final String page;

  const SplashScreen({Key? key, required this.page}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool authenticated = false;

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _triggerHapticFeedback() {
    HapticFeedback.heavyImpact(); // Use heavy impact for significant feedback
  }

  void _triggerCustomVibration() async {
    if (await Vibration.hasAmplitudeControl() ?? false) {
      Vibration.vibrate(amplitude: 128);
    } else if (await Vibration.hasCustomVibrationsSupport() ?? false) {
      Vibration.vibrate(duration: 1000);
    } else {
      Vibration.vibrate();
      await Future.delayed(Duration(milliseconds: 500));
      Vibration.vibrate();
    }
  }

  void _triggerFeedback() {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      _triggerHapticFeedback(); // Use system haptic feedback on iOS
    } else {
      _triggerCustomVibration(); // Use custom vibration on Android
    }
  }

  void _showInputDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                8.0), // Adjust this value for more boxy or rounded corners
          ),
          title: Text('Master Password',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Enter your master password",
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(248, 105, 17, 1))),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(248, 105, 17, 1))),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(248, 105, 17, 1))),
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
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (value.length < 3) {
                      return 'Password must be at least 3 characters long';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Submit',
                  style: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 243, 134, 84),
                    fontSize: 16,
                  )),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final inputText = controller.text;
                  final DatabaseService _db = DatabaseService(
                      uid: FirebaseAuth.instance.currentUser!.uid);
                  authenticated = await _db.checkMasterPassword(inputText);
                  if (authenticated) {
                    setState(() {
                      // errorMessage = '';
                    });
                    Navigator.of(context).pop(); // Close the dialog
                    _navigateToNextScreen(); // Navigate after successful input
                  } else {
                    _triggerFeedback();
                  }
                }
              },
            ),
            TextButton(
              child: Text('Cancel',
                  style: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 243, 134, 84),
                    fontSize: 16,
                  )),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                8.0), // Adjust this value for more boxy or rounded corners
          ),
          title: Text('Authentication',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          content: Text('Biometrics or Master Password',
              style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              child: Text('Biometrics',
                  style: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 243, 134, 84),
                    fontSize: 16,
                  )),
              onPressed: () async {
                bool is_Authenticated = await isAuthenticated();
                setState(() {
                  authenticated = is_Authenticated;
                });
                if (authenticated) {
                  Navigator.of(context).pop(); // Close the dialog
                  _navigateToNextScreen(); // Navigate after successful authentication
                }
              },
            ),
            TextButton(
              child: Text('Master Password',
                  style: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 243, 134, 84),
                    fontSize: 16,
                  )),
              onPressed: () {
                _showInputDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToNextScreen() {
    Timer(Duration(seconds: 3), () {
      if (widget.page == 'login') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginOrSignup()),
        );
      } else {
        if (!authenticated) {
          if (kIsWeb) {
            _showInputDialog(context);
          } else {
            _showDialog(context);
          }
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => BottomNavBar()),
          );
        }
      }
    });
  }

  void _exitApp() {
    SystemNavigator.pop();
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
            SizedBox(height: 100),
            SizedBox(
              width: 200, // Set the desired width here
              child: LoadingAnimationWidget.inkDrop(
                  color: Color.fromRGBO(248, 105, 17, 1), size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
