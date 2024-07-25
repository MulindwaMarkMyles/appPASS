import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUser {
  final String name;
  final String username;
  final int phoneNumber;
  final String recoveryEmail;

  DatabaseUser(
      {required this.name,
      required this.username,
      required this.phoneNumber,
      required this.recoveryEmail});
}

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  // collection reference
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
    if (uid != null) {
      CollectionReference userPasswordsCollection = FirebaseFirestore.instance
          .collection(uid);

      for (List<dynamic> row in csvTable) {
        if (row.length >= 4) {
          // Ensure the row has at least 4 columns
          Map<String, dynamic> data = {
            'name': row[0],
            'url': row[1],
            'username': row[2],
            'password': row[3]
          };
          await userPasswordsCollection.add(data);
        }
      }
      return true;
    } else {
      print("No user is signed in.");
      return false;
    }
  }
}
