import 'package:flutter/material.dart';

//define stateful widget
class IndividualPasswordViewScreen extends StatefulWidget {
  const IndividualPasswordViewScreen({Key? key}) : super(key: key);

  @override
  _IndividualPasswordViewScreenState createState() => _IndividualPasswordViewScreenState();
}

// Define the state for IndividualPasswordViewScreen widget
class _IndividualPasswordViewScreenState extends State<IndividualPasswordViewScreen> {
  bool _isPasswordVisible = false;

  // Function to handle authentication logic
  void _authenticate() {
    // Add authentication logic here
    setState(() {
      _isPasswordVisible = true;
    });
  }

  // Build the widget tree
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar configuration
      appBar: AppBar(
        title: const Text('Passkeys'),
        actions: [
          
          // IconButton for sharing the password
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share password logic
            },
          ),

           // TextButton for editing the password
          TextButton(
            onPressed: () {
              // Edit password logic
            },
            child: const Text(
              'Edit',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

             // ListTile for displaying the password's website and last modified date
            ListTile(
              leading: CircleAvatar(
                child: Text('B'),
              ),
              title: const Text('binance.com'),
              subtitle: const Text('Last modified 14/05/2024'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              obscureText: !_isPasswordVisible,
            ),
            const SizedBox(height: 16.0),
            // Add other content here, such as additional password details or buttons
          ],
        ),
      ),
    );
  }

  // Function to toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }
}
