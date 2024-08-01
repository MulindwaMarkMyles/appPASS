import 'package:flutter/material.dart';

//define stateless widget
class AddPasswordScreen extends StatelessWidget {
  final Function onPasswordAdded;

  // Constructor for AddPasswordScreen
  const AddPasswordScreen({Key? key, required this.onPasswordAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Password'),
        actions: [
          // TextButton to save the password
          TextButton(
            onPressed: () {
              // Save password logic
              onPasswordAdded();
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ListTile for displaying a placeholder icon and text
            ListTile(
              leading: CircleAvatar(
                child: Text('U'),
              ),
              title: const Text('uh'),
            ),
            // TextField for entering the username
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'user',
              ),
            ),
            // TextField for selecting a group with a dropdown icon
            const TextField(
              decoration: InputDecoration(
                labelText: 'Group',
                hintText: 'Not Shared',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
            ),
            const SizedBox(height: 16.0), // Spacing between elements
            
             // TextField for adding notes with multiple lines
            const TextField(
              decoration: InputDecoration(
                labelText: 'Notes',
                hintText: 'Add Notes',
              ),
              maxLines: 4, // Allow multiple lines for notes
            ),
          ],
        ),
      ),
    );
  }
}
