import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'PasskeysPage.dart';
import 'all.dart';
import 'codes.dart';
import 'Wifi.dart';
import 'security.dart';
import 'deleted.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:app_pass/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';



class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _db =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  bool uploaded = false;
  final List<Category> categories = [
    Category('All', 0, Ionicons.key_outline, All()),
    Category('Passkeys', 0, Ionicons.person_outline, PasskeysPage()),
    Category('Codes', 0, Ionicons.lock_closed_outline, Codes()),
    Category('Wi-Fi', 0, Ionicons.wifi_outline, Wifi()),
    Category('Security', 0, Ionicons.alert_circle_outline, Security()),
    Category('Deleted', 0, Ionicons.trash_bin_outline, Deleted()),
  ];

  Future<void> _importPasswords(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      print("File name: ${file.name}");
      print("File size: ${file.size}");

      List<List<dynamic>> csvTable = [];

      if (kIsWeb) {
        if (file.bytes != null) {
          String fileContent = String.fromCharCodes(file.bytes!);
          csvTable = const CsvToListConverter().convert(fileContent);
        } else {
          _showError("Selected file is empty or couldn't be read.");
        }
      } else {
        if (file.path != null) {
          File csvFile = File(file.path!);
          String fileContent = await csvFile.readAsString();
          csvTable = const CsvToListConverter().convert(fileContent);
        } else {
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
      _showError("No file selected.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showPopupMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Ionicons.cloud_upload_outline),
                title: Text('Import Passwords'),
                onTap: () {
                  Navigator.pop(context);
                  _importPasswords(
                      context); // Call the import function directly
                },
              ),
              ListTile(
                leading: Icon(Ionicons.add_circle_outline),
                title: Text('Add Password Manually'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddPasswordPage(categories: categories),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
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
              style: GoogleFonts.poppins(
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
              decoration: InputDecoration(
                prefixIcon: Icon(Ionicons.search_outline,
                    color: Color.fromARGB(255, 243, 134, 84)),
                hintText: 'Search',
                hintStyle: TextStyle(color: Color.fromARGB(255, 9, 3, 3)),
                filled: true,
                fillColor: Color.fromRGBO(246, 208, 183, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  title: category.title,
                  count: category.count,
                  icon: category.icon,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => category.page,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPopupMenu(context),
        backgroundColor: Color.fromARGB(255, 243, 117, 59),
        child: Icon(Ionicons.add_circle_outline, color: Colors.white),
      ),
    );
  }
}

class Category {
  final String title;
  final int count;
  final IconData icon;
  final Widget page;

  Category(this.title, this.count, this.icon, this.page);
}

class CategoryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Color.fromARGB(255, 243, 220, 205),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Color.fromARGB(255, 243, 117, 59), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: const Color.fromARGB(255, 21, 16, 8)),
              SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 21, 16, 8),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '$count',
                style: GoogleFonts.poppins(
                  color: const Color.fromARGB(255, 21, 16, 8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddPasswordPage extends StatefulWidget {
  final List<Category> categories;

  const AddPasswordPage({Key? key, required this.categories}) : super(key: key);

  @override
  AddPasswordPageState createState() => AddPasswordPageState();
}

class AddPasswordPageState extends State<AddPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      final email = _emailController.text;
      final notes = _notesController.text;
      final category = _selectedCategory;

      try {
        if (category != null) {
          final passwordData = {
            'username': username,
            'password': password,
            'email': email,
            'notes': notes,
            'category': category,
          };

          // Save the password to Firestore
          await FirebaseFirestore.instance
              .collection('passwords')
              .add(passwordData);

          // Update the password count for the selected category
          final categoryDocRef =
              FirebaseFirestore.instance.collection('categories').doc(category);
          final categoryDoc = await categoryDocRef.get();
          final currentCount = categoryDoc.data()?['count'] ?? 0;
          await categoryDocRef.update({'count': currentCount + 1});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password saved successfully!')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a category.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save password. Please try again.')),
        );
        print('Error saving password: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Password'),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a username' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a password' : null,
                obscureText: true,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an email' : null,
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notes'),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: 'Category'),
                items: widget.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.title,
                    child: Text(category.title),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePassword,
                child: Text('Save Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 243, 117, 59),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
