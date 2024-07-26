// passkeys_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PasskeysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Passkeys',
          style: GoogleFonts.poppins(
            color: Color.fromARGB(255, 243, 134, 84),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      body: Center(
        child: Text('Content for Passkeys'),
      ),
    );
  }
}

