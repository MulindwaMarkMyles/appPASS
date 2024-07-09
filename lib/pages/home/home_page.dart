import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:csv/csv.dart';

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

    if (result != null) {
      String fileContent = utf8.decode(result.files.first.bytes!);
      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(fileContent);
      setState(() {
        _passwords = csvTable;
      });
    }
  }

  void _viewPasswords() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PasswordsPage(passwords: _passwords)),
    );
  }

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
            List<dynamic> passwordDetails =
                passwords[index]; // Get the details of each password
            return ListTile(
              title: Text(
                  passwordDetails[0]), // Assuming first column is password name
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: passwordDetails.skip(1).map((detail) {
                  // Iterate over the remaining fields
                  return Text(
                      detail.toString()); // Display each field as a Text widget
                }).toList(),
              ),
            );
          },
          ),
    );
  }
}
