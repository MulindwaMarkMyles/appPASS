import 'package:flutter/material.dart';
import 'package:app_pass/actions/bottom_bar.dart';

class PasswordGenerator extends StatefulWidget {
  @override
  _PasswordGeneratorState createState() => _PasswordGeneratorState();
}

class _PasswordGeneratorState extends State<PasswordGenerator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Generator'),
      ),
      body: Center(
        child: Text('Password Generator'),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}