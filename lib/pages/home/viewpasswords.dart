import 'package:flutter/material.dart';
import 'individual.dart';

class ViewPasswordsScreen extends StatelessWidget {
  const ViewPasswordsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passkeys'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text('B'),
            ),
            title: const Text('binance.com'),
            subtitle: const Text('kiggundusulaiman332@gmail.com'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IndividualPasswordViewScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Text('G'),
            ),
            title: const Text('Google'),
            subtitle: const Text('kiggundusulaiman50@gmail.com'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IndividualPasswordViewScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Text('J'),
            ),
            title: const Text('Jumia Uganda'),
            subtitle: const Text('+256708503025'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IndividualPasswordViewScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
