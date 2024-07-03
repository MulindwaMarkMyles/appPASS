import 'package:flutter/material.dart';
import 'package:app_pass/actions/bottom_bar.dart';

class SharePassword extends StatefulWidget {
  @override
  _SharePasswordState createState() => _SharePasswordState();
}

class _SharePasswordState extends State<SharePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share Password'),
      ),
      body: Center(
        child: Text('Share Password'),
      ),
      bottomNavigationBar: BottomNavBar(index: 2),
    );
  }
}