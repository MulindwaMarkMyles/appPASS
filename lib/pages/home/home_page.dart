import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'PasskeysPage.dart';
import 'all.dart';
import 'codes.dart';
import 'wifi.dart';
import 'security.dart';
import 'deleted.dart';
import 'package:app_pass/pages/home/PasswordDetailsPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:app_pass/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _db =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  bool uploaded = false;
  int _allCount = 0;
  int _passKeyCount = 0;
  int _codesCount = 0;
  int _wifiCount = 0;
  int _securityCount = 0;
  int _deletedCount = 0;
  String password = '';
  bool _isSearching = false;
  List<List<dynamic>> _data = [];
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Password> _passwords = [];
  List<Password> _filteredPasswords = [];
  final List<Category> categories = [
    Category('All', 0, Ionicons.key_outline, All()),
    Category('Passkeys', 0, Ionicons.person_outline, PasskeysPage()),
    Category('Codes', 0, Ionicons.lock_closed_outline, Codes()),
    Category('Wi-Fi', 0, Ionicons.wifi_outline, Wifi()),
    Category('Security', 0, Ionicons.alert_circle_outline, Security()),
    Category('Deleted', 0, Ionicons.trash_bin_outline, Deleted()),
  ];

  @override
  void initState() {
    super.initState();
    _initializeCategoryCounts();
    _searchController.addListener(_updateSearchQuery);
    _searchFocusNode.addListener(_onSearchFocusChange);
    _fetchPasswords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchFocusChange() {
    setState(() {
      _isSearching = _searchFocusNode.hasFocus;
    });
  }

  Future<void> _initializeCategoryCounts() async {
    // Fetch category counts from Firestore and update the state
    try {
      // Assuming you have a function in DatabaseService to get counts
      Map<String, int> counts = await _db.getCategoryCounts();
      setState(() {
        _allCount = counts['All'] ?? 0;
        _passKeyCount = counts['Passkeys'] ?? 0;
        _codesCount = counts['Codes'] ?? 0;
        _wifiCount = counts['Wi-Fi'] ?? 0;
        _securityCount = counts['Security'] ?? 0;
        _deletedCount = counts['deleted'] ?? 0;

        categories[0].count = _allCount;
        categories[1].count = _passKeyCount;
        categories[2].count = _codesCount;
        categories[3].count = _wifiCount;
        categories[4].count = _securityCount;
        categories[5].count = _deletedCount;
      });
    } catch (e) {
      _showMessage("Failed to load category counts: $e");
    }
  }

  void _updateSearchQuery() {
    setState(() {
      _searchQuery = _searchController.text;
      _filteredPasswords = _passwords.where((password) {
        // Adjust the condition here if needed to search other fields
        return password.username
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            password.url.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

  Future<void> _fetchPasswords() async {
    try {
      List<Password> passwords = await _db.getThePasswords();
      setState(() {
        _passwords = passwords;
        _filteredPasswords = passwords;
      });
    } catch (e) {
      _showMessage("Failed to load passwords: $e");
    }
  }

  Future<void> _importPasswords(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.first;
      List<List<dynamic>> csvTable = [];
      _showMessage("Uploading passwords, please wait...");

      try {
        if (kIsWeb) {
          if (file.bytes != null) {
            String fileContent = String.fromCharCodes(file.bytes!);
            csvTable = const CsvToListConverter().convert(fileContent);
            setState(() {
              _data = csvTable;
            });
          } else {
            _showMessage("Selected file is empty or couldn't be read.");
            return;
          }
        } else {
          file = result.files.single;
          if (file.path != null) {
            final input = File(file.path!).openRead();
            csvTable = await input
                .transform(utf8.decoder)
                .transform(const CsvToListConverter(
                    eol: '\n')) // Ensure correct end-of-line handling
                .toList();
            setState(() {
              _data = csvTable;
            });
          } else {
            _showMessage("Selected file is empty or couldn't be read.");
            return;
          }
        }

        // Log the content of csvTable for debugging
        print("CSV Table Content: $csvTable");

        // Log the number of rows to be uploaded
        print("Number of rows to upload: ${csvTable.length}");

        // Upload passwords to Firebase
        bool uploadSuccess = await _db.uploadToFirebase(_data);
        if (uploadSuccess) {
          _showMessage("Passwords uploaded successfully.");
          _initializeCategoryCounts(); // Refresh counts after uploading
        } else {
          _showMessage("Failed to upload passwords.");
        }
      } catch (e) {
        _showMessage("Failed to upload passwords: $e");
      }
    } else {
      _showMessage("No file selected.");
    }
  }

  void _showMessage(String message) {
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
                  _importPasswords(context);
                },
              ),
              ListTile(
                leading: Icon(Ionicons.refresh_circle_outline),
                title: Text('Refresh Counts'),
                onTap: () {
                  _initializeCategoryCounts();
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

  void _cancelSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    setState(() {
      _isSearching = false;
      _filteredPasswords = _passwords;
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
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                prefixIcon: Icon(Ionicons.search_outline,
                    color: Color.fromARGB(255, 243, 134, 84)),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: Icon(Ionicons.close_outline,
                            color: Color.fromARGB(255, 243, 134, 84)),
                        onPressed: _cancelSearch,
                      )
                    : null,
                hintText: 'Search Passwords',
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
            child: _isSearching ? _buildSearchResults() : _buildCategoryGrid(),
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

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: _filteredPasswords.length,
      itemBuilder: (context, index) {
        final password = _filteredPasswords[index];
        return Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color.fromRGBO(250, 230, 216, 1), // Add margin here
            border: Border.all(color: Color.fromARGB(139, 0, 0, 0), width: 1.2),
            borderRadius: BorderRadius.circular(9),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.grey.withOpacity(0.3), // Shadow color with opacity
                spreadRadius: 2, // Spread radius
                blurRadius: 5, // Blur radius
                offset: Offset(0, 3), // Offset in the x and y direction
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              password.username,
              style: GoogleFonts.poppins(
                color: Color.fromARGB(255, 243, 134, 84),
                fontSize: 16,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              password.url,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PasswordDetailsPage(
                    passwordData: password.toMap(),
                    passwordId: password.id,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
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
    );
  }
}

class Category {
  String title;
  int count;
  IconData icon;
  Widget page;

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
  final DatabaseService _db =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final username = _usernameController.text;
      final password = _passwordController.text;
      final email = _emailController.text;
      final notes = _notesController.text;
      final website = _websiteController.text;
      final category = _selectedCategory;

      try {
        if (category != null) {
          bool uploaded = await _db.uploadToFirebaseSingle(
              name, username, password, email, notes, category, website);

          if (uploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Password saved successfully!')),
            );
          }
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
          child: ListView(
            children: [
              buildTextFormField(
                controller: _usernameController,
                prefixIcon: Icon(Ionicons.person_outline,
                    color: Color.fromRGBO(248, 105, 17, 1)),
                labelText: 'Username',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a username' : null,
              ),
              SizedBox(height: 20),
              buildTextFormField(
                controller: _nameController,
                labelText: 'Name',
                validator: (value) => value!.isEmpty
                    ? 'Please enter a name for the password'
                    : null,
                prefixIcon: Icon(Ionicons.person_circle_outline,
                    color: Color.fromRGBO(248, 105, 17, 1)),
              ),
              SizedBox(height: 20),
              buildTextFormField(
                controller: _websiteController,
                labelText: 'Website',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a website or url' : null,
                prefixIcon: Icon(Ionicons.logo_web_component,
                    color: Color.fromRGBO(248, 105, 17, 1)),
              ),
              SizedBox(height: 20),
              buildTextFormField(
                controller: _passwordController,
                labelText: 'Password',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a password' : null,
                prefixIcon: Icon(Ionicons.lock_closed_outline,
                    color: Color.fromRGBO(248, 105, 17, 1)),
                obscureText: true,
              ),
              SizedBox(height: 20),
              buildTextFormField(
                controller: _emailController,
                labelText: 'Email',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an email' : null,
                prefixIcon: Icon(Ionicons.mail_unread_outline,
                    color: Color.fromRGBO(248, 105, 17, 1)),
              ),
              SizedBox(height: 20),
              buildTextFormField(
                controller: _notesController,
                labelText: 'Notes',
                prefixIcon: Icon(Ionicons.text_outline,
                    color: Color.fromRGBO(248, 105, 17, 1)),
                validator: (value) => null,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Ionicons.list_outline,
                      color: Color.fromRGBO(248, 105, 17, 1)),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(248, 105, 17, 1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(248, 105, 17, 1)),
                  ),
                ),
                items: widget.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.title,
                    child: Text(category.title,
                        style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savePassword,
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
                child: Center(
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required String labelText,
    required Icon prefixIcon,
    bool obscureText = false,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      obscureText: obscureText,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon,
        labelStyle: TextStyle(
          color: Colors.black,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(248, 105, 17, 1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(248, 105, 17, 1)),
        ),
      ),
      style: TextStyle(
        color: Colors.black,
        fontFamily: GoogleFonts.poppins().fontFamily,
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
