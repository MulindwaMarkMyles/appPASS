import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'SHARE',
                style: TextStyle(
                  fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                  color: Color.fromARGB(255, 243, 134, 84),
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          backgroundColor: Color.fromRGBO(246, 208, 183, 1),
        ),
        Expanded(
          child: Center(
            child: Text('Share Screen'),
          ),
        ),
      ],
    );
  }
}
