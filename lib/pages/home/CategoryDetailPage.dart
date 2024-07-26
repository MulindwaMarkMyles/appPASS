import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryDetailPage extends StatelessWidget {
  final Category category;

  const CategoryDetailPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.title,
          style: GoogleFonts.poppins(
            color: Color.fromARGB(255, 243, 134, 84),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('passwords')
            .where('category', isEqualTo: category.title)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No passwords available in this category.'));
          }

          final passwords = snapshot.data!.docs;

          return ListView.builder(
            itemCount: passwords.length,
            itemBuilder: (context, index) {
              final passwordData = passwords[index].data() as Map<String, dynamic>;
              final username = passwordData['username'] ?? 'No username';
              final email = passwordData['email'] ?? 'No email';
              final website = passwordData['website'] ?? 'No website';
              final notes = passwordData['notes'] ?? 'No notes';

              return ListTile(
                title: Text(username),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: $email'),
                    Text('Website: $website'),
                    Text('Notes: $notes'),
                  ],
                ),
                onTap: () {
                  // Handle tap on password entry if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}

class Category {
  final String title;
  final IconData icon;

  Category(this.title, this.icon);
}
