import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: Text('Settings'),
        ),
        Expanded(
          child: Center(
            child: Text('Settings Screen'),
          ),
        ),
      ],
    );
  }
}
