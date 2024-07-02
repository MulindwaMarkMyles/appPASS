// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('appPASS'),
        backgroundColor: Color.fromARGB(255, 191, 51, 9),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 80,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'appPASS',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.deepOrange.shade100,
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Update the state of the app
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.vpn_key),
              title: Text('Password Generator'),
              onTap: () {
                // Navigate to the Password Generator screen
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share password'),
              onTap: () {
                // Navigate to the Share password screen
              },
            ),
            ListTile(
              leading: Icon(Icons.health_and_safety),
              title: Text('Password health'),
              onTap: () {
                // Navigate to the Password health screen
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Categories'),
              onTap: () {
                // Navigate to the Categories screen
              },
            ),
            ExpansionTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Account Summary'),
                  onTap: () {
                    // Navigate to the Account Summary screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.security),
                  title: Text('Account Security'),
                  onTap: () {
                    // Navigate to the Account Security screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('General'),
                  onTap: () {
                    // Navigate to the General settings screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.qr_code),
                  title: Text('QRcode'),
                  onTap: () {
                    // Navigate to the QRcode screen
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                  onTap: () {
                    // Navigate to the Profile screen
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome to appPASS!'),
      ),
    );
  }
}
