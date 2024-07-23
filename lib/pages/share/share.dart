import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key, required this.password}) : super(key: key);

  final String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Password'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('passwords').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final passwords = snapshot.data?.docs.map((doc) => doc['password'] as String).toList() ?? [];

          return ListView.builder(
            itemCount: passwords.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(passwords[index]),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'email') {
                      _sharePasswordViaEmail(passwords[index]);
                    } else if (value == 'qr') {
                      _showQRCode(context, passwords[index]);
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
