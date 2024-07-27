import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ionicons/ionicons.dart';

// Function to fetch passwords in the "deleted" category
Future<List<Map<String, dynamic>>> _fetchDeletedPasswords() async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('passwords')
        .where('category', isEqualTo: 'deleted')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final id = doc.id;
      return {'id': id, ...data}; // Include the document ID with the data
    }).toList();
  } catch (e) {
    print('Error fetching deleted passwords: $e');
    return [];
  }
}

// Function to undo the deletion of a password
Future<void> _undoDeletePassword(String passwordId, String originalCategory) async {
  try {
    await FirebaseFirestore.instance
        .collection('passwords')
        .doc(passwordId)
        .update({
      'category': originalCategory,
      'originalCategory': FieldValue.delete(), // Remove the original category field
    });
  } catch (e) {
    print('Error undoing delete: $e');
  }
}

// Function to permanently delete a password
Future<void> _permanentlyDeletePassword(String passwordId) async {
  try {
    await FirebaseFirestore.instance
        .collection('passwords')
        .doc(passwordId)
        .delete();
  } catch (e) {
    print('Error permanently deleting password: $e');
  }
}

class Deleted extends StatefulWidget {
  @override
  DeletedState createState() => DeletedState();
}

class DeletedState extends State<Deleted> {
  late Future<List<Map<String, dynamic>>> _passwordsFuture;

  @override
  void initState() {
    super.initState();
    _passwordsFuture = _fetchDeletedPasswords();
  }

  void _refreshPasswords() {
    setState(() {
      _passwordsFuture = _fetchDeletedPasswords();
    });
  }

  Future<void> _confirmPermanentlyDeletePassword(String passwordId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Permanently Delete Password'),
          content: Text('Are you sure you want to permanently delete this password? This action cannot be undone.'),
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
      await _permanentlyDeletePassword(passwordId);
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
              final originalCategory = password['originalCategory'] ?? 'unknown';

              return ListTile(
                title: Text(password['website'] ?? 'No website'),
                subtitle: Text('.' * (password['password']?.length ?? 0)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Ionicons.arrow_undo_outline),
                      onPressed: () async {
                        // Undo the deletion
                        await _undoDeletePassword(passwordId, originalCategory);
                        // Refresh the list
                        _refreshPasswords();
                      },
                    ),
                    IconButton(
                      icon: Icon(Ionicons.trash_outline),
                      onPressed: () async {
                        // Confirm and permanently delete the password
                        await _confirmPermanentlyDeletePassword(passwordId);
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
