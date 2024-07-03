import 'package:flutter/material.dart';
import 'package:app_pass/actions/bottom_bar.dart';

class PasswordHealth extends StatefulWidget {
  @override
  _PasswordHealthState createState() => _PasswordHealthState();
}

class _PasswordHealthState extends State<PasswordHealth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Health'),
      ),
      body: Center(
        child: Text('Password Health'),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}