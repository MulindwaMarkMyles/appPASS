// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SharePage extends StatefulWidget {
  const SharePage({Key? key}) : super(key: key);

  @override
  SharePageState createState() => SharePageState();
}

class SharePageState extends State<SharePage> {
  bool viewOnly = false;
  bool viewAndEdit = false;
  bool require2FA = false;
  bool notifyOnAccess = false;
  bool receiveEmailConfirmation = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/Image1.png',
              width: 40, // Adjust size as needed
              height: 40, // Adjust size as needed
            ),
            SizedBox(width: 10), // Adjust spacing between logo and title
            Text(
              'Share Password',
              style: TextStyle(
                fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                color: Color.fromARGB(255, 243, 134, 84),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Recipient's email",
                labelStyle: TextStyle(
                  fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Permissions',
              style: TextStyle(
                fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            CheckboxListTile(
              title: Text('View only'),
              value: viewOnly,
              onChanged: (bool? value) {
                setState(() {
                  viewOnly = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('View and Edit'),
              value: viewAndEdit,
              onChanged: (bool? value) {
                setState(() {
                  viewAndEdit = value!;
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Expiration date'),
              onTap: () {
                // Logic to select expiration date
              },
            ),
            CheckboxListTile(
              title: Text('Require 2-Factor authentication'),
              value: require2FA,
              onChanged: (bool? value) {
                setState(() {
                  require2FA = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Notify on Access'),
              value: notifyOnAccess,
              onChanged: (bool? value) {
                setState(() {
                  notifyOnAccess = value!;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Receive an email confirmation.'),
              value: receiveEmailConfirmation,
              onChanged: (bool? value) {
                setState(() {
                  receiveEmailConfirmation = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              '⚠️ The recipient will receive an email with a link to view the password',
              style: TextStyle(
                fontFamily: GoogleFonts.getFont('Poppins').fontFamily,
                color: Colors.orange,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logic to share the password
                 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 243, 134, 84),
                ),
                child: Text(
                  'Share',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
