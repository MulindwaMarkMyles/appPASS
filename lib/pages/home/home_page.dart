import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppBar(
          title: Row(
            children: [
              Image.asset(
                'assets/Image1.png',
                width: 40, // Adjust size as needed
                height: 40, // Adjust size as needed
              ),
              SizedBox(width: 10), // Adjust spacing between logo and title
              Text(
                'Home',
                style: TextStyle(
                  fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                  color: Color.fromARGB(255, 243, 134, 84),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          backgroundColor: Color.fromRGBO(246, 208, 183, 1),
        ),
        SizedBox(height: 20),
        SizedBox(
          width:350,
          child: ElevatedButton.icon(
            onPressed: (){}, 
            icon: Icon(Ionicons.cloud_upload_outline, color: Color.fromRGBO(248, 105, 17, 1)),
            style: ElevatedButton.styleFrom(
            
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side:BorderSide(color: Color.fromRGBO(248, 105, 17, 1), width: 1),
              ),
              backgroundColor: Colors.white,
            ),
            label: Text(
              "Import",
              style: TextStyle(
                fontSize: 20,
                fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(248, 105, 17, 1),
              ),
            ),),
        ),
        SizedBox(
          width: 350,
          child: ElevatedButton.icon(
            onPressed: (){}, 
            icon: Icon(Ionicons.add_outline, color: Color.fromRGBO(248, 105, 17, 1)),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side:BorderSide(color: Color.fromRGBO(248, 105, 17, 1), width: 1),
              ),
              backgroundColor: Colors.white,
            ),
            label: Text(
              "Add",
              style: TextStyle(
                fontSize: 20,
                fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(248, 105, 17, 1),
              ),
            ),),
        )
      ],
    );
  }
}
