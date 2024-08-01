import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SharePage extends StatelessWidget {
  SharePage({Key? key, required this.password}) : super(key: key);

  final String password;
  final uid = FirebaseAuth.instance.currentUser!.uid;

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
              'Share Password',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('passwords')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No passwords found'));
          }

          final passwords = snapshot.data!.docs;

          return ListView.builder(
            itemCount: passwords.length,
            itemBuilder: (context, index) {
              final passwordData = passwords[index].data() as Map<String, dynamic>;

              return Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(250, 230, 216, 1), // Add margin here
                  border: Border.all(
                      color: Color.fromARGB(139, 0, 0, 0), width: 1.2),
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Shadow color with opacity
                      spreadRadius: 2, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: Offset(0, 3), // Offset in the x and y direction
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    passwordData['url'] ?? 'url',
                    style: GoogleFonts.poppins(
                      color: Color.fromARGB(255, 243, 134, 84),
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  subtitle: Text(
                    passwordData['password'] != null
                        ? '.' * (passwordData['password'].length ~/ 4)
                        : '',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'email') {
                        _sharePasswordViaEmail(passwordData['password']);
                      } else if (value == 'qr') {
                        _showQRCode(context, passwordData['password']);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'email',
                        child: Text('Share via Email'),
                      ),
                      PopupMenuItem(
                        value: 'qr',
                        child: Text('Generate QR Code'),
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

  void _sharePasswordViaEmail(String password) async {
    final Email email = Email(
      body: 'Here is the password: $password',
      subject: 'Shared Password',
      recipients: ['recipient@example.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      print('Failed to send email: $error');
    }
  }

  void _showQRCode(BuildContext context, String password) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: 250,
            height: 300, // Adjust height to fit all elements comfortably
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrImageView(
                  data: password,
                  version: QrVersions.auto,
                  size: 180, // QR code size
                ),
                SizedBox(height: 10), // Space between logo and text
                Text(
                  'Scan this QR code to get the password',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10), // Add space between QR code and logo/text
                Image.asset(
                  'assets/Image1.png', // Replace with your logo file path
                  width: 55, // Logo size
                  height: 55, // Logo size
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
