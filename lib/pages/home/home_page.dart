import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'newpassword.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Category> categories = [
    Category('All', 0, Ionicons.key_outline),
    Category('Passkeys', 0, Ionicons.person_outline),
    Category('Codes', 0, Ionicons.lock_closed_outline),
    Category('Wi-Fi', 0, Ionicons.wifi_outline),
    Category('Security', 0, Ionicons.alert_circle_outline),
    Category('Deleted', 0, Ionicons.trash_bin_outline),
  ];

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('passwords')
          .get();

      // Load passwords from Firebase
      final passwords = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      // Load passwords from local storage
      final prefs = await SharedPreferences.getInstance();
      final localPasswords = prefs.getStringList('passwords') ?? [];
      final allPasswords = passwords + localPasswords.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

      // Update category counts
      for (final password in allPasswords) {
        for (final category in categories) {
          if (category.title == password['category']) {
            category.count++;
          }
        }
      }

      setState(() {});
    }
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 243, 220, 205),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Ionicons.add_circle_outline, color: Color.fromARGB(255, 243, 117, 59)),
              title: Text('Add New Password', style: TextStyle(color: Color.fromARGB(255, 243, 117, 59))),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddPasswordScreen(onPasswordAdded: _loadPasswords)));
              },
            ),
            ListTile(
              leading: Icon(Ionicons.document_attach_outline, color: Color.fromARGB(255, 243, 117, 59)),
              title: Text('Import Passwords from CSV', style: TextStyle(color: Color.fromARGB(255, 243, 117, 59))),
              onTap: _importPasswordsFromCSV,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _importPasswordsFromCSV() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final lines = content.split('\n');
      final user = FirebaseAuth.instance.currentUser;
      final prefs = await SharedPreferences.getInstance();

      for (final line in lines) {
        if (line.isNotEmpty) {
          final values = line.split(',');
          if (values.length >= 3) {
            final password = {
              'title': values[0],
              'username': values[1],
              'password': values[2],
              'category': values.length > 3 ? values[3] : 'All',
            };

            // Save to Firebase
            if (user != null) {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('passwords')
                  .add(password);
            }

            // Save to local storage
            final localPasswords = prefs.getStringList('passwords') ?? [];
            localPasswords.add(jsonEncode(password));
            await prefs.setStringList('passwords', localPasswords);
          }
        }
      }
      _loadPasswords();
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
                hintText: 'Search Password',
                hintStyle: TextStyle(color: const Color.fromARGB(255, 9, 3, 3)),
                filled: true,
                fillColor: Color.fromRGBO(246, 208, 183, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: const Color.fromARGB(255, 20, 9, 9)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddOptions,
        child: Icon(Ionicons.add, color: Color.fromARGB(255, 243, 117, 59)),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Color.fromARGB(255, 243, 220, 205),
    );
  }
}

class Category {
  final String title;
  int count;
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
        padding: const EdgeInsets.all(5.0),
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

class AddPasswordScreen extends StatelessWidget {
  final Function onPasswordAdded;

  const AddPasswordScreen({required this.onPasswordAdded});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Password'),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      body: Center(
        child: Text('Add Password Screen'),
      ),
    );
  }
}
