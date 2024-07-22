import 'package:flutter/material.dart';

class PasswordSelectionScreen extends StatefulWidget {
  final String email;

  PasswordSelectionScreen({required this.email, Key? key}) : super(key: key);

  @override
  _PasswordSelectionScreenState createState() => _PasswordSelectionScreenState();
}

class _PasswordSelectionScreenState extends State<PasswordSelectionScreen> {
  final List<String> _passwords = ['Password1', 'Password2', 'Password3']; // Example passwords
  final Set<String> _selectedPasswords = {};

  void _toggleSelection(String password) {
    setState(() {
      if (_selectedPasswords.contains(password)) {
        _selectedPasswords.remove(password);
      } else {
        _selectedPasswords.add(password);
      }
    });
  }

  void _sendPasswords() {
    if (_selectedPasswords.isNotEmpty) {
      // Implement sending logic here
      // For example, you could send an email or save the information
      print('Sending passwords: ${_selectedPasswords.join(', ')} to ${widget.email}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Passwords to Share'),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
        Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Select the passwords you want to share with ${widget.email}:',
style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
),
SizedBox(height: 16),
Expanded(
child: ListView(
children: _passwords.map((password) {
return ListTile(
title: Text(password),
trailing: Checkbox(
value: _selectedPasswords.contains(password),
onChanged: (checked) {
_toggleSelection(password);
},
),
);
}).toList(),
),
),
SizedBox(height: 16),
ElevatedButton(
onPressed: _sendPasswords,
child: Text('Send'),
),
],
),
),
);
}
}








