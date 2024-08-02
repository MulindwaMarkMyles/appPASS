import 'package:app_pass/actions/biometric_stub.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:vibration/vibration.dart';
import 'PasswordDetailsPage.dart';
import 'package:app_pass/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);

  @override
  SecurityState createState() => SecurityState();
}

class SecurityState extends State<Security> {
  Map<String, dynamic> password_Data = {};
  String password_Id = '';
  final DatabaseService _db =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  late Future<List<Map<String, dynamic>>> _passwordsFuture;

  @override
  void initState() {
    super.initState();
    _passwordsFuture = _db.fetchPasswords('Security');
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
                  bool authenticated = await _db.checkMasterPassword(inputText);
                  if (authenticated) {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasswordDetailsPage(
                          passwordData:
                              password_Data, // This should be a map containing the password details
                          passwordId:
                              password_Id, // This should be the document ID of the password
                        ),
                      ),
                    );
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
                if (is_Authenticated) {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordDetailsPage(
                        passwordData:
                            password_Data, // This should be a map containing the password details
                        passwordId:
                            password_Id, // This should be the document ID of the password
                      ),
                    ),
                  ); // Close the dialog
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
                Navigator.of(context).pop();
                _showInputDialog(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _refreshPasswords() async {
    setState(() {
      _passwordsFuture = _db.fetchPasswords('Security');
    });
  }

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
              'Security Passwords',
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
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      body: LiquidPullToRefresh(
        showChildOpacityTransition: false,
        springAnimationDurationInMilliseconds: 350,
        backgroundColor: Color.fromARGB(255, 243, 134, 84),
        color: Color.fromRGBO(246, 208, 183, 1),
        onRefresh: _refreshPasswords,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _passwordsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: LoadingAnimationWidget.threeRotatingDots(
                      color: Color.fromARGB(255, 243, 134, 84), size: 50));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child:
                      Text('No passwords found.', style: GoogleFonts.poppins()));
            }
        
            final passwords = snapshot.data!;
            return ListView.builder(
              itemCount: passwords.length,
              itemBuilder: (context, index) {
                final password = passwords[index];
                final passwordId = password['id']; // Get the document ID
                return Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(250, 230, 216, 1), // Add margin here
                    border: Border.all(
                        color: Color.fromARGB(139, 0, 0, 0), width: 1.2),
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey
                            .withOpacity(0.3), // Shadow color with opacity
                        spreadRadius: 2, // Spread radius
                        blurRadius: 5, // Blur radius
                        offset: Offset(0, 3), // Offset in the x and y direction
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      password['url'] ?? 'url',
                      style: GoogleFonts.poppins(
                        color: Color.fromARGB(255, 243, 134, 84),
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    subtitle: Text(
                      password['password'] != null
                          ? '.' * (password['password'].length ~/ 4)
                          : '',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Ionicons.key_outline),
                          onPressed: () {
                            _showDialog(context);
                            setState(() {
                              password_Data = password;
                              password_Id = passwordId;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Ionicons.trash_outline),
                          onPressed: () async {
                            // Confirm deletion
                            final shouldDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Adjust this value for more boxy or rounded corners
                                  ),
                                  backgroundColor: Color.fromRGBO(244, 220, 205, 1),
                                  title: Text('Delete Password',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500)),
                                  content: Text(
                                      'Are you sure you want to delete this password?',
                                      style: GoogleFonts.poppins()),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: Text('Cancel',
                                          style: GoogleFonts.poppins(
                                            color:
                                                Color.fromARGB(255, 243, 134, 84),
                                            fontSize: 16,
                                          )),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text('Delete',
                                          style: GoogleFonts.poppins(
                                            color:
                                                Color.fromARGB(255, 243, 134, 84),
                                            fontSize: 16,
                                          )),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (shouldDelete ?? false) {
                              // Move the password to the deleted category
                              await _db.movePasswordToDeleted(passwordId);
                              // Refresh the list
                              _refreshPasswords();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
