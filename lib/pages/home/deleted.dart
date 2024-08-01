import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_pass/services/database.dart';


// Function to undo the deletion of a password
// Future<void> _undoDeletePassword(
//     String passwordId, String originalCategory) async {
//   try {
//     await FirebaseFirestore.instance
//         .collection('passwords')
//         .doc(passwordId)
//         .update({
//       'category': originalCategory,
//       'originalCategory':
//           FieldValue.delete(), // Remove the original category field
//     });
//   } catch (e) {
//     print('Error undoing delete: $e');
//   }
// }

// Function to permanently delete a password


class Deleted extends StatefulWidget {
  const Deleted({Key? key}) : super(key: key);

  @override
  DeletedState createState() => DeletedState();
}

class DeletedState extends State<Deleted> {
  final DatabaseService _db =
      DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);
  late Future<List<Map<String, dynamic>>> _passwordsFuture;

  @override
  void initState() {
    super.initState();
    _passwordsFuture = _db.fetchPasswords("deleted");
  }

  void _refreshPasswords() {
    setState(() {
      _passwordsFuture = _db.fetchPasswords("deleted");
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _passwordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No deleted passwords found.'));
          }

          final passwords = snapshot.data!;
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
                      // IconButton(
                      //   icon: Icon(Ionicons.arrow_undo_outline),
                      //   onPressed: () async {
                      //     // Undo the deletion
                      //     await _undoDeletePassword(passwordId, originalCategory);
                      //     // Refresh the list
                      //     _refreshPasswords();
                      //   },
                      // ),
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