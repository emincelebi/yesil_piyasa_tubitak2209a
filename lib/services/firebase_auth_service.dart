import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
        print('Hata currentUser user $e');
      }
    }
    return null;
  }

  MyUser? _myUserFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return MyUser(userID: user.uid);
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      return _myUserFromFirebase(result.user);
    } catch (e) {
      if (kDebugMode) {
        print('Anonim giriş hata $e');
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
        print('Hata signOut user $e');
      }
      return false;
    }
  }
}
