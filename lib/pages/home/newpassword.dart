import 'package:flutter/material.dart';

class AddPasswordScreen extends StatelessWidget {
  final Function onPasswordAdded;

  const AddPasswordScreen({Key? key, required this.onPasswordAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Password'),
        actions: [
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
            ListTile(
              leading: CircleAvatar(
                child: Text('U'),
              ),
              title: const Text('uh'),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'user',
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Group',
                hintText: 'Not Shared',
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Notes',
                hintText: 'Add Notes',
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}
