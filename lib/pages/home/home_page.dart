import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:app_pass/actions/biometric_stub.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:app_pass/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<List<dynamic>> _passwords = [];
  final User? user = FirebaseAuth.instance.currentUser;
  final DatabaseService _db =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  bool uploaded = false;
  final List<Category> categories = [
    Category('All', 100, Ionicons.key_outline),
    Category('Passkeys', 20, Ionicons.person_outline),
    Category('Codes', 15, Ionicons.lock_closed_outline),
    Category('Wi-Fi', 25, Ionicons.wifi_outline),
    Category('Security', 10, Ionicons.alert_circle_outline),
    Category('Deleted', 5, Ionicons.trash_bin_outline),
  ];

  void _importCsv() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;

      // Print file details for debugging
      print("File name: ${file.name}");
      print("File size: ${file.size}");

      List<List<dynamic>> csvTable = [];

      if (kIsWeb) {
        if (file.bytes != null) {
          String fileContent = String.fromCharCodes(file.bytes!);
          csvTable = const CsvToListConverter().convert(fileContent);
          setState(() {
            _passwords = csvTable;
          });
        }
      } else {
        if (file.path != null) {
          File csvFile = File(file.path!);
          String fileContent = await csvFile.readAsString();
          csvTable = const CsvToListConverter().convert(fileContent);
          setState(() {
            _passwords = csvTable;
          });
        } else {
          // Handle null path case
          _showError("Selected file is empty or couldn't be read.");
        }
      }

      uploaded = await _db.uploadToFirebase(csvTable);
      _showError("Uploading passwords, please wait...");

      if (uploaded) {
        _showError("Passwords uploaded successfully.");
        print("done uploading");
      } else {
        _showError("Failed to upload passwords.");
      }
    } else {
      // Handle null result case
      _showError("No file selected.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _viewPasswords() async {
    bool authenticated = false;
    if (kIsWeb) {
      authenticated = true;
    } else {
      authenticated = await isAuthenticated();
    }

    if (authenticated) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => PasswordsPage(passwords: _passwords)),
      // );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Authentication Failed.')));
    }
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                // Handle search logic if needed
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Ionicons.search_outline, color: Color.fromARGB(255, 243, 134, 84)),
                hintText: 'Search',
                hintStyle: TextStyle(color: const Color.fromARGB(255, 9, 3, 3)),
                filled: true,
                fillColor: Color.fromRGBO(246, 208, 183, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1, // Adjust aspect ratio to fit better
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  title: category.title,
                  count: category.count,
                  icon: category.icon,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        // ignore: sort_child_properties_last
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Ionicons.add_circle_outline,
              color:  Color.fromARGB(255, 243, 117, 59),
              size: 30,
            ),
          ),
        ),
        color: Color.fromARGB(255, 243, 220, 205),
      ),
      backgroundColor: Color.fromARGB(255, 243, 220, 205),
    );
  }
}

class Category {
  final String title;
  final int count;
  final IconData icon;

  Category(this.title, this.count, this.icon);
}

class CategoryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 243, 220, 205), // Match the Scaffold background color
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color.fromARGB(255, 243, 117, 59), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Avoid overflow
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: const Color.fromARGB(255, 21, 16, 8)), // Adjust icon size
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 243, 117, 59)), // Adjust text size
              textAlign: TextAlign.center, // Center align text
            ),
            SizedBox(height: 5),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 16, 13, 9)), // Adjust text size
            ),
          ],
        ),
      ),
    );
  }
}
