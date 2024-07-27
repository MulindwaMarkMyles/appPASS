import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImportPasswordsPage extends StatefulWidget {
  const ImportPasswordsPage({Key? key}) : super(key: key);
  @override
  ImportPasswordsPageState createState() => ImportPasswordsPageState();
}

class ImportPasswordsPageState extends State<ImportPasswordsPage> {
  Future<void> _importPasswords() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      final csvContent = String.fromCharCodes(file.bytes!);

      try {
        List<List<dynamic>> rows = const CsvToListConverter().convert(csvContent);

        for (var row in rows) {
          if (row.length >= 5) {
            final username = row[0].toString();
            final password = row[1].toString();
            final email = row[2].toString();
            final website = row[3].toString();
            final notes = row[4].toString();

            final passwordData = {
              'username': username,
              'password': password,
              'email': email,
              'website': website,
              'notes': notes,
              'category': 'All',
            };

            await FirebaseFirestore.instance.collection('passwords').add(passwordData);
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords imported successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to import passwords. Please try again.')),
        );
        print('Error importing passwords: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import Passwords'),
        backgroundColor: Color.fromRGBO(246, 208, 183, 1),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _importPasswords,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 243, 134, 84),
          ),
          child: Text('Import CSV'),
        ),
      ),
    );
  }
}
