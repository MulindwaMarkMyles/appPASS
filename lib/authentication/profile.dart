import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:app_pass/services/auth.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  final User? user = FirebaseAuth.instance.currentUser;

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
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Image1.png', // Adjust the path to your logo
                  width: 80,
                  height: 80,
                ),
                SizedBox(height: 16),
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'Gammli',
                    color: Color.fromRGBO(248, 105, 17, 1),
                  ),
                ),
                SizedBox(height: 16),
                _buildProfileInfo('Name', user?.displayName ?? 'N/A'),
                SizedBox(height: 8),
                _buildProfileInfo('Email', user?.email ?? 'N/A'),
                SizedBox(height: 8),
                _buildProfileInfo('Username', user?.email?.split('@')[0] ?? 'N/A'), // Assuming username is part of email
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return ListTile(
      leading: Icon(Ionicons.person_outline, color: Color.fromRGBO(248, 105, 17, 1)),
      title: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: Colors.grey,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
      ),
    );
  }
}
