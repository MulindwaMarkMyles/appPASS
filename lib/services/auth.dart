import 'package:firebase_auth/firebase_auth.dart';

class CustomUser {
  final String uid;
  final String email;
  final String? displayName;
  CustomUser({required this.uid, required this.email, this.displayName});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error sending password reset email: $e');
      // Handle error here, e.g., show error message to user
    }
  }

  CustomUser? _userFromFirebaseUser(User? user) {
    if (user == null) return null;
    return CustomUser(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
    );
  }

  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future<CustomUser?> getCurrentUser() async {
    User? user = _auth.currentUser;
    return _userFromFirebaseUser(user);
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print("Failed to sign in");
      return null;
    }
  }

  Future signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      print("Failed to sign in");
      return null;
    }
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
