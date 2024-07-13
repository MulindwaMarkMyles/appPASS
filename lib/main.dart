import 'package:flutter/material.dart';
import 'package:biometric_authentication/biometric_authentication.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biometric Auth Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biometric Auth Example'),
      ),
      body: Center(
        child: BiometricAuthService(
          title: 'Biometric Authentication',
          onAuthentication: (bool isAuthenticated) {
            // Handle authentication status here
            if (isAuthenticated) {
              //authentication completed than move that to the next screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SecondScreen()),
              );
              // Authentication successful
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Authentication successful'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              // Authentication failed
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Authentication failed'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}


//screen showed if the authentication completed successfully
import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      //text after successful authentication of any biometric
      body: const Center(
        child: Text('Welcome to the second screen!'),
      ),
    );
  }
}