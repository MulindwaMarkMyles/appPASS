import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PasswordDetailsPage.dart';

Future<List<Map<String, dynamic>>> _fetchPasswords(String category) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('passwords')
        .where('category', isEqualTo: category)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;
      return {'id': id, ...data}; // Include the document ID with the data
    }).toList();
  } catch (e) {
    print('Error fetching passwords: $e');
    return [];
  }
}

Future<void> _movePasswordToDeleted(String passwordId) async {
  try {
    await FirebaseFirestore.instance
        .collection('passwords')
        .doc(passwordId)
        .update({'category': 'deleted'});
  } catch (e) {
    print('Error moving password to deleted: $e');
  }
}


class Codes extends StatefulWidget {
  @override
  CodesState createState() => CodesState();
}

class CodesState extends State<Codes> {
  late Future<List<Map<String, dynamic>>> _passwordsFuture;

  @override
  void initState() {
    super.initState();
    _passwordsFuture = _fetchPasswords('Codes');
  }

  void _refreshPasswords() {
    setState(() {
      _passwordsFuture = _fetchPasswords('Codes');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Codes',
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
              return ListTile(
                title: Text(password['username'] ?? 'username'),
                subtitle: Text('.' * (password['password']?.length ?? 0)),
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
                          await _movePasswordToDeleted(passwordId);
                          // Refresh the list
                          _refreshPasswords();
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

