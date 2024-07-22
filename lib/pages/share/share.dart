import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart'; // For email launching

class SharePasswordScreen extends StatefulWidget {
  final String password; // Pass the password to be shared

  SharePasswordScreen({required this.password, Key? key}) : super(key: key);

  @override
  _SharePasswordScreenState createState() => _SharePasswordScreenState();
}

class _SharePasswordScreenState extends State<SharePasswordScreen> {
  void _shareViaEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '',
      queryParameters: {
        'subject': 'Sharing Password',
        'body': 'Here is the password: ${widget.password}',
      },
    );
    await launch(emailLaunchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Password'),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a method to share your password:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _shareViaEmail,
              child: Row(
                children: [
                  Icon(Ionicons.mail_outline),
                  SizedBox(width: 8),
                  Text('Share via Email'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
