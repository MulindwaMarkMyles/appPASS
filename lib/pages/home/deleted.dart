import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_pass/services/database.dart';

//define the deleted statefulwidget
class Deleted extends StatefulWidget {
  const Deleted({Key? key}) : super(key: key);

  @override
  DeletedState createState() => DeletedState();
}

// Define the state for Deleted widget
class DeletedState extends State<Deleted> {
  final DatabaseService _db =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  late Future<List<Map<String, dynamic>>> _passwordsFuture;

// Fetch passwords when the state is initialized
  @override
  void initState() {
    super.initState();
    _passwordsFuture = _db.fetchPasswords("deleted");
  }

// Refresh the passwords list
  void _refreshPasswords() {
    setState(() {
      _passwordsFuture = _db.fetchPasswords("deleted");
    });
  }

 // Confirm and permanently delete a password
  Future<void> _confirmPermanentlyDeletePassword(String passwordId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Permanently Delete Password'),
          content: Text(
              'Are you sure you want to permanently delete this password? This action cannot be undone.'),
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
      await _db.permanentlyDeletePassword(passwordId);
      _refreshPasswords();
    }
  }

// Build the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       // AppBar configuration
      appBar: AppBar(
        title: Text(
          'Deleted Passwords',
          style: GoogleFonts.poppins(
            color: Color.fromARGB(255, 243, 134, 84),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      // Body containing a FutureBuilder
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _passwordsFuture,
        builder: (context, snapshot) {
          // Show a loading spinner while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Show an error message if an error occurs
           else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } 
           // Show a message if no data is available
           else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No deleted passwords found.'));
          }

          // Retrieve passwords from snapshot
          final passwords = snapshot.data!;
          
          // Build a list of passwords
          return ListView.builder(
            itemCount: passwords.length,
            itemBuilder: (context, index) {
              final password = passwords[index];
              final passwordId = password['id'];
              // final originalCategory =
              //     password['originalCategory'] ?? 'unknown';

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
                  // Display URL
                  title: Text(
                    password['url'] ?? 'url',
                    style: GoogleFonts.poppins(
                      color: Color.fromARGB(255, 243, 134, 84),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  // Display a placeholder for the password
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
                    // Trailing icons for permanently deleting
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Ionicons.trash_outline),
                        onPressed: () async {
                          // Confirm and permanently delete the password
                          await _confirmPermanentlyDeletePassword(passwordId);
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
