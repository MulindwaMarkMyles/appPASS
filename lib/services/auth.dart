import 'package:firebase_auth/firebase_auth.dart';

class CustomUser {
  final String uid;
  CustomUser({required this.uid});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CustomUser? _userFromFirebaseUser(User? user) {
    if (user == null) return null;
    return CustomUser(uid: user.uid);
  }

  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future registerwithemailandpassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print("failed to sign in");
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
      print("failed to sign in");
      return null;
    }
  }

  Future SignInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
