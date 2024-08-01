import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'PasswordDetailsPage.dart';
import 'package:app_pass/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// Define the All StatefulWidget
class All extends StatefulWidget {
  const All({Key? key}) : super(key: key);

  @override
  _AllState createState() => _AllState();
}

// Define the state for All widget
class _AllState extends State<All> {
  // Initialize a Future to fetch passwords
  late Future<List<Map<String, dynamic>>> _passwordsFuture;
  // Initialize the DatabaseService with the current user's UID
  final DatabaseService _db =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  bool uploaded = false;

// Fetch passwords when the state is initialized
  @override
  void initState() {
    super.initState();
    _passwordsFuture = _db.fetchPasswords('All');
  }

// Refresh the passwords list
  void _refreshPasswords() {
    setState(() {
      _passwordsFuture = _db.fetchPasswords('All');
    });
  }

  // Build the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Ionicons.arrow_back_circle),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/Image1.png',
              width: 40,
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'All Passwords',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Color.fromARGB(255, 243, 134, 84),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      // Body containing a FutureBuilder
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _passwordsFuture,
        builder: (context, snapshot) {
          // Show a loading spinner while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                    color: Color.fromARGB(255, 243, 134, 84), size: 50));
          }
          // Show an error message if an error occurs
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Show a message if no data is available
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No passwords found.'));
          }

          // Retrieve passwords from snapshot
          final passwords = snapshot.data!;

          // Build a list of passwords
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
                  // Display password URL
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
                    // Display a placeholder for the password
                    password['password'] != null
                        ? '.' * (password['password'].length ~/ 4)
                        : '',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Trailing icons for viewing details and deleting
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon button to view password details
                      IconButton(
                        icon: Icon(Ionicons.key_outline),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasswordDetailsPage(
                                passwordData:
                                    password, // This should be a map containing the password details
                                passwordId:
                                    passwordId, // This should be the document ID of the password
                              ),
                            ),
                          );
                        },
                      ),
                      // Icon button to delete the password
                      IconButton(
                        icon: Icon(Ionicons.trash_outline),
                        onPressed: () async {
                          // Confirm deletion
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title:
                                    Text('Delete Password', style: TextStyle()),
                                content: Text(
                                    'Are you sure you want to delete this password?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                          // If confirmed, move the password to the deleted category and refresh the list
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
