import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'PasswordDetailsPage.dart';
import 'package:app_pass/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasskeysPage extends StatefulWidget {
  const PasskeysPage({Key? key}) : super(key: key);
 // Changed the class name to 'PasskeysPage'
  @override
  PasskeysPageState createState() => PasskeysPageState();
}

class PasskeysPageState extends State<PasskeysPage> {
  final DatabaseService _db =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  late Future<List<Map<String, dynamic>>> _passwordsFuture;

  @override
  void initState() {
    super.initState();
    _passwordsFuture = _db.fetchPasswords('Passkeys'); // Changed the category to 'Passkeys'
  }

  void _refreshPasswords() {
    setState(() {
      _passwordsFuture = _db.fetchPasswords('Passkeys'); // Changed the category to 'Passkeys'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Passkeys Passwords',
          style: GoogleFonts.poppins(
            color: Color.fromARGB(255, 243, 134, 84),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _passwordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No passwords found.'));
          }

          final passwords = snapshot.data!;
          return ListView.builder(
            itemCount: passwords.length,
            itemBuilder: (context, index) {
              final password = passwords[index];
              final passwordId = password['id']; // Get the document ID
              return Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(250, 230, 216, 1), // Add margin here
                  border: Border.all(
                      color: Color.fromARGB(139, 0, 0, 0), width: 1.2),
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey
                          .withOpacity(0.3), // Shadow color with opacity
                      spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: Offset(0, 3), // Offset in the x and y direction
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    password['url'] ?? 'url',
                    style: GoogleFonts.poppins(
                      color: Color.fromARGB(255, 243, 134, 84),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: Text(
                    password['password'] != null
                        ? '.' * (password['password'].length ~/ 4)
                        : '',
                    style:TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Ionicons.key_outline),
                        onPressed: () {
                          // Navigate to the password details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasswordDetailsPage(
                                passwordData: password, // This should be a map containing the password details
                                passwordId: passwordId, // This should be the document ID of the password
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Ionicons.trash_outline),
                        onPressed: () async {
                          // Confirm deletion
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete Password'),
                                content: Text('Are you sure you want to delete this password?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (shouldDelete ?? false) {
                            // Move the password to the deleted category
                            await _db.movePasswordToDeleted(passwordId);
                            // Refresh the list
                            _refreshPasswords();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}