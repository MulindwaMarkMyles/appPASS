import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:app_pass/pages/settings/email.dart';
// import 'package:app_pass/pages/settings/passwords.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key, required String password}) : super(key: key);

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
        stream: FirebaseFirestore.instance.collection('passwords').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final passwords = snapshot.data?.docs
                  .map((doc) => doc['password'] as String)
                  .toList() ??
              [];

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
            height: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: password,
                  version: QrVersions.auto,
                  size: 200,
                ),
                SizedBox(height: 20),
                Text(
                  'Scan this QR code to get the password',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
