// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HOME',
          style: TextStyle(
             
            color: Color.fromARGB(255, 243, 134, 84),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 245, 183, 145),
      ),
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 243, 220, 205), // Background color for the drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: null,
              ),
              ListTile(
                leading: Icon(Icons.home, color: Color.fromARGB(255, 113, 71, 36)),
                title: Text(
                  'Home',
                  style: TextStyle(color: Color.fromARGB(255, 113, 71, 36)),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.vpn_key, color: Color.fromARGB(255, 113, 71, 36)),
                title: Text(
                  'Password Generator',
                  style: TextStyle(color: Color.fromARGB(255, 113, 71, 36)),
                ),
                onTap: () {
                  // Navigate to the Password Generator screen
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: Color.fromARGB(255, 113, 71, 36)),
                title: Text(
                  'Share password',
                  style: TextStyle(color: Color.fromARGB(255, 113, 71, 36)),
                ),
                onTap: () {
                  // Navigate to the Share password screen
                },
              ),
              ListTile(
                leading: Icon(Icons.health_and_safety, color: Color.fromARGB(255, 113, 71, 36)),
                title: Text(
                  'Password health',
                  style: TextStyle(color: Color.fromARGB(255, 113, 71, 36)),
                ),
                onTap: () {
                  // Navigate to the Password health screen
                },
              ),
              ListTile(
                leading: Icon(Icons.category, color: Color.fromARGB(255, 113, 71, 36)),
                title: Text(
                  'Categories',
                  style: TextStyle(color: Color.fromARGB(255, 113, 71, 36)),
                ),
                onTap: () {
                  // Navigate to the Categories screen
                },
              ),
              ExpansionTile(
                leading: Icon(Icons.settings, color: Color.fromARGB(255, 113, 71, 36)),
                title: Text(
                  'Settings',
                  style: TextStyle(color: Color.fromARGB(255, 113, 71, 36)),
                ),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.account_circle, color: Color.fromARGB(255, 113, 71, 36)),
                    title: Text(
                      'Account Summary',
                      style: TextStyle(color: Color.fromARGB(255, 113, 71, 36)),
                    ),
                    onTap: () {
                      // Navigate to the Account Summary screen
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.security, color: Color.fromARGB(255, 113, 71, 36)),
                    title: Text(
                      'Account Security',
                      style: TextStyle(color: Color.fromARGB(255, 113, 71, 36)),
                    ),
                    onTap: () {
                      // Navigate to the Account Security screen
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Color.fromARGB(255, 113, 71, 36)),
                    title: Text(
                      'General',
                      style: TextStyle(color: Color.fromARGB(255, 113, 71, 36)),
                    ),
                    onTap: () {
                      // Navigate to the General settings screen
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.qr_code, color: Color.fromARGB(255, 113, 71, 36)),
                    title: Text(
                      'QRcode',
                      style: TextStyle(color: Color.fromARGB(255, 113, 71, 36)),
                    ),
                    onTap: () {
                      // Navigate to the QRcode screen
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: Color.fromARGB(255, 113, 71, 36)),
                    title: Text(
                      'Profile',
                      style: TextStyle(color: Color.fromARGB(255, 113, 71, 36)),
                    ),
                    onTap: () {
                      // Navigate to the Profile screen
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text('Welcome to appPASS!'),
      ),
    );
  }
}
