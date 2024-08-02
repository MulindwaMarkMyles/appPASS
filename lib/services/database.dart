import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';

class Password {
  final String name;
  final String username;
  final String password;
  final String email;
  final String notes;
  final String category;
  final String url;
  final String id;

  Password(
      {required this.name,
      required this.username,
      required this.password,
      required this.email,
      required this.notes,
      required this.category,
      required this.url,
      required this.id});

  factory Password.fromMap(Map<String, dynamic> data) {
    return Password(
      name: data['name'] ?? '',
      username: data['username'] ?? '',
      password: data['password'] ?? '',
      email: data['email'] ?? '',
      notes: data['notes'] ?? '',
      category: data['category'] ?? '',
      url: data['url'] ?? '',
      id: data['id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'password': password,
      'email': email,
      'notes': notes,
      'category': category,
      'url': url,
    };
  }
}

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

  Future<bool> setMasterPassword(String password) async {
    try {
      final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
      final b64key = Key.fromBase64(base64Encode(key.bytes));
      final fernet = Fernet(b64key);
      final encrypter = Encrypter(fernet);
      await users.doc(uid).set({
        'master-password': encrypter.encrypt(password).base64,
      });
      return true;
    } catch (e) {
      print("Error uploading to Firebase: $e");
      return false;
    }
  }

  Future<bool> checkMasterPassword(String password) async {
    try {
      // Retrieve the document containing the master password
      final snapshot = await users.doc(uid).get();

      // Check if the document exists and contains the 'master-password' field
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('master-password')) {
          final encryptedPassword = data['master-password'];

          final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
          final b64key = Key.fromBase64(base64Encode(key.bytes));
          final fernet = Fernet(b64key);
          final encrypter = Encrypter(fernet);

          // Decrypt the stored password
          final decryptedPassword = encrypter.decrypt64(encryptedPassword);

          // Compare the decrypted password with the input password
          return password == decryptedPassword;
        } else {
          print("Master password not found in the database.");
          return false;
        }
      } else {
        print("Document does not exist or data is null.");
        return false;
      }
    } catch (e) {
      print("Error checking password: $e");
      return false;
    }
  }

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
            'notes': '',
            'email': '',
            'category': 'All',
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

  Future<bool> uploadToFirebaseSingle(
      String name,
      String username,
      String password,
      String email,
      String notes,
      String? category,
      String website) async {
    try {
      final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
      final b64key = Key.fromBase64(base64Encode(key.bytes));
      final fernet = Fernet(b64key);
      final encrypter = Encrypter(fernet);

      CollectionReference userPasswordsCollection =
          users.doc(uid).collection('passwords');

      final encryptedPassword = encrypter.encrypt(password);

      Map<String, dynamic> data = {
        'name': name,
        'url': website,
        'username': username,
        'email': email,
        'notes': notes,
        'category': category,
        'password': encryptedPassword.base64,
      };
      await userPasswordsCollection.add(data);
      return true;
    } catch (e) {
      print("Error uploading to Firebase: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getPasswords() async {
    try {
      final snapshot = await users.doc(uid).collection('passwords').get();

      if (snapshot.docs.isEmpty) {
        return [];
      }

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception("Error fetching passwords: $e");
    }
  }

  Future<List<Password>> getThePasswords() async {
    try {
      QuerySnapshot snapshot =
          await users.doc(uid).collection('passwords').get();
      return snapshot.docs.map((doc) {
        return Password.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Failed to fetch passwords: $e");
      return [];
    }
  }

  Future<String> decryptPassword(String password) async {
    final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
    final b64key = Key.fromBase64(base64Encode(key.bytes));
    final fernet = Fernet(b64key);
    final encrypter = Encrypter(fernet);

    String decryptedPassword = encrypter.decrypt64(password);
    return decryptedPassword;
  }

  Future<String> encryptPassword(String password) async {
    final key = Key.fromUtf8('my32lengthsupersecretnooneknows1');
    final b64key = Key.fromBase64(base64Encode(key.bytes));
    final fernet = Fernet(b64key);
    final encrypter = Encrypter(fernet);

    String encryptedPassword = encrypter.encrypt(password).base64;
    return encryptedPassword;
  }

  Future<Map<String, int>> getCategoryCounts() async {
    try {
      final snapshot = await users.doc(uid).collection('passwords').get();
      final counts = <String, int>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final category = data['category'] ?? 'All';
        if (counts.containsKey(category)) {
          counts[category] = counts[category]! + 1;
        } else {
          counts[category] = 1;
        }
      }

      // Ensure all expected categories are present with at least a count of 0
      const categories = [
        'All',
        'Passkeys',
        'Codes',
        'Wi-Fi',
        'Security',
        'deleted'
      ];
      for (var category in categories) {
        if (!counts.containsKey(category)) {
          counts[category] = 0;
        }
      }

      return counts;
    } catch (e) {
      print("Error fetching category counts: $e");
      return {};
    }
  }

  Future<void> movePasswordToDeleted(String passwordId) async {
    try {
      await users
          .doc(uid)
          .collection('passwords')
          .doc(passwordId)
          .update({'category': 'deleted'});
    } catch (e) {
      print('Error moving password to deleted: $e');
    }
  }

  Future<void> permanentlyDeletePassword(String passwordId) async {
    try {
      await users.doc(uid).collection('passwords').doc(passwordId).delete();
    } catch (e) {
      print('Error permanently deleting password: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPasswords(String category) async {
    try {
      final querySnapshot = await users
          .doc(uid)
          .collection('passwords')
          .where('category', isEqualTo: category)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        final id = doc.id;
        return {'id': id, ...data}; // Include the document ID with the data
      }).toList();
    } catch (e) {
      print('Error fetching passwords: $e');
      return [];
    }
  }
}
