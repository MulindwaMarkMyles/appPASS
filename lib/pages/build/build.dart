import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class BuildPage extends StatefulWidget {
  const BuildPage({Key? key}) : super(key: key);

  @override
  BuildPageState createState() => BuildPageState();
}

class BuildPageState extends State<BuildPage> {
  String generatedPassword = '';
  double passwordLength = 8.0;
  bool includeUppercase = false;
  bool includeLowercase = false;
  bool includeNumbers = false;
  bool includeSpecialChars = false;

  void generatePassword() {
    // Logic to generate the password based on the selected options
    const uppercaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = "0123456789";
    const specialChars = '!@#\$%^&*(),.?":{}|<>';

    String chars = '';

    if (includeUppercase) chars += uppercaseLetters;
    if (includeLowercase) chars += lowercaseLetters;
    if (includeNumbers) chars += numbers;
    if (includeSpecialChars) chars += specialChars;

    if (chars.isEmpty) {
      setState(() {
        generatedPassword = 'Select options!';
      });
      return;
    }

    final rand = Random();
    final password = List.generate(passwordLength.toInt(),
        (index) => chars[rand.nextInt(chars.length)]).join();

    setState(() {
      generatedPassword = password;
    });

    // Save the generated password to Firestore
    _savePasswordToFirestore(password);
  }

  void _savePasswordToFirestore(String password) {
    final firestore = FirebaseFirestore.instance;
    firestore.collection('passwords').add({
      'password': password,
      'created_at': Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        child: ListView(
          children: [
            SizedBox(height: 20),
            Text(
              'Generate strong secure passwords to keep your account safe online',
              style: TextStyle(
                fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                color: Colors.black,
                fontSize: 15,
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
                    Clipboard.setData(ClipboardData(text: generatedPassword));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password copied to clipboard')),
                    );
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
                    thumbColor: Color.fromARGB(255, 243, 134, 84),
                    activeColor: Color.fromARGB(255, 243, 134, 84),
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
                      checkColor: Color.fromRGBO(248, 105, 17, 1),
                      fillColor: WidgetStatePropertyAll(Color.fromARGB(255, 243, 220, 205)),
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
                      checkColor: Color.fromRGBO(248, 105, 17, 1),
                      fillColor: WidgetStatePropertyAll(Color.fromARGB(255, 243, 220, 205)),
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
                      checkColor: Color.fromRGBO(248, 105, 17, 1),
                      fillColor: WidgetStatePropertyAll(Color.fromARGB(255, 243, 220, 205)),
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
                      checkColor:Color.fromRGBO(248, 105, 17, 1),
                      fillColor: WidgetStatePropertyAll(Color.fromARGB(255, 243, 220, 205)),
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
            SizedBox(height: 160),
            Center(
              child: ElevatedButton(
                onPressed: generatePassword,
                child: Text(
                  'Generate',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 17,
                  ),
                ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
