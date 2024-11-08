import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<MyUser?> currentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return _myUserFromFirebase(user);
    } catch (e) {
      if (kDebugMode) {
        print('Error in currentUser: $e');
      }
    }
    return null;
  }

  MyUser? _myUserFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return MyUser(userID: user.uid, email: user.email!);
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      return _myUserFromFirebase(result.user);
    } catch (e) {
      if (kDebugMode) {
        print('Error in anonymous sign-in: $e');
      }
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error in sign-out: $e');
      }
      return false;
    }
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password, MyUser myUser) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _myUserFromFirebase(result.user);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Firebase create error: ${e.code}');
      }
      return null;
    }
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _myUserFromFirebase(result.user);
    } catch (e) {
      if (kDebugMode) {
        print('Firebase login error: $e');
      }
      return null;
    }
  }
}
