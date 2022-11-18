import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deardiary/services/database.dart';
import 'package:deardiary/services/sharedpreferencehelper.dart';
import 'package:deardiary/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DataMethods dataMethods = DataMethods();
  DocumentSnapshot documentSnapshot;

  TheUser _userFromFirebaseUser(User user) {
    return user != null ? TheUser(userId: user.uid) : null;
  }

  getUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final String uid = pref.getString('userIDReference');
    documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return documentSnapshot;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      pref.setString('userIDReference', firebaseUser.uid);
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpwithEmailAndPassword(
      String userName, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      dataMethods.updateUserData1(userName, email, firebaseUser.uid);
      // dataMethods.updateUserData2('dummy', 'dummy', 'dummy', firebaseUser.uid);
      // print('user has been createed');
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.clear();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> validatePassword(String password) async {
    var firebaseUser = await _auth.currentUser;

    var authCredential = EmailAuthProvider.credential(
        email: firebaseUser.email, password: password);

    try {
      var authResult =
          await firebaseUser.reauthenticateWithCredential(authCredential);

      return authResult != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> validateCurrentPassword(String password) async {
    return await validatePassword(password);
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = await _auth.currentUser;
    firebaseUser.updatePassword(password);
  }

  updateUserPassword(String password) {
    updatePassword(password);
  }
}
