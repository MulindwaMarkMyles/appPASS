import 'package:flutter/material.dart';
import 'package:app_pass/actions/bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Text(
          'HOME',
          style: TextStyle(
             fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
            color: Color.fromARGB(255, 243, 134, 84),
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),),]
        ),
        backgroundColor: Color.fromRGBO(252, 231, 217, 1),
      ),
      body: Center(
        child: Text('Welcome to appPASS!'),
      ),
      bottomNavigationBar: BottomNavBar(index: 0),
    );
  }
}
