import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:app_pass/actions/biometric.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<List<dynamic>> _passwords = [];

  void _importCsv() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;

      if (file.path != null) {
        File csvFile = File(file.path!);
        String fileContent = await csvFile.readAsString();
        List<List<dynamic>> csvTable =
            const CsvToListConverter().convert(fileContent);
        setState(() {
          _passwords = csvTable;
        });
        // Display success message
        _showMessage("File imported successfully.");
      } else {
        // Handle null path case
        _showMessage("Selected file is empty or couldn't be read.");
      }
    } else {
      // Handle null result case
      _showMessage("No file selected.");
    }
  }

  void _showMessage(String message) {
    if (!mounted) return; // Ensure the widget is still mounted
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _viewPasswords() async {
    bool isSupported = await supportsBiometric();
    bool authenticated = false;
    if (isSupported) {
      authenticated = await authenticate();
    }

    if (!mounted) return; // Ensure the widget is still mounted

    if (authenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PasswordsPage(passwords: _passwords)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication Failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/Image1.png',
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: ElevatedButton.icon(
                onPressed: _importCsv,
                icon: Icon(Ionicons.cloud_upload_outline,
                    color: Color.fromRGBO(248, 105, 17, 1)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                        color: Color.fromRGBO(248, 105, 17, 1), width: 1),
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
                ),
              ),
            ),
            SizedBox(
              width: 350,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Ionicons.add_outline,
                    color: Color.fromRGBO(248, 105, 17, 1)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                        color: Color.fromRGBO(248, 105, 17, 1), width: 1),
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
                ),
              ),
            ),
            SizedBox(
              width: 350,
              child: ElevatedButton.icon(
                onPressed: _viewPasswords,
                icon: Icon(Ionicons.eye_outline,
                    color: Color.fromRGBO(248, 105, 17, 1)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                        color: Color.fromRGBO(248, 105, 17, 1), width: 1),
                  ),
                  backgroundColor: Colors.white,
                ),
                label: Text(
                  "View Password",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(248, 105, 17, 1),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PasswordsPage extends StatelessWidget {
  final List<List<dynamic>> passwords;

  const PasswordsPage({Key? key, required this.passwords}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Passwords',
          style: TextStyle(
            fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
            color: Color.fromARGB(255, 243, 134, 84),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      body: ListView.builder(
        itemCount: passwords.length,
        itemBuilder: (context, index) {
          List<dynamic> passwordDetails = passwords[index];
          return ListTile(
            title: Text(passwordDetails[0]),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: passwordDetails.skip(1).map((detail) {
                return Text(detail.toString());
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
