// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildPage extends StatefulWidget {
  @override
  _BuildPageState createState() => _BuildPageState();
}

class _BuildPageState extends State<BuildPage> {
  String generatedPassword = 'n*83@4jkL';
  double passwordLength = 8.0;
  bool includeUppercase = false;
  bool includeLowercase = false;
  bool includeNumbers = false;
  bool includeSpecialChars = false;

  void generatePassword() {
    // Logic to generate the password based on the selected options
    // This is just a placeholder for the actual password generation logic
    setState(() {
      generatedPassword = 'NewPass@123';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/Image1.png',
              width: 40, // Adjust size as needed
              height: 40, // Adjust size as needed
            ),
            SizedBox(width: 10), // Adjust spacing between logo and title
            Text(
              'Passcode Generator',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PASSWORD GENERATOR',
              style: TextStyle(
                fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                color: Color.fromARGB(255, 243, 134, 84),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Generate strong secure passwords to keep your account safe online',
              style: TextStyle(
                fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                color: Colors.black,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    generatedPassword,
                    style: TextStyle(
                      fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    // Logic to copy the password to clipboard
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Password length:'),
                Expanded(
                  child: Slider(
                    value: passwordLength,
                    min: 4,
                    max: 20,
                    divisions: 16,
                    onChanged: (value) {
                      setState(() {
                        passwordLength = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Uppercase'),
                    Checkbox(
                      value: includeUppercase,
                      onChanged: (value) {
                        setState(() {
                          includeUppercase = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Lowercase'),
                    Checkbox(
                      value: includeLowercase,
                      onChanged: (value) {
                        setState(() {
                          includeLowercase = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Numbers'),
                    Checkbox(
                      value: includeNumbers,
                      onChanged: (value) {
                        setState(() {
                          includeNumbers = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Special Characters'),
                    Checkbox(
                      value: includeSpecialChars,
                      onChanged: (value) {
                        setState(() {
                          includeSpecialChars = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: generatePassword,
                child: Text('Generate',
                style: TextStyle(
                  color: Colors.white
                ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 243, 134, 84),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
