import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:app_pass/services/database.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:app_pass/actions/biometric_stub.dart';
import 'package:password_strength/password_strength.dart';

class PasswordDetailsPage extends StatefulWidget {
  final Map<String, dynamic> passwordData;
  final String passwordId;

  const PasswordDetailsPage({
    Key? key,
    required this.passwordData,
    required this.passwordId,
  }) : super(key: key);

  @override
  PasswordDetailsPageState createState() => PasswordDetailsPageState();
}

class PasswordDetailsPageState extends State<PasswordDetailsPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final DatabaseService _db =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _notesController;
  bool _obscurePassword = true;
  bool authenticated = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.passwordData['name']);
    _usernameController =
        TextEditingController(text: widget.passwordData['username']);
    _passwordController =
        TextEditingController(text: widget.passwordData['password']);
    _emailController =
        TextEditingController(text: widget.passwordData['email']);
    _websiteController =
        TextEditingController(text: widget.passwordData['url']);
    _notesController =
        TextEditingController(text: widget.passwordData['notes']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_obscurePassword) {
        String encryptedPassword =
            await _db.encryptPassword(_passwordController.text);
        setState(() {
          _passwordController.text = encryptedPassword;
        });
      }
      final updatedData = {
        'name': _nameController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'email': _emailController.text,
        'url': _websiteController.text,
        'notes': _notesController.text,
        'category': widget.passwordData['category'],
      };

      try {
        final CollectionReference users =
            FirebaseFirestore.instance.collection('users');
        await users
            .doc(uid)
            .collection('passwords')
            .doc(widget.passwordId)
            .update(updatedData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update password. Please try again.')),
        );
        print('Error updating password: $e');
      }
    }
  }

  Future<Color> getPasswordStrengthColor(String password) async {
    String decyptedPass;
    if (_obscurePassword) {
      decyptedPass = await _db.decryptPassword(password);
    } else {
      decyptedPass = password;
    }
    double strength = estimatePasswordStrength(decyptedPass);

    if (strength < 0.3) {
      return Colors.red; // Weak password
    } else if (strength < 0.7) {
      return Colors.orange; // Medium password
    } else {
      return Colors.green; // Strong password
    }
  }

  Future<void> _togglePasswordVisibility() async {
    try {
      if (_obscurePassword) {
        // if (kIsWeb) {
        //   authenticated = true;
        // } else {
        //   authenticated = await isAuthenticated();
        // }
        // if (authenticated) {
        String decryptedPassword =
            await _db.decryptPassword(_passwordController.text);
        setState(() {
          _passwordController.text = decryptedPassword;
        });
        // } else {
        //   _obscurePassword = !_obscurePassword;
        //   ScaffoldMessenger.of(context)
        //       .showSnackBar(SnackBar(content: Text("Authentication Failed.")));
        // }
      } else {
        String encryptedPassword =
            await _db.encryptPassword(_passwordController.text);
        setState(() {
          _passwordController.text = encryptedPassword;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to process password. Please try again.')),
      );
      print('Error processing password: $e');
    }

    setState(() {
      _obscurePassword = !_obscurePassword;
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
              'Password Details',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextFormField(
                labelText: 'Url',
                prefixIcon: Icon(Ionicons.logo_web_component,
                    color: Color.fromRGBO(248, 105, 17, 1)),
                controller: _websiteController,
              ),
              SizedBox(height: 20),
              buildTextFormField(
                controller: _usernameController,
                labelText: "Username",
                prefixIcon: Icon(Ionicons.person_outline,
                    color: Color.fromRGBO(248, 105, 17, 1)),
              ),
              SizedBox(height: 20),
              buildTextFormField(
                controller: _nameController,
                labelText: 'Name',
                prefixIcon: Icon(Ionicons.person_circle,
                    color: Color.fromRGBO(248, 105, 17, 1)),
              ),
              SizedBox(height: 20),
              FutureBuilder<Color>(
                future: getPasswordStrengthColor(_passwordController.text),
                builder: (context, snapshot) {
                  Color color = snapshot.data ?? Colors.black; // Default color
                  if (snapshot.hasError) {
                    color = Colors.black; // Handle errors by defaulting to grey
                  }
                  return buildPasswordFormField(
                    controller: _passwordController,
                    labelText: 'Password',
                    prefixIcon: Icon(Ionicons.lock_closed_outline,
                        color: Color.fromRGBO(248, 105, 17, 1)),
                    color: color,
                  );
                },
              ),
              SizedBox(height: 20),
              buildTextFormField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icon(Ionicons.mail_unread_outline,
                    color: Color.fromRGBO(248, 105, 17, 1)),
              ),
              SizedBox(height: 20),
              buildTextFormField(
                controller: _notesController,
                labelText: 'Notes',
                prefixIcon: Icon(Ionicons.text_outline,
                    color: Color.fromRGBO(248, 105, 17, 1)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePassword,
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
                child: Center(
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 17,
                    ),
                  ),
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
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
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
      style: TextStyle(
        color: Colors.black,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }

  Widget buildPasswordFormField({
    required String labelText,
    required Icon prefixIcon,
    required TextEditingController controller,
    required Color color,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Ionicons.eye_off_outline : Ionicons.eye_outline,
          ),
          onPressed: _togglePasswordVisibility,
        ),
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
      style: TextStyle(
        color: color,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
    );
  }
}
