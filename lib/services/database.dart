import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
// import 'dart:convert';
// import 'dart:math';
// import 'dart:typed_data';

class DatabaseUser {
  final String name;
  final String username;
  final int phoneNumber;
  final String recoveryEmail;

  DatabaseUser({
    required this.name,
    required this.username,
    required this.phoneNumber,
    required this.recoveryEmail,
  });
}

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> updateUserData(String username, String name, int phoneNumber,
      String recoveryEmail) async {
    return await users.doc(uid).set({
      'username': username,
      'phoneNumber': phoneNumber,
      'name': name,
      'recoveryEmail': recoveryEmail,
    });
  }

  // user from uid
  Future<DatabaseUser?> userFromUid() async {
    try {
      final docSnapshot = await users.doc(uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()! as Map<String, dynamic>;
        return DatabaseUser(
          name: data['name'] ?? '',
          username: data['username'] ?? '',
          phoneNumber: data['phoneNumber'] ?? 0,
          recoveryEmail: data['recoveryEmail'] ?? '',
        );
      } else {
        print("No user found with uid: $uid");
        // Handle the case where the user document doesn't exist
        return null; // Or return a default user object
      }
    } catch (e) {
      print("Error fetching user data: $e");
      // Handle other potential errors
      return null; // Or return a default user object
    }
  }

  Future<bool> uploadToFirebase(List<List<dynamic>> csvTable) async {
    try {
      final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
      final b64key = Key.fromBase64(base64Encode(key.bytes));
      final fernet = Fernet(b64key);
      final encrypter = Encrypter(fernet);
      String password;

      CollectionReference userPasswordsCollection =
          users.doc(uid).collection('passwords');

      for (List<dynamic> row in csvTable) {
        if (row.length >= 4) {
          password = row[3].toString();
          if (password.isEmpty) {
            print('Password is empty, defaulting to one.');
            password = "default-password-apppass";
          }

          final encryptedPassword = encrypter.encrypt(password);

          Map<String, dynamic> data = {
            'name': row[0].toString(),
            'url': row[1].toString(),
            'username': row[2].toString(),
            'password': encryptedPassword.base64,
          };
          await userPasswordsCollection.add(data);
        }
      }
      return true;
    } catch (e, stacktrace) {
      print("Error uploading to Firebase: $e");
      print("Stack trace: $stacktrace");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getPasswords() async {
    try {
      final snapshot = await users.doc(uid).collection('passwords').get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception("Error fetching passwords: $e");
    }
  }

  Future<List<Map<String, dynamic>>> decryptPasswords(
    List<Map<String, dynamic>> encryptedPasswords) async {
    final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
      final b64key = Key.fromBase64(base64Encode(key.bytes));
      final fernet = Fernet(b64key);
      final encrypter = Encrypter(fernet);


    return Future.wait(encryptedPasswords.map((password) async {
      final decryptedPassword =
      encrypter.decrypt64(password['password'].toString());
      return {
        'name': password['name'],
        'url': password['url'],
        'username': password['username'],
        'password': decryptedPassword,
        'category': password['category'] ??
            'All', // Assuming each password has a category field
      };
    }));
  }
}
