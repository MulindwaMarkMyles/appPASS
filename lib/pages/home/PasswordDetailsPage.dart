import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PasswordDetailsPage extends StatefulWidget {
  final Map<String, dynamic> passwordData;
  final String passwordId;

  const PasswordDetailsPage({
    Key? key,
    required this.passwordData,
    required this.passwordId,
  }) : super(key: key);

  @override
  PasswordDetailsPageState createState() => PasswordDetailsPageState();
}

class PasswordDetailsPageState extends State<PasswordDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.passwordData['username']);
    _passwordController = TextEditingController(text: widget.passwordData['password']);
    _emailController = TextEditingController(text: widget.passwordData['email']);
    _websiteController = TextEditingController(text: widget.passwordData['website']);
    _notesController = TextEditingController(text: widget.passwordData['notes']);
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedData = {
        'username': _usernameController.text,
        'password': _passwordController.text,
        'email': _emailController.text,
        'website': _websiteController.text,
        'notes': _notesController.text,
        'category': widget.passwordData['category'],
      };

      try {
        await FirebaseFirestore.instance.collection('passwords').doc(widget.passwordId).update(updatedData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update password. Please try again.')),
        );
        print('Error updating password: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Details'),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(labelText: 'Website'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a website' : null,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a username' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: false,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a password' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notes'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updatePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 243, 134, 84),
                ),
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
