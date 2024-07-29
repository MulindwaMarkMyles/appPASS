import 'package:app_pass/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future registerWithEmailAndPassword(
      String email,
      String password,
      String name,
      String username,
      int phoneNumber,
      String recoveryEmail) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseService(uid: user!.uid)
          .updateUserData(username, name, phoneNumber, recoveryEmail);
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
  
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Initiate the Google Sign-In process
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Check if the user canceled the sign-in
      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }

      // Obtain the authentication details from the Google user
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential using the obtained tokens
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Extract user details from the GoogleSignInAccount
      String displayName = googleUser.displayName ?? '';
      String email = googleUser.email;
      String username = email.split('@')[0];
      String uid = userCredential.user?.uid ?? '';

      // Create an instance of DatabaseService
      DatabaseService dbService = DatabaseService(uid: uid);

      // Update the user data in Firestore
      await dbService.updateUserData(
        username,
        displayName,
        0, // Assuming phone number is not provided by Google
       email,
      );

      return userCredential;
    } catch (e) {
      // Print the error message and return null
      print(e.toString());
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
